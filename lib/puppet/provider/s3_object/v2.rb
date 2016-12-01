require_relative '../../../puppet_x/puppetlabs/aws.rb'

Puppet::type.type(:s3_object).provide(:v2, :parent => PuppetX::Puppetlabs::Aws) do
  confine feature: :aws

  mk_resource_methods

  def self.instances
    response = s3_client.list_buckets()
    bucket_list = response.buckets.collect do |s3_bucket|

      response = s3_client.list_objects(
        {
	  bucket: s3_bucket.name
	}
      )

      object_list = response.contents.collect do |bucket_object|
        data = {
	  ensure: :present,
	  name: :namevar,
	  last_modified: bucket_object.last_modified,
	  body: IO.read(:body),
	  bucket: s3_bucket.name,
	  key: "#{s3_bucket.name}/#{bucket_object.key}",
	  content_type: :content_type
	}

