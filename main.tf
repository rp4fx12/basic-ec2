provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-a4c7edb2"
  instance_type = "t2.micro"
  key_name = "HelloWorld"
  vpc_security_group_ids = ["sg-41189330"]
  iam_instance_profile = "EC2Access"

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
              #echo `aws s3 ls s3://hello-world-rohan/current/ --recursive | tail -n 1` | awk '{print $4}' | sed 's/^.\{8\}//g' >> currentFile.txt
              #export CURRENT_FILE=`cat currentFile.txt`
              aws s3 cp s3://hello-world-rohan/current/instance.txt current.txt
              aws s3 rm s3://hello-world-rohan/current/instance.txt
              export CURRENT=`cat current.txt`
              aws ec2 terminate-instances --instance-ids $CURRENT
              #echo `aws s3 ls s3://hello-world-rohan/current/ --recursive | tail -n 1` | awk '{print $4}' | sed 's/^.\{4\}//g' >> new.txt
              aws s3 cp s3://hello-world-rohan/new/instance.txt
              export NEW=`cat new.txt`
              aws s3 rm s3://hello-world-rohan/new/instance.txt
              aws s3 cp new.txt s3://hello-world-rohan/current/instance.txt
              EOF

  tags {
    Name = "Simple EC2"
  }
}
