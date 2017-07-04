provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-a4c7edb2"
  instance_type = "t2.micro"
  key_name = "HelloWorld"
  vpc_security_group_ids = ["sg-41189330"]
  iam_instance_profile = "arn:aws:iam::917378046404:instance-profile/EC2Access"

  user_data = <<-EOF
              #!bin/bash
              sudo yum update –y
              sudo yum install git -y
              mkdir /app
              chmod 755 /app
              cd /app
              git clone https://github.com/rp4fx12/hello-world.git
              curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -
              sudo yum install nodejs --enablerepo=nodesource -y
              node --version > nodeVersion.txt
              cd /app/hello-world
              npm install
              npm start
              chmod 755 /tmp
              cd /tmp
              #get/remove file in current
              #delete current instance
              #move new file to current folder
              EOF

  tags {
    Name = "Simple EC2"
  }
}
