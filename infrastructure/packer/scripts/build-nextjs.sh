#!/bin/bash

echo "Creating working directory"
WORKDIR=~
cd $WORKDIR
mkdir -p $WORKDIR/.aws

echo "Installing dependencies"
curl --silent --location https://rpm.nodesource.com/setup_14.x | bash -
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
sudo amazon-linux-extras enable nginx1

sudo yum update -y
sudo yum install -y httpd git nodejs yarn nginx
sudo npm install pm2@latest -g

echo "Setting up environment variables"
echo -e "[default]\naws_access_key_id=${AWS_ACCESS_KEY_ID}\naws_secret_access_key=${AWS_SECRET_ACCESS_KEY}" >$WORKDIR/.aws/credentials
echo -e "[default]\nregion=eu-west-1\noutput=json" >$WORKDIR/.aws/config
echo -e "export AWS_BUCKET=${AWS_BUCKET}\n" >>$WORKDIR/.bash_profile
echo -e "export GITHUB_SHA=${GITHUB_SHA}\n" >>$WORKDIR/.bash_profile
echo -e "export PATH=$PATH:/usr/bin/pm2\n" >>$WORKDIR/.bashrc

source $WORKDIR/.bash_profile
source $WORKDIR/.bashrc

echo "Setting up the code"
aws s3 cp s3://${AWS_BUCKET}/$GITHUB_SHA.zip $WORKDIR
unzip $GITHUB_SHA.zip -d $WORKDIR/service && cd $WORKDIR/service
cd src && yarn && yarn build
rm -f $WORKDIR/$GITHUB_SHA.zip

echo "Running the application on pm2"
sudo pm2 startup systemd
sudo pm2 start "yarn start" --name application
sudo pm2 save

echo "Setting up nginx"
sudo fuser -k 80/tcp
sudo fuser -k 443/tcp
rm -f /etc/nginx/conf.d/*
mkdir -p /etc/nginx/conf.d/
sudo cp $WORKDIR/service/src/nginx.conf /etc/nginx/conf.d/
sudo systemctl start nginx
sudo systemctl enable nginx
