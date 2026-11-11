data "aws_caller_identity" "current" {}

# Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# 1. Key pair (Terraform khud key banayega)
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "${local.name_prefix}-key"
  public_key = tls_private_key.this.public_key_openssh
  tags       = local.common_tags
}

resource "local_file" "pem" {
  content         = tls_private_key.this.private_key_pem
  filename        = "${path.module}/${local.name_prefix}-key.pem"
  file_permission = "0400"
}

# 2. Security group
resource "aws_security_group" "this" {
  name        = "${local.name_prefix}-sg"
  description = "SSH and HTTP access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "HTTP"
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

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-sg" })
}

# 3. EC2 instance (user_data se hello.txt file banegi)
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.this.id]

  user_data = <<-USERDATA
    #!/bin/bash
    echo "Hello from Terraform" > /home/ec2-user/hello.txt
    echo "Created at: $(date)" >> /home/ec2-user/hello.txt
    chown ec2-user:ec2-user /home/ec2-user/hello.txt
  USERDATA

  user_data_replace_on_change = true

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-ec2" })
}

# 4. Elastic IP
resource "aws_eip" "this" {
  instance = aws_instance.web.id
  domain   = "vpc"

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-eip" })
}

# 5. S3 bucket
resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
  tags   = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
