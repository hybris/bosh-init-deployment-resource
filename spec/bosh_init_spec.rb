require 'spec_helper'

describe BoshInitDeploymentResource::CommandRunner do
  let(:command_runner) { BoshInitDeploymentResource::CommandRunner.new }

  describe '.run' do
    it 'takes a command and an environment and spanws a process' do
      expect do
        command_runner.run('sh -c "$PROG"', 'PROG' => 'true')
      end.to_not raise_error
    end

    it('takes an options hash') do
      r, w = IO.pipe
      command_runner.run('sh -c "echo $FOO"', { 'FOO' => 'sup' }, out: w)
      expect(r.gets).to eq("sup\n")
    end

    it 'raises an exception if the command fails' do
      expect do
        command_runner.run('sh -c "$PROG"', 'PROG' => 'false')
      end.to raise_error("command 'sh -c \"$PROG\"' failed!")
    end

    it 'routes all output to stderr' do
      pid = 7223
      # rubocop:disable Style/SpecialGlobalVars
      expect($?).to receive(:success?).and_return(true)
      # rubocop:enable Style/SpecialGlobalVars
      expect(Process).to receive(:wait).with(pid)
      expect(Process).to receive(:spawn)
        .with({}, 'echo "hello"', out: :err, err: :err).and_return(pid)

      command_runner.run('echo "hello"')
    end
  end
end

describe BoshInitDeploymentResource::BoshInit do
  let(:command_runner) do
    instance_double(BoshInitDeploymentResource::CommandRunner)
  end
  let(:bosh) do
    BoshInitDeploymentResource::BoshInit.new(command_runner)
  end
  describe '.deploy' do
    it 'Runs bosh-init deploy and cleans up temp folder' do
      file_path = File.expand_path('manifest.yml', File.dirname(__FILE__))
      key_path = File.expand_path('microbosh.pem', File.dirname(__FILE__))
      bosh.setup_environment(file_path, key_path, 'Test')
      expect(command_runner).to receive(:run)
        .with("bosh-init deploy #{bosh.env_path}/manifest.yml", {}, {})
      bosh.deploy
      expect(File.exist?(bosh.env_path)).to be_falsey
    end

    it 'returns status' do
      file_path = File.expand_path('manifest.yml', File.dirname(__FILE__))
      key_path = File.expand_path('microbosh.pem', File.dirname(__FILE__))
      bosh.setup_environment(file_path, key_path, 'Test')
      expect(command_runner).to receive(:run)
        .with("bosh-init deploy #{bosh.env_path}/manifest.yml", {}, {})
      expect(bosh.deploy).to eq('Test')
    end
  end

  describe '.cleanup_environment' do
    it 'Removes tmp folder' do
      file_path = File.expand_path('manifest.yml', File.dirname(__FILE__))
      key_path = File.expand_path('microbosh.pem', File.dirname(__FILE__))
      bosh.setup_environment(file_path, key_path, 'Test')
      expect(File.exist?(bosh.env_path)).to be_truthy
      bosh.cleanup_environment
      expect(File.exist?(bosh.env_path)).to be_falsey
    end
  end

  describe '.setup_environment' do
    it 'Creates tmp folder' do
      file_path = File.expand_path('manifest.yml', File.dirname(__FILE__))
      key_path = File.expand_path('microbosh.pem', File.dirname(__FILE__))
      bosh.setup_environment(file_path, key_path, 'Test')
      expect(File.exist?(bosh.env_path)).to be_truthy
      bosh.cleanup_environment
    end

    it 'Copies manifest' do
      file_path = File.expand_path('manifest.yml', File.dirname(__FILE__))
      key_path = File.expand_path('microbosh.pem', File.dirname(__FILE__))
      bosh.setup_environment(file_path, key_path, 'Test')
      expect(File.exist?("#{bosh.env_path}/manifest.yml")).to be_truthy
      expect(IO.read("#{bosh.env_path}/manifest.yml")).to eq(IO.read(file_path))
      bosh.cleanup_environment
    end

    it 'Copies key' do
      file_path = File.expand_path('manifest.yml', File.dirname(__FILE__))
      key_path = File.expand_path('microbosh.pem', File.dirname(__FILE__))
      bosh.setup_environment(file_path, key_path, 'Test')
      expect(File.exist?("#{bosh.env_path}/microbosh.pem")).to be_truthy
      expect(IO.read("#{bosh.env_path}/microbosh.pem")).to eq(IO.read(key_path))
      bosh.cleanup_environment
    end

    it 'Stores status' do
      file_path = File.expand_path('manifest.yml', File.dirname(__FILE__))
      key_path = File.expand_path('microbosh.pem', File.dirname(__FILE__))
      bosh.setup_environment(file_path, key_path, 'Test')
      expect(File.exist?("#{bosh.env_path}/manifest-state.json")).to be_truthy
      expect(IO.read("#{bosh.env_path}/manifest-state.json")).to eq('Test')
      bosh.cleanup_environment
    end
  end
end
