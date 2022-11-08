#!/bin/bash

yum update -y
yum install -y httpd git

echo $PRIVATE_KEY | base64 --decode >/home/ec2-user/.ssh/private_key.id_ed25519
chmod 400 /home/ec2-user/.ssh/private_key.id_ed25519

ssh-keyscan github.com >>/home/ec2-user/.ssh/known_hosts
eval $(ssh-agent)

echo "Adding private key"
ssh-add /home/ec2-user/.ssh/private_key.id_ed25519
echo -e "Host *\nUseKeychain yes" >> /home/ec2-user/.ssh/config

echo "Cloning repo"
cd /home/ec2-user/
git clone git@github.com:AriaHealth/wallet.git

systemctl start httpd
systemctl enable httpd

echo "<html> <body style='background-color: $COLOR'> </body> </html>" >/var/www/html/index.html
