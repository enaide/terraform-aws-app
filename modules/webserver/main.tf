resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    description = "Security group for myapp"
    vpc_id = var.vpc_id
    
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

data "aws_ami" "ubuntu_22_04" {
    most_recent = true
    owners = ["099720109477"]  # ID del propietario de Canonical
    
    filter {
        name   = "name"
        values = [var.image_name]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    } 
}

resource "aws_key_pair" "ssh-key" {
    key_name = "myapp_server-kp"
    public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp_server" {
    ami = data.aws_ami.ubuntu_22_04.id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.avail_zone
    associate_public_ip_address = true
    key_name = aws_key_pair.ssh-key.key_name
    user_data = file("entry-script.sh")
    
    tags = {
        Name = "${var.env_prefix}-server"
    }
}