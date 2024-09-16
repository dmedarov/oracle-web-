FROM httpd:2.4
WORKDIR /var/www/html/
COPY ./index.html /var/www/html/
EXPOSE 80

