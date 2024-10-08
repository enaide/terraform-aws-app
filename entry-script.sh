#!/bin/bash
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# we need to restart docker to apply above change in user group
sudo systemctl restart docker
sudo systemctl enable docker

docker run -p 8080:80 nginx