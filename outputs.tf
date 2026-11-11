output "bucket_name" {
  description = "Bucket ka naam"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "Bucket ka ARN"
  value       = aws_s3_bucket.this.arn
}
