# bosh-init deployment resource.

A resource to deploy [bosh-init](http://bosh.io) manifests. The current deployment status will be stored in AWS S3.

## Requirements
The worker, where the resource is running, have to have direct network access to the deployed boxes. ```bosh-init``` will try to connect to the VM's using ports ```22``` and ```6868```.

## Source Configuration

* `access_key_id`: *Required.* AWS access key ID to access the bucket.
* `secret_access_key`: *Required.* AWS access key secret to access the bucket.
* `bucket_name`: *Required.* Bucket, where stats file is stored.
* `region`: AWS S3 region.


## Behavior

### `check`: Not implemented.

### `in`: Not implemented.

### `out`: Deploy manifest file to cloud.

Run ```bosh-init``` using the provided manifest file.

#### Parameters

* `stats_file_key`: *Required.* Location where the stats file is stored in the bucket.

* `manifest_file`: *Required.* Path to manifest file, which will be deployed by bosh-init.

## Deploy with BOSH

See [bosh-init-deployment-resource-boshrelease](https://github.com/hybris/bosh-init-deployment-resource-boshrelease) for a BOSH release and instructions for integrating this resource into your Concourse via BOSH.
