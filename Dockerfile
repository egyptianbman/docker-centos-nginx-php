FROM centos:latest

MAINTAINER Beshoy Girgis <shoy@1ds.us>

# Set up ansible
RUN yum clean all && \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip
RUN mkdir /etc/ansible/
RUN echo -e '[local]\nlocalhost' > /etc/ansible/hosts
RUN pip install ansible

# Add the ansible playbook
ADD ansible /srv/server

# Run the playbooks
RUN ansible-playbook /srv/server/server.yml -c local

# Slim down the container
RUN yum clean all

# forward nginx and php-fpm request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stderr /var/log/php-fpm/error.log
RUN ln -sf /dev/stderr /var/log/php-fpm/www-error.log
RUN ln -sf /dev/stderr /var/log/php-fpm/www-slow.log

# Create site directory and set it as the default
RUN mkdir /site
WORKDIR /site

# expose ports
EXPOSE 80

# Add startup script
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

# Execute start script
CMD ["/bin/bash", "/start.sh"]
