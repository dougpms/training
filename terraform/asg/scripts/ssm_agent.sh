#!/bin/bash
sudo amazon-linux-extras install nginx1
if [ $? -eq 0 ];
  then echo "Installation and nginx service started"
  else
    echo "nginx failed"; exit 1
fi
sudo systemctl start nginx.service
cd /tmp
sudo wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo rpm -i /tmp/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
if [ $? -eq 0 ];
  then echo "Installation and SSMAgent service started"
  else
    echo "SSMAgent failed"; exit 1
fi

# Config Index HTML for each box to identify LB action
echo $(hostname) | xargs -i sed -i 's/nginx!/{}/g' /usr/share/nginx/html/index.html
