resource "aws_launch_template" "web_ec2_launch_templ" {
  name = "web_ec2_launch_templ"

  block_device_mappings {
    device_name = "/dev/xvdf"

    ebs {
      volume_size = 5
      volume_type = "gp2"
    }
  }



  instance_type = "t2.micro"
  image_id      = "ami-0005e0cfe09cc9050"  # Specify the AMI ID here
  key_name      = "bastion-box"

  network_interfaces {
    associate_public_ip_address = true
  }


  # Other launch template settings...
}

resource "aws_network_interface" "web_nic" {
  subnet_id          = aws_subnet.private_subnet_2.id
  security_groups    = [aws_security_group.web_sg_for_ec2.id]


  # Other network interface settings...

}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2
  max_size             = 2
  min_size             = 1

  target_group_arns    = [aws_lb_target_group.web_alb_tg.arn]
  vpc_zone_identifier  = [aws_subnet.private_subnet_2.id]

  launch_template {
    id      = aws_launch_template.web_ec2_launch_templ.id
    version = "$Latest"
  }
}


resource "aws_instance" "web_instance" {
  launch_template {
    id      = aws_launch_template.web_ec2_launch_templ.id
    version = "$Latest"
  }



  ami           = "ami-0005e0cfe09cc9050"
  //security_groups    = [aws_security_group.web_sg_for_ec2.id]

  user_data     = filebase64("user_data.sh")

  # Other settings...
}


resource "null_resource" "ansible_inventory" {
  provisioner "local-exec" {
    command = <<EOF
      aws autoscaling describe-auto-scaling-instances --region us-east-1 --query 'AutoScalingInstances[*].[InstanceId]' --output text | tr '\t' '\n' > /home/ec2-user/test-project/terraform/ansible/instance_ids.txt
      echo "[web_servers]" > /home/ec2-user/test-project/terraform/ansible/inventory.ini
      xargs -I{} aws ec2 describe-instances --region us-east-1 --instance-ids {} --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text < /home/ec2-user/test-project/terraform/ansible/instance_ids.txt >> /home/ec2-user/test-project/terraform/ansible/inventory.ini
    EOF
  }
}
