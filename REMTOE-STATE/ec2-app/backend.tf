terraform {
  backend "s3" {
    bucket         = "tfstate-820986827992-practice"
    key            = "ec2-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-lock"
    encrypt        = true
  }
}
