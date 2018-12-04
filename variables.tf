variable "name_prefix" {
  default = "tf-"
}

variable "cidr_block" {
  description = "CIDR blocks wanted to be used for your VPC (min /23)."
  default     = "172.31.0.0/16"
}

variable "price_saving_enabled" {
  description = "Variable to reduce cost (deprecated in production)."
  default     = "0"
}
