# Automation of a LAMP Stack on AWS

This project provides a base template to deploy a web-based application on a LAMP stack. The solution is based off Hashicorp's terraform for cloud resources provisioning. It deploys an Amazon Linux EC2 Instance followed by installation of Ansible for Configuration management, Pip for package management, Apache for Webserver and MariaDB for database on a single EC2 Instance

## Getting Started

Fork or Copy this repo locally in your file system and follow these instructions to get up and running on your local machine for development purposes.

### Prerequisites

- terraform - Download the latest version using your local package manager like Homebrew on Mac or Chocolatey on Windows.
- aws account - An Amazon Web Services account with IAM permissions to provision resources.
- vpc information - Obtain the default VPC ID and Subnet ID
- key pair - Generate a key pair on your local machine or in AWS EC2 Console

```
brew install terraform
choco install terraform --pre
```

### Setup AWS Credentials

Using Terminal/CMD line navigate to the repository folder and set your environment variable with your AWS Credentials.

```
export AWS_ACCESS_KEY_ID= <your access key id>

export AWS_SECRET_ACCESS_KEY= <your secret access key>

export AWS_DEFAULT_REGION=ap-southeast-2 

```

### Modify the code

Modify the following variables in the configuration file for your environment

#### main.tf file

```
subnet_id = "subnet-94a51bdf"
```

```
vpc_id    = "vpc-f052e488"
```

```
subnets   = "subnet-eb5ba68e"
```

#### vars.tf file

```
default = "/home/ec2-user/lamp.pem"
```

```
default = "devec2-keypair"
```

## Provisioning and Deployment

To deploy the project run the following command and enter "yes" upon the prompt confirming the deployment scope.

```
terraform apply
```
## Testing

Upon successful deployment, you will receive an output providing DNS of the Elastic Loadbalancer. Please wait for at least 5 mins for all services to come up and the DNS to point to the EC2 Instance.

Enter the ELB's DNS in your local browser or provide a curl command to view the webpage and database connection

## Authors

* [Prashit](http://www.prashit.cloud)
