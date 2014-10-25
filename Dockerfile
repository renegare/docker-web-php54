FROM centos:centos6

# Build Web Server Environment
COPY env/tmp/develop.sh /tmp/build.sh
RUN chmod +x /tmp/build.sh
RUN /tmp/build.sh

# supervisord setup
RUN yum install python-setuptools -y
RUN easy_install pip
RUN pip install supervisor==3.1.2

COPY env/etc/supervisord /etc/supervisord

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord/supervisord.conf"]
