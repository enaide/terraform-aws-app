#!/bin/bash
sudo yum update -y && sudo yum install -y docker
#sudo chmod 666 /var/run/docker.sock
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker
docker run -p 8080:80 nginx