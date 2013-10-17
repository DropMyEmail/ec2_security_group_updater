require 'aws-sdk'

class SecurityGroup
  def initialize(opts)
    AWS.config({
                   access_key_id: opts[:access_key_id],
                   secret_access_key: opts[:secret_access_key]
               })
    @security_group = ec2(opts[:region]).security_groups.filter('group-name', opts[:group_name]).first
  end

  def permissions_by_ip(ip_address)
    permissions = []

    @security_group.ip_permissions_list.each do |ip_permission|
      if ip_permission[:ip_ranges].map{|ip_range| ip_range[:cidr_ip]}.include? ip_address
        permissions << Hash[:protocol, ip_permission[:ip_protocol], :from, ip_permission[:from_port], :to, ip_permission[:to_port]]
      end
    end
    permissions
  end

  def create_permission_for_ip(permission, ip_address)
    @security_group.authorize_ingress(permission[:protocol], permission[:from]..permission[:to], ip_address)
  end

  def delete_permission_for_ip(permission, ip_address)
    @security_group.revoke_ingress(permission[:protocol], permission[:from]..permission[:to], ip_address)
  end

  def ec2(region)
    AWS::EC2.new ec2_endpoint: 'ec2.' + region + '.amazonaws.com'
  end
end