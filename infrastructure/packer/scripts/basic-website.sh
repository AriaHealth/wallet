#!/bin/bash

yum update -y
yum install -y httpd git

echo $PRIVATE_KEY | base64 --decode > /home/ec2-user/.ssh/private_key.id_ed25519

ssh-keyscan github.com >>/home/ec2-user/.ssh/known_hosts
eval $(ssh-agent)
ssh-agent bash -c \
  'ssh-add /home/ec2-user/.ssh/private_key.id_ed25519; git clone git@github.com:AriaHealth/wallet.git'

systemctl start httpd
systemctl enable httpd

echo "<html> <body style='background-color: $COLOR'> </body> </html>" >/var/www/html/index.html
