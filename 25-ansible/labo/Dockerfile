# Faux serveur Ubuntu pour s'entraîner avec Ansible : comme une EC2 (SSH, utilisateur ubuntu, sudo, Python)
FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-server python3 sudo \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/sshd \
    && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
    && chmod 440 /etc/sudoers.d/ubuntu

ARG CLE_PUBLIQUE
RUN install -d -m 700 -o ubuntu -g ubuntu /home/ubuntu/.ssh \
    && echo "$CLE_PUBLIQUE" > /home/ubuntu/.ssh/authorized_keys \
    && chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys \
    && chmod 600 /home/ubuntu/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]
