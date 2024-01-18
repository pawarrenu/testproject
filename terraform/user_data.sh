#!/bin/bash
sudo yum update -y
mkfs -t ext4 /dev/xvdf
mkdir /var/log
mount /dev/xvdf /var/log
echo "/dev/xvdf   /var/log   ext4   defaults,nofail   0   2" >> /etc/fstab


sudo yum install -y ansible
 # Run Ansible playbook with dynamic inventory
ansible-playbook /home/ec2-user/test-project/terraform/ansible/playbook.yaml --inventory /home/ec2-user/test-project/terraform/ansible/inventory.ini
