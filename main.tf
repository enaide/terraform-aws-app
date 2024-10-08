module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "3.12.0"
    
    name = "my-vpc"
    cidr = var.vpc_cidr_blocks

    azs             = [var.avail_zone]
    public_subnets  = [var.subnet_cidr_blocks]
    public_subnet_tags = {
        Name = "${var.env_prefix}-subnet-1"
    }

    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}
module "myapp-server" {
    source = "./modules/webserver"
    vpc_id = module.vpc.vpc_id
    subnet_id = module.vpc.public_subnets[0]
    my_ip = var.my_ip
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    image_name = var.image_name 
    public_key_location = var.public_key_location
    instance_type = var.instance_type
}