output "instance_id" {
  value = aws_instance.web.id
}

output "elastic_ip" {
  value = aws_eip.this.public_ip
}

output "ssh_command" {
  value = "ssh -i ${local_file.pem.filename} ec2-user@${aws_eip.this.public_ip}"
}

output "bucket_name" {
  value = aws_s3_bucket.this.id
}

output "security_group_id" {
  value = aws_security_group.this.id
}
