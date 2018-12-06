# aws-terraform-ansible-lamp assignment

Cloud Provider : AWS

Operating System used :  Amazon Linux

Pre-requisite

In main.tf update the following
-----------
subnet_id = "subnet-94a51bdf"

vpc_id    = "vpc-f052e488"

subnets   = "subnet-eb5ba68e"

In vars.tf update the following
 ----------
 default = "/home/ec2-user/lamp.pem"
 
 default = "devec2-keypair"

To run
========

Install Terraform and perform the following commands
https://www.terraform.io/downloads.html

Setup AWS Account in the Terminal/CLI tool used

Example below for MacOS

export AWS_ACCESS_KEY_ID=

export AWS_SECRET_ACCESS_KEY=

export AWS_DEFAULT_REGION=ap-southeast-2 

Navigate to Directory and run "terraform apply" to build the env

Navigate to Directory and run "terraform destroy" to terminate and deprovision all resources
