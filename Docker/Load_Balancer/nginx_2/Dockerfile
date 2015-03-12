FROM centos:latest

MAINTAINER Aerus

# Update RPM Packages
RUN yum -y update

# Install basic packages
RUN yum install -y wget tar epel-release

# Install supervisord
RUN yum install -y supervisor
RUN rm -f /etc/supervisord.conf /etc/supervisord.conf.org
ADD supervisord.conf /etc/

# Set timezone
RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Kiev /etc/localtime

# Install rsyslogd
RUN yum install -y rsyslog
ADD all-log.conf /etc/rsyslog.d/

# Install nginx
RUN rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN yum install -y nginx
RUN rm -f /etc/nginx/conf.d/default.conf
ADD default.conf /etc/nginx/conf.d/
ADD nginx.conf /etc/nginx/


#Clear up yum cache
RUN yum clean all

VOLUME ["/etc/nginx"]

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
