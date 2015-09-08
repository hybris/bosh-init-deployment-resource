module BoshInitDeploymentResource
  # The class is managing bosh-init status stored in AWS S3.
  class BoshStats
    def initialize(
      credentials,
      bucket_name,
      stats_file_name = 'microbosh-stats.json',
      region = 'es-east-1',
      ops = {})

      @s3 = Aws::S3::Client.new({
        region: region,
        credentials: credentials }.merge(ops))
      @bucket_name = bucket_name
      @stats_file = stats_file_name
    end

    attr_accessor :s3

    def status
      unless @status
        print 'Download status from s3.'
        @status = download_object_from_s3
        if @status
          print 'Found status'
          return status.body.string
        else
          print 'No status available'
          return nil
        end
      end
      @status
    end

    attr_writer :status

    def save
      store_object_to_s3(@status)
    end

    private

    def download_object_from_s3
      return @s3.get_object(bucket: @bucket_name, key: @stats_file)
    rescue Aws::S3::Errors::NoSuchKey
      return nil
    end

    def store_object_to_s3(content)
      @s3.put_object(bucket: @bucket_name, key: @stats_file, body: content)
    end
  end
end
