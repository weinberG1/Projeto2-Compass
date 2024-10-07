#!bin/bash

sudo apt update -y
sudo apt install -y docker
sudo apt install -y amazon-efs-utils
 
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
chkconfig docker on

curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
mv /usr/local/bin/docker-compose /bin/docker-compose

mkdir -p /efs/wordpress/var/www/html
curl -sL https://raw.githubusercontent.com/weinberG1/Projeto2-Compass/main/docker-compose.yml --output /home/ec2-user/docker-compose.yml

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-082721f45bb18c4f6.efs.us-east-1.amazonaws.com:/ efs
sudo chown ec2-user:ec2-user /efs

echo "fs-082721f45bb18c4f6.efs.us-east-1.amazonaws.com:/ efs nfs defaults 0 0" >> /etc/fstab

docker-compose -f /home/ec2-user/docker-compose.yml up -d
