#!/bin/bash

# ########### GIT INSTALL ###########
yum -y install git

# ########### ANSIBLE INSTALL ###########
yum install -y epel-release
yum -y install ansible

# ########### SELINUX LIBS INSTALL ###########
[ "$(getenforce)" == "Enforcing" ] && yum install -y libselinux-python

# ########### ANSIBLE-PULL HOST SETTING ###########
file="/etc/ansible/hosts"
[[ -f "$file" ]] && rm -f "$file"
 
cat << EOF > "$file"
localhost ansible_connection=local
EOF

chmod 644 /etc/ansible/hosts

# ########### ANSIBLE-PULL CRON SETTING ###########
dir="/etc/ansible/barbershop"
[[ -d "$dir" ]] && rm -rf "$dir"
mkdir "$dir"
file="/etc/cron.d/ansible-pull"
[[ -f "$file" ]] && rm -f "$file"

cat << EOF > "$file" 
# Cron job to git clone/pull a repo and then run locally
*/15 * * * * root ansible-pull -o -d /etc/ansible/barbershop -U https://github.com/ssgeejr/barbershop.git 2>&1
EOF

chmod 644 /etc/cron.d/ansible-pull