FROM ubuntu:12.04

MAINTAINER Beshoy Girgis <shoy@1ds.us>

# Set up ansible
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install python-yaml python-jinja2 \
        python-httplib2 python-keyczar python-paramiko python-setuptools \
        python-pkg-resources git python-pip build-essential python-dev python-software-properties && \
    mkdir -p /etc/ansible/ && \
    echo '[local]\nlocalhost\n' > /etc/ansible/hosts && \
    pip install ansible && \
    apt-get purge --auto-remove -y python2.6 python2.6-minimal

# Add the ansible playbook
ADD ansible /srv/server

# Run the playbooks
RUN ansible-playbook /srv/server/server.yml -c local

# forward nginx and php-fpm request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir /var/log/php-fpm/
RUN ln -sf /dev/stderr /var/log/php-fpm/error.log
RUN ln -sf /dev/stderr /var/log/php5.5-fpm.log
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
