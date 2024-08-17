resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_blocks
    
    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}

module "myapp-subnet" {
    source = "./modules/subnet"
    vpc_id = aws_vpc.myapp-vpc.id
    avail_zone = var.avail_zone
    subnet_cidr_blocks = var.subnet_cidr_blocks
    env_prefix = var.env_prefix
}

module "myapp-server" {
    source = "./modules/webserver"
    vpc_id = aws_vpc.myapp-vpc.id
    subnet_id = module.myapp-subnet.subnet.id
    my_ip = var.my_ip
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    image_name = var.image_name 
    public_key_location = var.public_key_location
    instance_type = var.instance_type
}