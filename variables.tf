variable "region" {
  default = "ap-south-1"
}

variable "key_name" {
  description = "EC2 key pair name to access nodes"
  type        = string
}

