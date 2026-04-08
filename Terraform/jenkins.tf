data "aws_ami" "amazon_linux_2" {
  most_recent = true

  owners = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "${var.project_name}-jenkins-sg"
  description = "Security group for Jenkins EC2"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    description = "Jenkins UI from my IP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-jenkins-sg"
  }
}

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.jenkins_instance_type
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  root_block_device {
    volume_size = var.jenkins_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-jenkins-server"
  }
}