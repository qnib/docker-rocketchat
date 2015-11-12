###### Docker image
FROM qnib/d-node

RUN groupadd rocketchat && \
    useradd -s /bin/false -d /opt/rocketchat/ -g rocketchat rocketchat
# gpg: key 4FD08014: public key "Rocket.Chat Buildmaster <buildmaster@rocket.chat>" imported RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 0E163286C20D07B9787EBE9FD7F9D0414FD08104
RUN mkdir -p /opt/rocketchat/ && \
    curl -fsL "https://s3.amazonaws.com/rocketchatbuild/rocket.chat-v.latest.tgz" |tar xzf - -C /opt/rocketchat/ && \
    cd /opt/rocketchat/bundle/programs/server && \
    npm install
ENV MONGO_URL=mongodb://mongodb.service.consul:27017/meteor \ 
    PORT=3000 \
    ROOT_URL=http://0.0.0.0:3000 
ADD etc/supervisord.d/*.ini /etc/supervisord.d/
ADD opt/qnib/rocketchat/bin/start.sh /opt/qnib/rocketchat/bin/
ADD etc/consul.d/rocketchat.json /etc/consul.d/
