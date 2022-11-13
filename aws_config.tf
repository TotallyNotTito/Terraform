// Configure the AWS Cloud provider
provider "aws" {
        profile = "default"
        region = "us-east-1"
}

// A single EC2 instance
resource "aws_instance" "guestbook" {
  ami           = "ami-01d08089481510ba2"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
        aws_security_group.sg-guestbook.id
    ]
   key_name = aws_key_pair.kp.key_name
   user_data = "${file("install.sh")}"
}

resource "aws_key_pair" "kp" {
  key_name = "guestbook-key"
  public_key = "${file("/home/cloudshell-user/.ssh/id_ed25519.pub")}"
}

// A variable for extracting the external IP address of the instance
output "ec2instance" {
  value = aws_instance.guestbook.public_ip
}

resource "aws_security_group" "sg-guestbook" {
  name = "Guestbook-SG"

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  } 

}
