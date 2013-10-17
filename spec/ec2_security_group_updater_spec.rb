require 'spec_helper'
require 'ec2_security_group_updater'
require 'security_group'

describe Ec2SecurityGroupUpdater do
  let(:ec2_security_group_updater) {
    Ec2SecurityGroupUpdater.new(
        access_key_id: 'AKIAJY3HZOC46JLTLT2A',
        secret_access_key: '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',
        region: 'ap-southeast-1',
        group_name: 'database-servers'
    )
  }

  let(:security_group) {
    SecurityGroup.new(
        access_key_id: 'AKIAJY3HZOC46JLTLT2A',
        secret_access_key: '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',
        region: "ap-southeast-1",
        group_name: 'database-servers'
    )
  }

  describe '#change_permissions_ip_address' do
    context 'when update success with no exception' do
      it 'returns true' do
        expect(ec2_security_group_updater.change_permissions_ip_address('40.40.40.40/32', '41.41.41.41/32')).to eql true
      end

      it 'does not allow to create new permission with the same new ip' do
        security_group.create_permission_for_ip({ protocol: 'tcp', from: 9006, to: 9010 }, '42.42.42.42/32')
        ec2_security_group_updater.change_permissions_ip_address('42.42.42.42/32', '43.43.43.43/32')
        expect{ security_group.create_permission_for_ip({ protocol: 'tcp', from: 9006, to: 9010 }, '43.43.43.43/32') }.to raise_error(AWS::EC2::Errors::InvalidPermission::Duplicate)
      end
    end
  end
end