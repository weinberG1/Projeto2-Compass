#!bin/bash

# Trocando para superuser para facilitar a instalacao de pacotes
sudo su

# Atualizando o sistema, bem como instalando o docker e o efs 
yum update -y
yum install -y docker
yum install -y amazon-efs-utils

#Startando o serviço do docker e habilitando para sempre iniciar com o sistema
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
chkconfig docker on

# Instalando o docker-compose
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
mv /usr/local/bin/docker-compose /bin/docker-compose

# Criando o diretório para o wordpress no efs
mkdir /mnt/efs/wordpress/var/www/html

# Instalando o arquivo do yml do docker-compose do meu proprio repo no github
curl -sL https://raw.githubusercontent.com/weinberG1/Projeto2-Compass/main/docker-compose.yml --output /home/ec2-user/docker-compose.yml

# Montando o efs
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-0ae75c1b0a5f7958e.efs.us-eas-1.amazonaws.com:/ /mnt/efs
sudo chown ec2-user:ec2-user /mnt/efs

# Habilitando a montagem do efs sempre que o sistema for reiniciado 
echo "fs-082721f45bb18c4f6.efs.us-east-1.amazonaws.com:/ efs nfs defaults 0 0" >> /etc/fstab

# Subindo o container do docker-compose
cd /home/ec2-user
docker-compose up -d
