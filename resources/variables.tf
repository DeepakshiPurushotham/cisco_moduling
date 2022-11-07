variable "region" {
    type = string
    default = ""
}

variable "profile" {
    type = string
    default = ""
}
variable "ami_id" {
    type = string
    default = ""
}
variable "instance_type" {
    type = string
    default = ""
}
variable "vpc_cidr_block" {
    type = string
    default = ""
}
variable "publicSubnets1_cidr_block" {
    type = string
    default = ""
}
variable "publicSubnets2_cidr_block" {
    type = string
    default = ""
}
variable "privateSubnets1_cidr_block" {
    type = string
    default = ""
}
variable "privateSubnets2_cidr_block" {
    type = string
    default = ""
}
variable "instanceCount" {
    type = number
}
variable "vpn_range" {
  type = list(string)
}
variable "bucket_name" {
  type = string
}
