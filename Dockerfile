FROM centos:latest

MAINTAINER Beshoy Girgis <shoy@1ds.us>

RUN yum clean all && \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip
RUN mkdir /etc/ansible/
RUN echo -e '[local]\nlocalhost' > /etc/ansible/hosts
RUN pip install ansible

# Add the ansible playbooks
ADD ansible /srv/server

# Run the playbooks
RUN ansible-playbook /srv/server/server.yml -c local

RUN mkdir /site
WORKDIR /site

EXPOSE 22 80 443

CMD ["supervisord", "-n"]
