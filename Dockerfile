FROM centos:centos6

RUN echo STARTING SERVER BUILD ... [$(date)]

# supervisord setup
RUN yum install python-setuptools -y
RUN easy_install pip
RUN pip install supervisor==3.1.2
COPY env/etc/supervisord /etc/supervisord

# Update Repos
RUN yum install wget -y
RUN wget -O /etc/yum.repos.d/remi.repo http://rpms.famillecollet.com/enterprise/remi.repo
RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
RUN wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
RUN rpm -K rpmforge-release*.rpm
RUN rpm -i rpmforge-release*.rpm
RUN rm -f rpmforge-release*.rpm
RUN rpm --import https://fedoraproject.org/static/0608B895.txt
RUN rpm -Uvh http://download-i2.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Install Apache and PHP
RUN yum clean all
RUN yum update -y
RUN yum groupinstall "Development tools" -y
RUN yum --enablerepo=remi install php \
    php-imagick \
    php-gd \
    php-mysqli \
    php-pecl-apc \
    php-pecl-memcache \
    php-mbstring httpd \
    sudo -y

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install NPM
RUN yum install npm -y

# Install Compass + Sass
RUN yum install which tar -y
RUN curl -sSL https://get.rvm.io | bash
RUN /bin/bash -lc 'rvm install 2.1'
RUN /bin/bash -lc 'rvm use 2.1 --default'
RUN /bin/bash -lc 'gem install compass sass --no-rdoc --no-ri'

# Install grunt-cli (workaround)
RUN npm install -g grunt-cli

# Done
RUN echo $(php --version | grep -m 1 PHP)                   >> /tmp/env-installed.txt
RUN echo $(git --version)                                   >> /tmp/env-installed.txt
RUN echo $(composer --version)                              >> /tmp/env-installed.txt
RUN /bin/bash -lc 'echo $(compass -v | grep -m 1 Compass)   >> /tmp/env-installed.txt'
RUN /bin/bash -lc 'echo $(sass -v | grep -m 1 Sass)         >> /tmp/env-installed.txt'
RUN echo $(grunt -v | grep -m 1 grunt-cli)                  >> /tmp/env-installed.txt

RUN cat /tmp/env-installed.txt
RUN echo FINISHED SERVER BUILD [$(date)]

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord/supervisord.conf"]
