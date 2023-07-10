FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y curl zip nginx

RUN echo "daemon off;" >>/etc/nginx/nginx.conf


RUN curl -o /var/www/html/game.zip -L https://github.com/gabrielecirulli/2048.git

RUN cd /var/www/html/ && unzip game.zip && mv 2048-game/* . && rm -rf 2048-game game.zip

EXPOSE 80


CMD ["/usr/sbin/nginx","-c","/etc/nginx/nginx.conf"]

