# provider "aws" {
#   region = "us-east-1"
# }
/*
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "ansible_key"
  public_key = tls_private_key.example.public_key_openssh
}*/

resource "aws_security_group" "allow_ssh_http" {
  name = "allow_ssh_http"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami             = "ami-0fff1b9a61dec8a5f" 
  instance_type   = "t2.micro"
  key_name        = "hazem"
  security_groups = [aws_security_group.allow_ssh_http.name]

  tags = {
    Name = "Web Server"
  }

  provisioner "local-exec" {
    command = "echo '${self.public_ip}' > ip_address.txt"
  }
}

output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}
