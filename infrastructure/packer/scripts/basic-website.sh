#!/bin/bash




curl --silent --location https://rpm.nodesource.com/setup_14.x | bash -
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg

yum update -y
yum install -y httpd git nodejs yarn

echo $PRIVATE_KEY | base64 --decode >/home/ec2-user/.ssh/private_key.id_ed25519
chmod 400 /home/ec2-user/.ssh/private_key.id_ed25519

ssh-keyscan github.com >>/home/ec2-user/.ssh/known_hosts
eval $(ssh-agent)

# TODO: solve the problem for private repositories
echo "Adding private key"
ssh-add /home/ec2-user/.ssh/private_key.id_ed25519
echo -e "Host *\nUseKeychain yes" >> /home/ec2-user/.ssh/config

echo "Cloning repo"
cd /home/ec2-user/
# git clone git@github.com:AriaHealth/wallet.git
git clone https://github.com/AriaHealth/wallet.git

cd ~
pwd

echo "Installing project"
cd /home/ec2-user/wallet
yarn

systemctl start httpd
systemctl enable httpd

echo "<html> <body style='background-color: $COLOR'> </body> </html>" >/var/www/html/index.html
