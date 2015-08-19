require 'spec_helper'

describe 'OutCommand' do
  def in_dir
    Dir.mktmpdir do |working_dir|
      yield working_dir
    end
  end

  def add_manifest(manifest)
    File.open(manifest, 'w') { |file| file.write('your text') }
  end

  let(:request) do
    {
      'source' => {
        'access_key_id' => 'test_key',
        'secret_access_key' => 'secret_access_key',
        'bucket_name' => 'Test',
        'region' => 'us-west-1'
      },
      'params' => {
        'stats_file_key' => 'test-manifest-state.json',
        'manifest_file' => 'manifest.yml'
      }
    }
  end

  let(:bosh) { instance_double(BoshInitDeploymentResource::BoshInit) }
  let(:response) { StringIO.new }
  let(:stats) { instance_double(BoshInitDeploymentResource::BoshStats) }
  let(:command_runner) do
    instance_double(BoshInitDeploymentResource::CommandRunner)
  end

  let(:out_command) do
    BoshInitDeploymentResource::OutCommand
      .new(bosh, response, stub_responses: true)
  end

  context 'with valid inputs' do
    it 'get stats' do
      in_dir do |working_dir|
        add_manifest("#{working_dir}/manifest.yml")

        allow(command_runner).to receive(:run)
        expect(stats).to receive(:status).and_return('Test')
        expect(stats).to receive(:status=).with('Test')
        expect(stats).to receive(:save)
        # expect(bosh).to receive(:setup_environment)
        #   .with("#{working_dir}/manifest.yml", 'Test')
        # expect(bosh).to receive(:deploy).and_return('Deployed')
        out = BoshInitDeploymentResource::OutCommand.new(
          BoshInitDeploymentResource::BoshInit.new(command_runner), response,
          stub_responses: true)
        out.run(working_dir, request, stats)
      end
    end
    it 'run deployment' do
      in_dir do |working_dir|
        add_manifest("#{working_dir}/manifest.yml")

        expect(bosh).to receive(:setup_environment)
          .with("#{working_dir}/manifest.yml", '')
        expect(bosh).to receive(:deploy).and_return('Deployed')
        out_command.run(working_dir, request)
      end
    end
  end
end
