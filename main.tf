provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-a4c7edb2"
  instance_type = "t2.micro"
  key_name = "HelloWorld"
  vpc_security_group_ids = ["sg-41189330"]

  user_data = <<-EOF
              #!bin/bash
              sudo yum update –y
              sudo yum install git -y
              mkdir /app
              chmod 755 /app
              cd /app
              git clone https://github.com/rp4fx12/hello-world.git
              git status > test.txt
              curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -
              sudo yum install nodejs --enablerepo=nodesource -y
              #curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash
              #echo . ~/.nvm/nvm.sh >> ~/.bashrc
              #. ~/.bashrc
              #nvm install 7.10.0
              node --version > nodeVersion.txt
              cd /app/hello-world
              npm install
              npm start
              EOF

  tags {
    Name = "Simple EC2"
  }
}
