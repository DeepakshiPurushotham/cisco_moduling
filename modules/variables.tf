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
/*variable "vpn_range" {
    type= object({
    blr_vpn    = list(string)
    tokyo_vpn = list(string)
    amsterdam_vpn = list(string)
    sanjose_vpn = list(string)
    hongkong_vpn = list(string)
    rcdn_vpn = list(string)
  })
}
variable "vpn_range" {
  type = list(map(any))
  default = [ {
    "blr_vpn" = ["72.163.217.96/27", "72.163.220.0/27"]
  },
  {
    "tokyo_vpn" = ["64.104.44.96/27"]
  },
  {
    "my_vpn" =  ["49.206.10.104/32"]
  }
   ]
}
*/
variable "vpn_range" {
  type = list(string)
}
variable "instanceCount" {
    type = number
  
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