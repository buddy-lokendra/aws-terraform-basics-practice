variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type    = string
  default = "tf-practice"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "my_ip" {
  description = "SSH ke liye allowed IP (CIDR). Example: 1.2.3.4/32"
  type        = string
  default     = "0.0.0.0/0" # practice ke liye, baad me apni IP daalo
}
