FROM centos:centos6

# Add repos
RUN yum install wget -y && \
    rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt && \
    wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm && \
    rpm -K rpmforge-release*.rpm && \
    rpm -i rpmforge-release*.rpm && \
    rm -f rpmforge-release*.rpm && \
    rpm --import https://fedoraproject.org/static/0608B895.txt && \
    rpm -Uvh http://download-i2.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
COPY etc/yum.repos.d/remi.repo /etc/yum.repos.d/remi.repo

# install os libs
RUN yum install -y php \
    php-imagick \
    php-gd \
    php-mysqli \
    php-pecl-apc \
    php-pecl-memcache \
    php-mbstring httpd \
    sudo which tar
RUN curl -sL https://rpm.nodesource.com/setup | bash - && \
    yum install -y nodejs
RUN yum install -y gcc-c++ make

# install and setup supervisord
RUN yum install python-setuptools -y && \
    easy_install pip && \
    pip install supervisor==3.1.2
COPY etc/supervisord /etc/supervisord

# Install app libs
# Composer (PHP Packagemanger)
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Compass + Sass
RUN curl -sSL https://get.rvm.io | bash && \
    /bin/bash -lc 'rvm install 2.1' && \
    /bin/bash -lc 'rvm use 2.1 --default' && \
    /bin/bash -lc 'gem install compass sass --no-rdoc --no-ri'

# grunt-cli (workaround)
RUN npm install -g grunt-cli

# git
RUN yum install -y git

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord/supervisord.conf"]
