Puppet::Type.newtype(:s3_object) do
  @doc = 'Type representing S3 objects.'

  ensurable

  newparam(:name, namevar: true) do
    desc 'The name of the S3 object to manage.'
    validate do |value|
      fail Puppet::Error, 'Empty S3 object names are not allowed' if value == ''
    end
  end

  newparam(:bucket) do
    desc 'The name of the S3 bucket to put the S3 object.'
    validate do |value| do
      fail Puppet::Error, 'Empty S3 bucket names are not allowed' if value == ''
    end
  end

  newparam(:body) do
    desc 'The path to the source file for the object.'
    validate do |value| do
      fail Puppet::Error, 'Empty S3 object body is not allowed.' if value == ''
    end
  end

  newparam(:key) do
    desc 'S3 path to the object. Will default to namevar if not set.'
  end

  newparam(:content_type) do
    desc 'S3 object content type.'
    validate do |value| do
      fail Puppet::Error, 'Empty content-type is not allowed.' if value == ''
    end
  end

  newproperty(:last_modified) do
    desc 'Read-only property for the date a S3 object was last modified.'
  end

  autorequire(:bucket) do
    self[:bucket]
  end
end
