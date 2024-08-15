variable vpc_cidr_blocks {}
variable subnet_cidr_blocks {}
variable avail_zone {}
variable env_prefix {}
variable my_ip {}
variable instance_type {}

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_blocks
    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_blocks
    availability_zone = var.avail_zone
    tags = {
        Name = "${var.env_prefix}-subnet-1"
    }
}

resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.myapp-vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name = "${var.env_prefix}-rtb"
    }
}

resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id
    tags = {
        Name = "${var.env_prefix}-igw"
    }
}

resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-route-table.id
}

resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    description = "Security group for myapp"
    vpc_id = aws_vpc.myapp-vpc.id
    
    ingress {
        description = "Allow inbound SSH traffic"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        description = "Allow inbound HTTP traffic"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []       
    }

    tags = {
        Name = "${var.env_prefix}-sg"
    }     
}

data "aws_ami" "latest-amz-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

output "aws_ami_id" {
    value = data.aws_ami.latest-amz-image.id
}

resource "aws_instance" "myapp_server" {
    ami = data.aws_ami.latest-amz-image.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.avail_zone
    associate_public_ip_address = true
    key_name = "app-server-kp"
    #user_data = file("entry-script.sh")
    
    user_data = <<EOF
                    #!/bin/bash
                    sudo yum update -y && sudo yum install -y docker
                    sudo systemctl enable docker
                    sudo systemctl start docker
                    sudo usermod -aG docker $USER
                    docker run -p 8080:80 nginx
                EOF
    
    tags = {
        Name = "${var.env_prefix}-server"
    }
}