#!/bin/bash

yum update -y
yum install -y httpd

ssh-keyscan github.com >>/home/ec2-user/.ssh/known_hosts
eval $(ssh-agent)
ssh-agent bash -c \
  'ssh-add /home/ec2-user/.ssh/[$PRIVATE_KEY]; git clone git@github.com:AriaHealth/wallet.git; git checkout $GIT_BRANCH'

systemctl start httpd
systemctl enable httpd

echo "<html> <body style='background-color: $COLOR'> </body> </html>" >/var/www/html/index.html
