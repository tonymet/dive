FROM ubuntu:14.04

RUN apt update
RUN apt install -y tzdata
RUN dpkg-reconfigure -f noninteractive tzdata
RUN apt install -y curl git
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt install -y nodejs
RUN apt install -y apache2
RUN apt install -y libapache2-mod-fastcgi php5-fpm php5-mysql php5-mcrypt php5-cli php5-curl
RUN curl -s https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN a2enmod actions
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_fcgi
RUN a2enmod rewrite
RUN echo '<IfModule mod_fastcgi.c>\n\
    AddType application/x-httpd-fastphp5 .php\n\
    Action application/x-httpd-fastphp5 /php5-fcgi\n\
    Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi\n\
    FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -socket /var/run/php5-fpm.sock -pass-header Authorization\n\
    <Directory /usr/lib/cgi-bin>\n\
        Require all granted\n\
    </Directory>\n\
</IfModule>\n'\
> /etc/apache2/mods-enabled/fastcgi.conf
RUN service php5-fpm start
RUN php5enmod mcrypt
CMD bash -c 'sleep 1 && service php5-fpm restart & apachectl -DFOREGROUND'
