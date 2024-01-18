# testproject
testproject-assigment 
vpc-subnet file work 
.We create subnets using the aws_subnet resource by providing,
the VPC id
CIDR block of IP addresses (Make sure the IP address block is within the IP address range of the VPC)
and the availability zone.

gateway-private.tf  work :
We will be creating our EC2 instances in the private subnet, allowing only the requests from the load balancer to reach the instances.

But, the instances might need to connect to the internet to download software/tools. To provide access to the internet, we need a NAT gateway for the private subnet.
Creating a route table and associating it with the subnet in above file 

gateway-public.tf work 
To have the load balancer open to the internet, we will place it in the public subnet. We also need an Internet Gateway for the public subnet.
this tf file wikk create a route table for our public subnet to connect it to Internet Gateway

load-balancer.tf
We will be creating an application load balancer for our web application, to handle HTTP and HTTPS requests.

auto-scailing.tf
In the launch template, we are providing,

the AMI we are going to use (make sure to get the AMI id from the same region as the EC2 instance)
-the instance type
-user data script 
-security group, subnet id for network configurations.
-we are also mapping secondary voulme to ec2 instance nd mounting /var/log
-also creating ansible inventory to passing ec2 ips which is created by terraform on runtime

main.tf
in this file we have provided provider details and also from main.tf terrafrom intiallize 

sg-rules.tf
in this file we have provided rules for security groups 

user-data.sh
this script file will contain what all required instruction 

 playbook.yaml inside ansible folder 
 it will contain to install ngnix server 
 
