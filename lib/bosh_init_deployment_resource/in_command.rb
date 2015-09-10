require 'json'
require 'time'

module BoshInitDeploymentResource
  # Run InCommand
  class InCommand
    def initialize(writer = STDOUT)
      @writer = writer
    end

    def run(_, request)
      fail 'no version specified' unless request['version']

      writer.puts({
        'version' => request.fetch('version')
      }.to_json)
    end

    private

    attr_reader :writer
  end
end
