# ─────────────────────────────────────────────
# Base image — slim Python is enough for Ansible
# ─────────────────────────────────────────────
FROM python:3.11-slim

# ── System dependencies Ansible needs
RUN apt-get update && apt-get install -y \
    openssh-client \
    sshpass \
    git \
    && rm -rf /var/lib/apt/lists/*

# ── Install Ansible + Netmiko (for network_cli transport)
RUN pip install --no-cache-dir \
    ansible==9.5.1 \
    paramiko \
    netmiko

# ── Install Cisco IOS collection
RUN ansible-galaxy collection install cisco.ios

# ── Set working directory inside container
WORKDIR /ansible

# ── Copy only the files that are BAKED IN (not IPs, not output)
COPY ansible.cfg /ansible/ansible.cfg
COPY backup_config.yml /ansible/playbook.yml

# ── inventory.ini and backups/ are NOT copied here
# ── They will be mounted at runtime from your host machine

# ── Default command when container runs
CMD ["ansible-playbook", "-i", "/ansible/inventory.yml", "/ansible/playbook.yml"]
