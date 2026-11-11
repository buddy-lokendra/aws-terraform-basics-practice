locals {
  name_prefix = "${var.project}-${var.environment}"

  # Account ID lagane se bucket ka naam unique ho jata hai
  bucket_name = "${local.name_prefix}-${data.aws_caller_identity.current.account_id}"

  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
