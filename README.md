# Atividade 2 - AWS/Docker

Este repositório contém a atividade desenvolvida durante a Sprint 6 do Programa de Bolsas DevSecOps - JUN 2024. O projeto tem como objetivo a utilização dos serviços EC2, uma aplicação Wordpress, Docker, EFS e Loud Balancer.

## Configuração AWS

### Etapa 1: Criando Grupos de Segurança
#### Grupo de Segurança Instancias 

1. Na página do serviço EC2, no menu lateral esquerdo ir em `Rede e Segurança` > `Security groups`.
2. Depois em `Criar grupo de segurança` no botão superior direito.
3. Após isso, coloque um nome e uma descrição para ele.
4. Em seguida, vá em adicionar regras de entrada e libere as seguintes portas:
   - **TCP/3306 (MySQL)**
   - **TCP/22 (SSH)**
   - **TCP/80 (HTTP)**
5. Por fim clique em `Criar grupo de segurança`.

#### Grupo de Segurança EFS

1. Navegue no serviço EC2 da AWS em `Security groups`.
2. Clique em `Criar grupo de segurança`. Este será utilizado para segurança de rede exclusiva do EFS.
3. Depois de atribuir um nome (security-efs), adicione como regra de entrada ao NFS
   - **Tipo:** NFS
   - **Protocolo:** TCP
   - **Porta:** 2049
### Etapa 2: Criando o EFS (Elastic File System)

1. Agora navegue até o serviço de EFS, indo em `Pesquisar` > `EFS`.
2. No menu lateral esquerdo vá em `Sistemas de arquivos` > `Criar sistema de arquivos`.
3. Adicione um nome para o mesmo (no meu caso escolhi "atividade2-efs").
4. Mantenha o restante das opções pré-definidas, só altere o grupo de segurança para o "security-efs".
5. Clique em `Finalizar`.
6. Abra o sistema de arquivos criado e clique no botão `Anexar`.
7. Agora iremos montar o sistema de arquivos via DNS.
   ```
   sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport [IP do EFS]:/ [Diretório de montagem]
   ```
### Etapa 3: Criando o RDS (Database MySQL)

1. Acesse o serviço RDS na sua conta AWS, indo em `Pesquisar` > `RDS`.
2. Vá para `Banco de Dados` e depois clique em `Criar banco de dados`.
3. Selecione o métode de `Criação padrão` e escolha o `MySQL` como banco de dados.
4. Escolha o `Nível gratuito`.
5. Depois configure o database.
6. Em `Acesso público` deixe a opção `não` marcada.

### Etapa 4: Criando EC2 Instance 
1. Vá para a página de serviço EC2, e clique em `Instancias` no menu lateral esquerdo.
2. Clicar em `Executar instâncias` na parte superior direita da tela.
3. No meu caso fiz a seguinte configuração de Instance:
   - **AMI:** Amazon Linux 2
   - **Tipo:** t3.small
   - **Armazenamento:** 16gb SSD
4. Em detalhes avançados, vá para `Dados do usuário` e selecione o arquivo `user-data.sh`, que é o script para a automação da instancia.
5. Após isso, vá em `Executar Instancia`.

### Final

1. Após tudo isso, o WordPress estará acessível pelo `localhost`, carregando a página de instalação.
