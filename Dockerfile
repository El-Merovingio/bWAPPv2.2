FROM ubuntu:14.04
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ trusty main multiverse restricted universe" > /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main multiverse restricted universe" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main multiverse restricted universe" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-security main multiverse restricted universe" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main multiverse restricted universe" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty main multiverse restricted universe" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main multiverse restricted universe" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main multiverse restricted universe" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main multiverse restricted universe" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main multiverse restricted universe" >> /etc/apt/sources.list

RUN apt-get -y update
RUN apt-get -y install php5 php5-mysqlnd mariadb-server wget unzip curl supervisor

RUN /etc/init.d/mysql start &&\
    mysql -e "grant all privileges on *.* to 'root'@'localhost' identified by 'toor';" &&\
    mysql -u root -ptoor -e "show databases;"

WORKDIR /var/www/html/

RUN echo "[supervisord]" > /etc/supervisor/conf.d/bwapp.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/bwapp.conf

RUN echo "[program:mysqld]" >> /etc/supervisor/conf.d/bwapp.conf
RUN echo "command=/etc/init.d/mysql restart" >> /etc/supervisor/conf.d/bwapp.conf

RUN echo "[program:apache2]" >> /etc/supervisor/conf.d/bwapp.conf
RUN echo "command=/etc/init.d/apache2 restart" >> /etc/supervisor/conf.d/bwapp.conf

RUN wget https://jaist.dl.sourceforge.net/project/bwapp/bWAPP/bWAPPv2.2/bWAPPv2.2.zip --no-check-certificate && unzip bWAPPv2.2.zip


RUN echo '<!DOCTYPE html>' > index.html
RUN echo '<html>' >> index.html
RUN echo '<head>' >> index.html
RUN echo '    <script>' >> index.html
RUN echo '        window.location.href = "bWAPP/index.php";' >> index.html
RUN echo '    </script>' >> index.html
RUN echo '</head>' >> index.html
RUN echo '<body>' >> index.html
RUN echo '</body>' >> index.html
RUN echo '</html>' >> index.html

# Replacing $db_password with sed
RUN echo "c2VkIC1pICJzL1wkZGJfcGFzc3dvcmQgPSBcIi4qXCI7L1wkZGJfcGFzc3dvcmQgPSBcInRvb3JcIjsvIiBiV0FQUC9hZG1pbi9zZXR0aW5ncy5waHAK"|base64 -d|sh

RUN /etc/init.d/mysql restart && /etc/init.d/apache2 restart &&\
  curl http://127.0.0.1/bWAPP/install.php?install=yes 1>/dev/null


EXPOSE 80

CMD ["/usr/bin/supervisord"]
