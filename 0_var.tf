variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}



variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "vpc_cidr"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "instance_type"
}



variable "public_subnet_cidr" {
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.4.0/24", "10.0.8.0/24"]
  description = "public_subnet_cidr"

}

variable "private_subnet_cidr" {
  type        = list(string)
  default     = ["10.0.16.0/24", "10.0.24.0/24", "10.0.32.0/24"]
  description = "private_subnet_cidr"
}

variable "availability_zone" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "availability_zone"
}

variable "public_subnet_names" {
  type        = list(string)
  default     = ["public_subnet_1a", "public_subnet_1b", "public_subnet_1c"]
  description = "public_subnet_names"
}

variable "private_subnet_names" {
  type        = list(string)
  default     = ["private_subnet_1a", "private_subnet_1b", "private_subnet_1c"]
  description = "private_subnet_names"

}

