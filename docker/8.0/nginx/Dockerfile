FROM nginx:alpine

COPY app.conf  /etc/nginx/conf.d/app.conf
COPY . /var/www
RUN chmod -R 777 /var/www/html/routes
RUN chmod -R 777 /var/www/html/storage
