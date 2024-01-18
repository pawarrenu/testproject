resource "null_resource" "ansible_inventory2" {
  provisioner "local-exec" {
    command = <<EOF
      aws autoscaling describe-auto-scaling-instances --region us-east-1 --query 'AutoScalingInstances[*].[InstanceId]' --output text | tr '\t' '\n' > /home/ec2-user/test-project/terraform/ansible/instance_ids.txt
      echo "[web_servers]" > /home/ec2-user/test-project/terraform/ansible/inventory.ini
      xargs -I{} aws ec2 describe-instances --region us-east-1 --instance-ids {} --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text < /home/ec2-user/test-project/terraform/ansible/instance_ids.txt >> /home/ec2-user/test-project/terraform/ansible/inventory.ini
    EOF
  }
}
