require 'json'
require 'pty'
require 'tmpdir'
require 'fileutils'

module BoshInitDeploymentResource
  # This is a class to manage bosh-init deployments.
  class BoshInit
    def initialize(command_runner = CommandRunner.new)
      @command_runner = command_runner
    end

    attr_accessor :env_path

    def deploy
      bosh_init("#{@env_path}/manifest.yml")
      state = read_state
      cleanup_environment
      state
    end

    def setup_environment(manifest_path, status, dir = Dir.mktmpdir)
      @env_path = dir
      if status
        File.open("#{@env_path}/manifest-state.json", 'w') do |file|
          file.write(status)
        end
      end

      FileUtils.cp(manifest_path, "#{@env_path}/manifest.yml")
    end

    def cleanup_environment
      FileUtils.remove_entry @env_path
    end

    private

    attr_reader :command_runner

    def bosh_init(manifest, opts = {})
      run("bosh-init deploy #{manifest}", {}, opts)
    end

    def run(command, env = {}, opts = {})
      command_runner.run(command, env, opts)
    end

    def read_state
      IO.read("#{@env_path}/manifest-state.json")
    end
  end

  # Command execution wrapper.
  class CommandRunner
    def run(command, env = {}, opts = {})
      pid = Process.spawn(env, command, { out: :err, err: :err }.merge(opts))
      Process.wait(pid)
      fail "command '#{command}' failed!" unless $?.success?
    end
  end
end
