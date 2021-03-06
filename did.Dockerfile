FROM debian:9.4-slim

#install the build deps
RUN apt-get update -y && apt-get install -y make \
    git \
    make \
    python-setuptools \
    gcc \
    python-dev \
    libffi-dev \
    libssl-dev \
    python-packaging && \
    rm -rf /var/lib/apt/lists/* && \
    #build and install ansible
    mkdir -p /ansible && \
    cd /ansible/ && \
    git clone git://github.com/ansible/ansible.git && \
    cd /ansible/ansible && \
    git checkout stable-2.7 && \
    make && \
    make install && \
    rm -rf /ansible/ansible && \
    #remove dev deps
    apt-get remove -y git \
    make \
    gcc \
    libffi-dev \
    libssl-dev \
    python-dev && \
    apt-get autoremove -y

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True

RUN apt-get update -y && \
    apt-get install -y python-dev \
    python-pip \
    curl && \
    curl https://bootstrap.pypa.io/get-pip.py | python && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/bin/
RUN curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-Linux-x86_64 > /usr/bin/docker-compose
RUN chmod +x /usr/bin/docker-compose

RUN pip install docker
RUN pip install docker-compose

RUN adduser --disabled-password --gecos "" docker

#ENTRYPOINT [ "/bin/bash" ]
ENTRYPOINT [ "ansible-playbook" ]
CMD [ "playbook.yml","-i","hosts","--private-key","~/.ssh/key"]