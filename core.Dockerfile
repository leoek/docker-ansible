FROM debian:bullseye-slim

ARG ANSIBLE_VERSION=2.11

#install python and python-pip
RUN apt-get update -y && \
    apt-get install -y python3 python3-pip && \
#install ansible
    pip3 install ansible-core==$ANSIBLE_VERSION && \
    pip3 install paramiko && \
    apt-get purge -y python3-pip && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True

#ENTRYPOINT [ "/bin/bash" ]
ENTRYPOINT [ "ansible-playbook" ]
CMD [ "playbook.yml","-i","hosts","--private-key","~/.ssh/key"]
