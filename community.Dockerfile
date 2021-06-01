FROM debian:10.6-slim

#install python and python-pip
RUN apt-get update -y && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y

ARG ANSIBLE_VERSION=3.0

#install ansible
RUN pip3 install ansible==$ANSIBLE_VERSION && \
    pip3 install paramiko

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
