output "ec2_public_ip" {
    value = module.myapp-server.instance.public_ip
}

output "ubuntu_ami" {
    value = module.myapp-server.instance.ami
}