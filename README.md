# EC2 Security Group Updater

Ruby script to update IP Permissions on EC2 Security Group

## Installation

Please ensure to add execute permission to bin/update_permission.rb

```
chmod +x bin/update_permission.rb
```

## Running the script

```
bin/update_permission.rb AWS_SECRET_KEY_ID AWS_SECRET_ACCESS_KEY REGION GROUP_NAME OLD_IP NEW_IP
```

Arguments explanations:

* AWS_SECRET_KEY_ID: Your AWS Secret Key ID

* AWS_SECRET_ACCESS_KEY: Your AWS Secret Access Key

* REGION: EC2 Availability Zone

* GROUP_NAME: Security Group Name you wish to update

* OLD_IP: Existing IP you want to update

* NEW_IP: New IP for the Security Group permission