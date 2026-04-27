


FROM python:3.11-slim

# System dependencies
RUN apt-get update && apt-get install -y \
    openssh-client \
    sshpass \
    git \
    && rm -rf /var/lib/apt/lists/*

# Ansible + Netmiko
RUN pip install --no-cache-dir \
    ansible==9.5.1 \
    paramiko \
    netmiko

#Cisco IOS 
RUN ansible-galaxy collection install cisco.ios

 
WORKDIR /ansible


COPY ansible.cfg /ansible/ansible.cfg
COPY backup_config.yml /ansible/playbook.yml

CMD ["ansible-playbook", "-i", "/ansible/inventory.yml", "/ansible/playbook.yml"]
