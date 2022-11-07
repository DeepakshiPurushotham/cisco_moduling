module "ec2" {
    source = "../Modules"
    instance_type = var.instance_type
    vpc_cidr_block = var.vpc_cidr_block
    publicSubnets1_cidr_block = var.publicSubnets1_cidr_block
    publicSubnets2_cidr_block = var.publicSubnets2_cidr_block
    privateSubnets1_cidr_block = var.privateSubnets1_cidr_block
    privateSubnets2_cidr_block = var.privateSubnets2_cidr_block
    ami_id = var.ami_id
    instanceCount = var.instanceCount ## no of instance
    vpn_range = var.vpn_range
    bucket_name = var.bucket_name

}
