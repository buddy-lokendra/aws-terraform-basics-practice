variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name (globally unique hona chahiye)"
  type        = string
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "practice"
}
