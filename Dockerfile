FROM centos
WORKDIR /root

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*; sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum update -y; yum upgrade -y;
RUN yum install -y nano sudo wget epel-release telnet;
RUN sudo dnf install dnf -y
RUN sudo dnf update -y
RUN sudo dnf install net-tools -y

COPY . .

# Installing python and flask
RUN yum install gcc openssl-devel bzip2-devel libffi-devel -y
RUN sudo yum install -y python3 python3-pip
RUN pip3 install Flask requests
EXPOSE 5000

CMD [ "python3", "/root/app.py"]

