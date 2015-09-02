FROM centos:latest

MAINTAINER Beshoy Girgis <shoy@1ds.us>

# Update package lists and packages
RUN yum -y update && yum -y upgrade

## EPEL: Remi Dependency on CentOS 7 and Red Hat (RHEL) 7 ##
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

## REMI: CentOS 7 and Red Hat (RHEL) 7 ##
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

## MYSQL: CentOS 7 and Red Hat (RHEL) 7 ##
RUN rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm

# Install base packages
RUN yum install -y --enablerepo=mysql56-community-source,remi,remi-php56 \
    git \
    mysql \
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
