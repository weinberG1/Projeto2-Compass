#!/bin/bash

# Atualizando o sistema, bem como instalando o docker e o efs 
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo yum install amazon-efs-utils nfs-utils -y

#Startando o serviço do docker e habilitando para sempre iniciar com o sistema
sudo systemctl enable docker
sudo service docker start
sudo usermod -aG docker ec2-user

# Instalando o docker-compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo mv /usr/local/bin/docker-compose /bin/docker-compose

# Criando o diretório para o wordpress no efs
cd /mnt
sudo mkdir efs
cd efs
sudo mkdir wordpress

# Montando o efs
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-03fea74ec7e0948bb.efs.us-east-1.amazonaws.com:/ /mnt/efs
sudo chown ec2-user:ec2-user /mnt/efs


# Instalando o arquivo do yml do docker-compose do meu proprio repo no github
sudo curl -sL https://raw.githubusercontent.com/weinberG1/Projeto2-Compass/main/docker-compose.yml --output /home/ec2-user/docker-compose.yml

# Habilitando a montagem do efs sempre que o sistema for reiniciado 
echo "fs-03fea74ec7e0948bb.efs.us-east-1.amazonaws.com:/ efs nfs defaults 0 0" | sudo tee -a /etc/fstab

sudo yum install mysql -y

# Verificacao se o banco de dados ja existe
sudo mysql --host="databasewp.cr0o8ky00uod.us-east-1.rds.amazonaws.com" --user="teste" --password="teste123" --execute="CREATE DATABASE IF NOT EXISTS databasewp;"

# Subindo o container do docker-compose
cd /home/ec2-user
sudo docker-compose up -d
