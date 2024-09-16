FROM httpd:latest
RUN apt update -y && apt install nodejs -y
ENTRYPOINT node -v

WORKDIR /usr/local/apache2/htdocs/
COPY ./ /usr/local/apache2/htdocs/
EXPOSE 80

