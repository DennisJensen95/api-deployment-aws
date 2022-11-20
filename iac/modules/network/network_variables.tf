variable "availability_zones" {}
variable "load_balancer_name" {}
variable "security_group_name" {}

# VPC and subnet
variable "subnet_name" {}
variable "cidr_block" {
  default = "10.0.0.0/16"
}
