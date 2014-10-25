echo "
=========================================================================
=========================================================================
STARTING SERVER BUILD ... [$(date)]
=========================================================================
"

cd

echo 'Installing wget ...'
yum install wget -y

echo 'Installing yum repos ...'
wget -O /etc/yum.repos.d/remi.repo http://rpms.famillecollet.com/enterprise/remi.repo
rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
rpm -K rpmforge-release*.rpm
rpm -i rpmforge-release*.rpm
rm -f rpmforge-release*.rpm
rpm --import https://fedoraproject.org/static/0608B895.txt
rpm -Uvh http://download-i2.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum repolist

echo "Installing libs ..."

yum clean all
yum update -y && \
yum groupinstall "Development tools" -y && \
yum --enablerepo=remi install php \
    php-imagick \
    php-gd \
    php-mysqli \
    php-pecl-apc \
    php-pecl-memcache \
    php-mbstring httpd \
    sudo -y

echo 'Installing composer ...'
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

setsebool -P httpd_can_network_connect=1

echo "
=========================================================================
Installation Complete
=========================================================================

> $(php --version | grep -m 1 PHP)
> $(git --version)
> $(composer --version)

=========================================================================
FINISHED SERVER BUILD [$(date)]
=========================================================================
=========================================================================
"
