require 'lib/security_group'

class Ec2SecurityGroupUpdater
  def initialize(opts)
    @security_group = SecurityGroup.new(access_key_id: opts[:access_key_id], secret_access_key: opts[:secret_access_key], region: opts[:region], group_name: opts[:group_name])
  end

  def change_permissions_ip_address(old_ip_address = '100.100.100.100/32', new_ip_address = '200.200.200.200/32')
    @security_group.permissions_by_ip(old_ip_address).each do |permission|
      @security_group.create_permission_for_ip(permission, new_ip_address)
      @security_group.delete_permission_for_ip(permission, old_ip_address)
    end
    true
  end
end