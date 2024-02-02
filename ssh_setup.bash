#!/bin/bash

export GREEN='\e[32m'
export NONE='\e[0m'

echo -e "${GREEN}Updating apt-get...${NONE}"
apt-get update
echo -e "${GREEN}Installing ssh server...${NONE}"
apt-get install -y openssh-server ufw
echo -e "${GREEN}Enabling fiewall...${NONE}"
ufw enable
echo -e "${GREEN}Starting ssh server...${NONE}"
systemctl start sshd
echo -e "${GREEN}Copying public key to authorized_keys...${NONE}"
mkdir -p ~/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2eahmP+twzeMWh8++gJ3CuohYw+NCHhc5wSpH9MrcBTvKjIf+ZpoJrw0Qz3B/aWzkf1GoS0HzLrnkU6/h1uilMJuN7P3AYpGXzlfRyakkNl7Ll3PxEmsI8pMZXwR9fXI8QMse97BSN/poOz2NkjUdbPHwUmxYVMUtc/sJkJv5uN71joSYdCd6HBxBrHv5btwkPBWDOwj0sXoPkmiyj1ogtt178BMvESmoJJ3nVrfVI1qug0QPRv7tP28LmEVOZGDJX6O7cco/mjeYCTQ7T/BT2BmbnnpbTL5lgYeLP5Lso79+M0U8RCPQFLNIDzvXUAfmX/oK0q8C+8CjP3KSgdNOlaMVO+Bn+fTGZxUKQLiGTrK2A+PEUCtNsT9eazFX2kM8Oyr7YNkHVJYHL6l1yPFUYlSxy6cGHg/SBKV66CgWW60X4Czq1NgrgD0Eg5bOt0ANbTm1kYQr5yo7iWAq+wrzKAwZCwAyOPWjWRMu/UUTh8EMAluKmlfYojCwtKzvGJk=" >> ~/.ssh/authorized_keys
echo -e "${GREEN}Setting permissions for authorized_keys...${NONE}"
chmod 600 ~/.ssh/authorized_keys
echo -e "${GREEN}Setting permissions for .ssh directory...${NONE}"
chmod 700 ~/.ssh
echo -e "${GREEN}Disabling password authentication...${NONE}"
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
echo -e "${GREEN}Disabling root login...${NONE}"
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
echo -e "${GREEN}Restarting ssh server...${NONE}"
systemctl restart sshd
echo -e "${GREEN}Allowing ssh through firewall...${NONE}"
ufw allow ssh
echo -e "${GREEN}Done! your ip is $(host myip.opendns.com resolver1.opendns.com | grep "myip.opendns.com has" | awk '{print $4}')${NONE}"
