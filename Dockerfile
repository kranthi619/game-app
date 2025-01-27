FROM ubuntu:22.04

# Update and install required packages
RUN apt-get update && apt-get install -y nginx zip curl

# Configure nginx to run in the foreground
RUN echo "daemon off;" >>/etc/nginx/nginx.conf

# Download the 2048 game ZIP file from GitHub
RUN curl -o /var/www/html/master.zip -L https://github.com/yuva19102003/2048/archive/refs/heads/master.zip

# Unzip the downloaded file, move contents to the right location, and clean up
RUN cd /var/www/html/ && \
    unzip master.zip && \
    mv 2048-game.github.io-master/* . && \
    rm -rf 2048-game.github.io-master master.zip

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf"]

