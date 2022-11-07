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
variable "ami_id" {
    type = string
  
}

variable "vpn_range" {
  type = list(string)
}
variable "instanceCount" {
    type = number
  
}

variable "bucket_name" {
  type = string
}
locals {
    common_tags = {
        DataTaxonomy = "Cisco Operatoins Data"
        Deployment_stack = "green"
        #Deployment_version = v0.8
        Environment = "performance"
        Name = "Iaac-LACP-Mock-green-os"
        #OwnerName = ""
        #ResourceOwner = ""
        #Security Compliance = "yes"
        ServiceName        = "Security-stack"
        
    }
}
