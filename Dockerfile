# Basic Dockerfile
FROM i386/ubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    curl wget zip php php-mysql libapache2-mod-php \
    mysql-server apache2 sqlite3

RUN wget https://github.com/NonFungibleHacker/bWAPPv2.2/raw/main/bWAPP.zip && \
    unzip bWAPP.zip -d /var/www/html/ && \
    chown -R www-data:www-data /var/www/html/ && \
    mkdir /var/www/html/bWAPP/logs/ && \
    chmod 777 /var/www/html/bWAPP/passwords/ /var/www/html/bWAPP/images/ /var/www/html/bWAPP/documents/ /var/www/html/bWAPP/logs/

EXPOSE 80

CMD ["sh", "-c", "service apache2 start && service mysql start && ./var/www/html/sc1.sh && service mysql restart && tail -f /dev/null"]
