variable "region" {
  default = "us-east-1"
}

variable "environment" {
  description = "Deployment Environment"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Public Subnet"
  default     = ["10.0.1.0/24"]
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
  default     = ["10.0.10.0/24"]
}

variable "bastion_key_pair" {
  type        = string
  description = "SSH Key Pair for Bastion hosts"
}

variable "elb_port" {
  type        = string
  description = "ALB port for App"
  default = "80"
}

variable "server_port" {
  type        = string
  description = "Server port for App"
  default = "80"
}


