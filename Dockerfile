# 

FROM ubuntu:latest
MAINTAINER Matt Cahill

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
    vim \
    vim-puppet \
    git \
    traceroute \
    dnsutils \
    python-pip && \
    mkdir -p /var/lib/puppet/gitlab-webhook-receiver && \
    git clone https://github.com/matt-cahill/gitlab-webhook-receiver.git /var/lib/puppet/gitlab-webhook-receiver && \
    ln -s /var/lib/puppet/gitlab-webhook-receiver/gitlab-webhook-receiver /etc/init.d/gitlab-webhook-receiver && \
    update-rc.d gitlab-webhook-receiver defaults && \
    touch /var/lib/puppet/gitlab-webhook-receiver/webhook.log && \
    chmod 666 /var/lib/puppet/gitlab-webhook-receiver/webhook.log && \
    echo "set modeline" > /root/.vimrc && \
    echo "export TERM=vt100" >> /root/.bashrc && \
    LANG=en_US.UTF-8 locale-gen --purge en_US.UTF-8 && \
    echo 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales

EXPOSE 8000

CMD tail -f /var/lib/puppet/gitlab-webhook-receiver/webhook.log
