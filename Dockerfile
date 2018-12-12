# FROM centos:6
FROM centos:7

MAINTAINER Liming Zhang <tongjiyiming@gmail.com>

RUN yum install -y epel-release
RUN yum -y update
RUN yum install -y wget ntp sudo

# configure ssh free key access
RUN yum install -y which openssh-clients openssh-server
RUN echo 'root:hortonworks' | chpasswd
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN sed -i '/pam_loginuid.so/c session    optional     pam_loginuid.so'  /etc/pam.d/sshd
RUN echo -e "Host *\n StrictHostKeyChecking no" >> /etc/ssh/ssh_config

RUN yum -y install supervisor
RUN mkdir /etc/supervisor.d/
RUN echo -e "[program:sshd]\ncommand=/sbin/service sshd start" >> /etc/supervisord.conf
RUN echo -e "[program:ntpd]\ncommand=/sbin/service ntpd start" >> /etc/supervisord.conf

# to test public release 2.2.2, you can modigy to test the other version of ambari
RUN wget -O /etc/yum.repos.d/ambari.repo http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo

RUN yum install ambari-server -y
RUN ambari-server setup -s
RUN yum install numpy -y
RUN yum clean all

EXPOSE 10-90 
EXPOSE 100-999
EXPOSE 1000-9999
EXPOSE 10000-65535

CMD /usr/bin/supervisord -n
