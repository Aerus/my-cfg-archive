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

# Install HAProxy
RUN yum install -y haproxy
ADD haproxy.cfg /etc/haproxy/



#Clear up yum cache
RUN yum clean all

VOLUME ["/etc/haproxy"]

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
