variable "availability_zones" {}
variable "subnet_name" {}
variable "load_balancer_name" {}
variable "security_group_name" {}

# VPC and subnet
variable "instance_tenancy" {
  default = "default"
}
variable "dns_supported" {
  default = true
}
variable "dns_host_name" {
  default = true
}
variable "cidr_block" {
  default = "10.0.0.0/16"
}
