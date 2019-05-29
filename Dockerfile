FROM centos:7
MAINTAINER TLKJ.Leo "379978424@qq.com"

USER root

# Set Docker LANG
ENV LANG en_US.UTF-8

# Set Docker timezone
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' >/etc/timezone

# Install System library
RUN yum -y install zlib-devel bzip2-devel \ 
	openssl-devel ncurses-devel sqlite-devel \ 
	readline-devel tk-devel gdbm-devel db4-devel \ 
	libpcap-devel xz-devel libffi-devel gcc gcc-c++ \ 
	wget make pcre pcre-devel openssl vim dos2unix \
	crontab mysql-devel zip unzip git net-tools && \
	yum clean all && \
	rm -rf /var/cache/yum/*

# Install Python3.7.2
RUN mkdir /home/install_env && \
    cd /home/install_env && \
	wget https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tar.xz && \ 
	tar -xJf Python-3.7.2.tar.xz && \ 
	mkdir /usr/local/Python3.7.2 && \ 
	cd Python-3.7.2 && \ 
	./configure --prefix=/usr/local/Python3.7.2 && \ 
	make && make install && \ 
	ln -s /usr/local/Python3.7.2/bin/python3 /usr/local/bin/python3 && \ 
	ln -s /usr/local/Python3.7.2/bin/pip3 /usr/local/bin/pip3 && \ 
	rm -rf /home/install_env/Python-3.7.2 && \
    rm -f /home/install_env/Python-3.7.2.tar.xz

# Update Python Library
RUN pip3 install -U pip -i https://mirrors.aliyun.com/pypi/simple/ && \
    pip3 install -U wheel -i https://mirrors.aliyun.com/pypi/simple/ && \
    pip3 install -U setuptools -i https://mirrors.aliyun.com/pypi/simple/

# Configure Python PATH
ENV PATH $PATH:/usr/local/Python3.7.2/bin

# Configure supervisor
RUN pip3 install git+https://github.com/Supervisor/supervisor

# Configure Filebeat filebeat-7.1.0-linux-x86_64
RUN wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.1.0-linux-x86_64.tar.gz -P /home/install_env && \
    mkdir /usr/local/filebeat && \
    cd /home/install_env && \
    tar -zxf filebeat-7.1.0-linux-x86_64.tar.gz -C /usr/local/filebeat && \
    rm -f /home/install_env/filebeat-7.1.0-linux-x86_64.tar.gz
ENV PATH $PATH:/usr/local/filebeat/filebeat-7.1.0-linux-x86_64

EXPOSE 9001
EXPOSE 15000
