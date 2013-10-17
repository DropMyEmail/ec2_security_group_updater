require 'spec_helper'
require 'ec2_security_group_updater'

describe Ec2SecurityGroupUpdater do
  before do
    config = AWS::Core::Configuration.new({
        stub_requests: true,
        access_key_id: 'ACCESS_KEY_ID',
        secret_access_key: 'SECRET_ACCESS_KEY',
        session_token: 'SESSION_TOKEN'
    })

    # stub(AWS).config.with_any_args { config }
    # stub(AWS::EC2).new { @ec2 }
    # stub(@ec2).security_groups.stub!.filter.with_any_args { [] }
  end

  describe '#update_security_group_ip_permissions' do
    context 'with valid arguments' do
      it 'returns true'
      it 'updates the group ip permission'
    end

    context 'with invalid arguments' do
      it 'returns false'
      it 'doesnt change the group ip permission'
    end
  end

  describe '#get_port_range_by_protocol' do
    context 'with valid security_group passed' do
      it 'returns protocol and port range with ip 100.100.100.100/32'
    end
  end

  describe '#create_new_permission' do
    it 'creates new ip permission 200.200.200.200/32 with the given port range and protocol'
  end

  describe '#delete_old_permission' do
    it 'deletes ip permission 100.100.100.100/32 with the given port range and protocol'
  end

  describe '#ec2' do
    it "returns the correct ec2 instance based on the region" do
      ec2('us-virginia')
    end
  end
end