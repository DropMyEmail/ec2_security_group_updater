require 'aws-sdk'

class Ec2SecurityGroupUpdater
  def initialize(access_key_id, secret_access_key)
    AWS.config({
        access_key_id: access_key_id,
        secret_access_key: secret_access_key
    })
  end

  def update_security_group_ip_permissions(group_name, region)
    security_group = ec2(region).security_groups.filter('group-name', group_name).first

    if security_group
      port_range_by_protocol = get_port_range_by_protocol(security_group)

      port_range_by_protocol.each do |port_range|
        create_new_permission(port_range)
        delete_old_permission(port_range)
      end

      true
    else
      false
    end
  end

  private
  def get_port_range_by_protocol(security_group)
    port_range_by_protocol = []
    
    security_group.ip_permissions_list.each do |ip_permission|
      unless ip_permission[:ip_ranges].map{|ip_range| ip_range[:cidr_ip]}.exclude? '100.100.100.100/32'
        port_range_by_protocol << Hash[:protocol, ip_permission[:ip_protocol], :from, ip_permission[:from_port], :to, ip_permission[:to_port]]
      end
    end
    port_range_by_protocol
  end  

  def create_new_permission(port_range)
    @security_group.authorize_ingress(port_range[:protocol], port_range[:from]..port_range[:to], '200.200.200.200/32')
  end

  def delete_old_permission(port_range)
    @security_group.revoke_ingress(port_range[:protocol], port_range[:from]..port_range[:to], '100.100.100.100/32')
  end

  def ec2(region)
    AWS::EC2.new ec2_endpoint: 'ec2.' + region + '.amazonaws.com'
  end
end