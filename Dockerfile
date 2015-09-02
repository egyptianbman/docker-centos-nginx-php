FROM centos:latest

MAINTAINER Beshoy Girgis <shoy@1ds.us>

# Update package lists and packages
RUN yum -y update && yum -y upgrade

## Remi Dependency on CentOS 7 and Red Hat (RHEL) 7 ##
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

## CentOS 7 and Red Hat (RHEL) 7 ##
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

# Install base packages
RUN yum install -y --enablerepo=remi,remi-php56 \
    git \
    nginx \
    php-common \
    php-fpm \
    vim \
    zsh

# Install additional packages/modules
RUN yum install -y --enablerepo=remi,remi-php56 \
    php-cli \
    php-gd \
    php-mbstring \
    php-mcrypt \
    php-opcache \
    php-pdo \
    php-pear \
    php-pecl-memcached

# tweak php-fpm config
# RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini && \
#     sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini && \
#     sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini && \
#     sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf && \
#     sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf && \
#     sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php5/fpm/pool.d/www.conf && \
#     sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php5/fpm/pool.d/www.conf && \
#     sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php5/fpm/pool.d/www.conf && \
#     sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php5/fpm/pool.d/www.conf && \
#     sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php5/fpm/pool.d/www.conf

# Installing supervisor
RUN yum install -y python-setuptools
RUN easy_install pip
RUN pip install supervisor

# Adding the configuration file of the Supervisor
ADD supervisord.conf /etc/

# Add github to known_hosts
RUN mkdir $HOME/.ssh/ && ssh-keyscan github.com >> $HOME/.ssh/known_hosts

# Set up dotfiles.
RUN git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick \
    && printf '\nsource "$HOME/.homesick/repos/homeshick/homeshick.sh"' > $HOME/.zshrc \
    && $HOME/.homesick/repos/homeshick/bin/homeshick -fb clone https://github.com/keelerm84/dotfiles.git \
    && $HOME/.homesick/repos/homeshick/bin/homeshick -fb link

EXPOSE 80
EXPOSE 443

CMD ["supervisord", "-n"]
