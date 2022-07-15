# Configure the AWS Provider
provider "aws" {
        region = "us-east-1"
        access_key = "AKIAYRSPFXVLZ7FN67BZ"
        secret_key = "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"
}

# Resource - ansible
resource "aws_instance" "master" {
ami = "ami-02358d9f5245918a3"
instance_type = "t2.micro"
subnet_id = "subnet-09ebec067caac4f0b"
key_name = "ganesh"
private_ip = "172.31.86.121"
user_data = file("ansible.sh")
vpc_security_group_ids = [ "sg-0f1ce95b163bd2f5c" ]
   tags = {
        Name = "ansible"
   }
}

# Resource - jenkins
resource "aws_instance" "jenkins" {
ami = "ami-02358d9f5245918a3"
instance_type = "t2.micro"
subnet_id = "subnet-09ebec067caac4f0b"
key_name = "ganesh"
private_ip = "172.31.86.122"
vpc_security_group_ids = [ "sg-0f1ce95b163bd2f5c" ]
   tags = {
        Name = "CI/CD"
   }
}

# Resource - docker
resource "aws_instance" "instance1" {
ami = "ami-02358d9f5245918a3"
instance_type = "t2.micro"
subnet_id = "subnet-09ebec067caac4f0b"
key_name = "ganesh"
private_ip = "172.31.86.123"
vpc_security_group_ids = [ "sg-0f1ce95b163bd2f5c" ]
   tags = {
        Name = "instance1"
   }
}

# Resource - docker2
resource "aws_instance" "instance2" {
ami = "ami-02358d9f5245918a3"
instance_type = "t2.micro"
subnet_id = "subnet-0908ce2bd64b406f8"
availability_zone = "us-east-1b"
key_name = "ganesh"
vpc_security_group_ids = [ "sg-0f1ce95b163bd2f5c" ]
   tags = {
        Name = "instance2"
   }
}
