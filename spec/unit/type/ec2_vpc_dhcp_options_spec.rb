require 'spec_helper'

type_class = Puppet::Type.type(:ec2_vpc_dhcp_options)

describe type_class do

  let :params do
    [
      :name,
    ]
  end

  let :properties do
    [
      :ensure,
      :tags,
      :region,
      :domain_name,
      :domain_name_servers,
      :ntp_servers,
      :netbios_name_servers,
      :netbios_node_type,
    ]
  end

  it 'should have expected properties' do
    properties.each do |property|
      expect(type_class.properties.map(&:name)).to be_include(property)
    end
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to be_include(param)
    end
  end

  it 'should require a name' do
    expect {
      type_class.new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'region should not contain spaces' do
    expect {
      type_class.new(:name => 'sample', :region => 'sa east 1')
    }.to raise_error(Puppet::ResourceError, /region should not contain spaces/)
  end

  it 'should default node type to 2' do
    srv = type_class.new(:name => 'sample')
    expect(srv[:netbios_node_type]).to eq('2')
  end

  [1,2,4,8].each do |value|
    it "should be able to set node type to a valid value of #{value}" do
      expect {
        type_class.new(:name => 'sample', :netbios_node_type => value)
      }.to_not raise_error
    end
  end

  ['invalid', 3].each do |value|
    it "should not be able to set node type to invalid values like #{value}" do
      expect {
        type_class.new(:name => 'sample', :netbios_node_type => value)
      }.to raise_error(Puppet::ResourceError)
    end
  end


end
