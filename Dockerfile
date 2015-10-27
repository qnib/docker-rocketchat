###### Docker image
FROM qnib/u-terminal

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" >>  /etc/apt/sources.list.d/mongodb-org-3.0.list && \
    apt-get update && \
    apt-get install -y git nodejs npm mongodb-org curl && \
    ln -s /usr/bin/nodejs /usr/bin/node
ADD etc/supervisord.d/mongod.ini /etc/supervisord.d/

RUN npm install nave -g && \
    nave usemain 0.10.40

RUN curl -s https://install.meteor.com/ | sh

RUN npm install pm2 -g && \
    pm2 startup

RUN mkdir -p /var/www && \
    curl -fsL wget https://github.com/RocketChat/Rocket.Chat/archive/master.tar.gz|tar xfz - -C /var/www/ && \
    mv /var/www/Rocket.Chat-master /var/www/rocket.chat

ADD pm2-rocket-chat.json /var/www/rocket.chat/
RUN export HOST=http://192.168.99.100 && \
    cd /var/www/rocket.chat && \
    meteor build --server "$HOST" --directory .
