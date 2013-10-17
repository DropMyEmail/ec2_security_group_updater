require 'spec_helper'
require 'security_group'

describe SecurityGroup do
  let(:security_group) {
    SecurityGroup.new(
        access_key_id: 'AKIAJY3HZOC46JLTLT2A',
        secret_access_key: '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',
        region: "ap-southeast-1",
        group_name: 'database-servers'
    )
  }

  describe '#ec2' do
    it 'returns the correct ec2 instance based on the region' do
      expect(security_group.ec2('ap-southeast-1').config.ec2_endpoint).to eq "ec2.ap-southeast-1.amazonaws.com"
    end
  end

  describe '#create_permission_for_ip' do
    let(:ip) { '50.50.50.50/32' }
    it 'returns nil if successful' do
      expect(security_group.create_permission_for_ip({protocol: 'tcp', from: 9000, to: 9005}, ip)).to eql nil
    end

    context 'with an existing permission' do
      it 'throws a duplicate error' do
        permission = { protocol: 'tcp', from: 9006, to: 9010 }
        security_group.create_permission_for_ip(permission, ip)
        expect{ security_group.create_permission_for_ip(permission, ip) }.to raise_error(AWS::EC2::Errors::InvalidPermission::Duplicate)
      end
    end

    context 'with an invalid protocol' do
      it 'throws an invalid protocol error' do
        expect{ security_group.create_permission_for_ip({ protocol: 'xyz', from: 9006, to: 9010 }, ip) }.to raise_error(AWS::EC2::Errors::InvalidPermission::Malformed)
      end
    end
  end

  describe '#delete_old_permission' do
    let(:ip) { '60.60.60.60/32' }

    it 'returns nil if successful' do
      permission = {protocol: 'tcp', from: 9011, to: 9015}
      security_group.create_permission_for_ip(permission, ip)
      expect(security_group.delete_permission_for_ip(permission, ip)).to eql nil
    end

    it 'allows to recreate the permission, if it was deleted successfully' do
      permission = {protocol: 'tcp', from: 9016, to: 9020}
      security_group.create_permission_for_ip(permission, ip)
      security_group.delete_permission_for_ip(permission, ip)
      expect{security_group.create_permission_for_ip(permission, ip)}.to_not raise_error
    end
  end

  describe '#permissions_by_ip'  do
    it 'returns array of port range and protocol hash' do
      expect(security_group.permissions_by_ip('99.99.99.99/32')).to eql [protocol: 'tcp', from: 80, to: 80]
    end

    context 'when given ip does not have any permission' do
      it 'returns empty array' do
        expect(security_group.permissions_by_ip('199.199.199.199/32')).to eql []
      end
    end
  end
end