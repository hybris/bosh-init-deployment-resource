module BoshInitDeploymentResource
  # This is a class to manage bosh-init deployments.
  class OutCommand
    def initialize(bosh = BoshInit.new, writer = STDOUT, ops = {})
      @bosh = bosh
      @writer = writer
      @ops = ops
    end

    def run(working_dir, request, stats = nil)
      validate! request
      unless stats
        stats = BoshStats.new(
          credentials(request),
          request.fetch('source').fetch('bucket_name'),
          request.fetch('params').fetch('stats_file_key'),
          request.fetch('source').fetch('region', 'us-east-1'), @ops)
      end
      deploy("#{working_dir}/#{manifest_file(request)}",
             "#{working_dir}/#{key_file(request)}", stats)
    end

    private

    def validate!(request)
      %w(access_key_id secret_access_key bucket_name region).each do |field|
        request.fetch('source').fetch(field)
      end

      %w(stats_file_key manifest_file).each do |field|
        request.fetch('params')
          .fetch(field) { fail "source must include '#{field}'" }
      end
    end

    def credentials(request)
      Aws::Credentials.new(
        request.fetch('source').fetch('access_key_id'),
        request.fetch('source').fetch('secret_access_key')
      )
    end

    def manifest_file(request)
      request.fetch('params').fetch('manifest_file', 'manifest.yml')
    end

    def key_file(request)
      request.fetch('params').fetch('key_file', 'microbosh.pem')
    end

    def deploy(manifest_path, key_path, stats)
      @bosh.setup_environment(
        manifest_path,
        key_path,
        stats.status
      )
      stats.status = @bosh.deploy
      stats.save
    end
  end
end
