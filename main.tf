###### Terraform Module to install LAMP on EC2 #######

# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "ap-southeast-2"
}

#Configure VPC and EC2 instance
resource "aws_instance" "ec2-lamp" {
  ami                    = "ami-08589eca6dcc9b39c"
  instance_type          = "${var.instance_type}"
  subnet_id              = "subnet-eb5ba68e"
  key_name               = "${var.key_pair}"
  vpc_security_group_ids = ["${aws_security_group.lamp-sec-grp.id}"]

#Apply tags on EC2
 tags {
    Name = "lamp-${var.name}"
  }

#Install Ansible from local script
provisioner "file" {
    source      = "install_ansible.sh"
    destination = "/tmp/install_ansible.sh"
    connection {
      user = "ec2-user"
      private_key = "${file(var.aws_key_path)}"
      agent = "false"
      timeout = "60s"
  }
}


provisioner "remote-exec" {
    inline = [
        "sudo chmod +x /tmp/install_ansible.sh",
        "sudo  /tmp/install_ansible.sh"
     ]
      connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file(var.aws_key_path)}"
      timeout = "60s"

  }
}

# Run Ansible Playbook defined locally
provisioner "file" {
    source      = "."
    destination = "/home/ec2-user"
    connection {
      user = "ec2-user"
      private_key = "${file(var.aws_key_path)}"
      agent = "false"
      timeout = "60s"
  }
}

provisioner "remote-exec" {
    inline = [
         "ansible-playbook /home/ec2-user/lamp.yml"
    ]
      connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file(var.aws_key_path)}"
      timeout = "60s"
   }
 }

}

#Create Security Group
resource "aws_security_group" "lamp-sec-grp" {
  name        = "lamp Security Group"
  description = "lamp access"
  vpc_id      = "vpc-a411fec1"

  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "lamp Security Group"
  }

}

# Create Elastic Loadbalancer
resource "aws_elb" "web" {
name = "lamp-elb"

subnets = ["subnet-eb5ba68e"]

security_groups = ["${aws_security_group.lamp-sec-grp.id}"]

listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  # The instance is registered automatically

  instances                   = ["${aws_instance.ec2-lamp.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

output "aws_elb" {
  description = "The DNS name of the ELB"
  value       = "${module.elb.aws_elb}"
}
