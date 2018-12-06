##### Terraform LAMP  Module  Variables    ###########

variable "name" {
  description = "lamp server"
  default = "server"
}

# Instance type
variable "instance_type" {
  description = "AWS instance type to launch lamp server"
  default = "t2.micro"
}

# private key
variable "aws_key_path" {
  default = "/Users/prdhingra/WorkDocs/viblab/viblab.pem"
}

# Keypair to login as ec2-user
variable "key_pair" {
  description = "Name of key pair to attach to the  lamp server instance."
  default = "viblab"
}


variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}
