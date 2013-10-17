#!/usr/bin/env ruby
$:<< File.join(File.dirname(__FILE__), '../')

require 'lib/ec2_security_group_updater'

access_key_id = ARGV[0]
secret_access_key = ARGV[1]
region = ARGV[2]
group_name = ARGV[3]
old_ip = ARGV[4] || '100.100.100.100/32'
new_ip = ARGV[5] || '200.200.200.200/32'

Ec2SecurityGroupUpdater.new(access_key_id: access_key_id, secret_access_key: secret_access_key, region: region, group_name: group_name).change_permissions_ip_address(old_ip, new_ip)