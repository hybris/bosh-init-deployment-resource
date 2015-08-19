describe BoshInitDeploymentResource::BoshStats do
  let(:bosh) do
    BoshInitDeploymentResource::BoshStats.new(
      Aws::Credentials.new('akid', 'secret'),
      'bucket_name',
      'microbosh-stats.json',
      'es-east-1',
      stub_responses: true
    )
  end

  let(:s3) do
    instance_double(Aws::S3::Client)
  end

  describe '.status' do
    it 'Get status string' do
      expect(bosh.status).to be_kind_of(String)
    end

    it 'Return nil if object not exists.' do
      expect(s3).to receive(:get_object)
        .with(bucket: 'bucket_name', key: 'microbosh-stats.json')
        .and_raise(
          Aws::S3::Errors::NoSuchKey.new(
            Seahorse::Client::RequestContext, 'Test')
        )
      bosh.s3 = s3
      expect(bosh.status).to be_nil
    end

    it 'set status' do
      bosh.status = 'Test'
      expect(bosh.status).to eq('Test')
    end
  end

  describe '.download_object_from_s3' do
    let(:s3) do
      instance_double(Aws::S3::Client)
    end

    it 'call s3' do
      expect(s3).to receive(:get_object)
        .with(bucket: 'bucket_name', key: 'microbosh-stats.json')
      bosh.s3 = s3
      bosh.instance_eval { download_object_from_s3 }
    end
  end

  describe '.store_object_to_s3' do
    let(:s3) do
      instance_double(Aws::S3::Client)
    end

    it 'call s3' do
      expect(s3).to receive(:put_object)
        .with(bucket: 'bucket_name', key: 'microbosh-stats.json', body: 'Test')
      bosh.s3 = s3
      bosh.instance_eval { store_object_to_s3('Test') }
    end
  end
end
