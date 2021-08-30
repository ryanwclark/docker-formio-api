FROM ryanwclark/nodejs:latest
LABEL maintainer="Ryan Clark (ryanwclark@yahoo.com)"

### Set Defaults
ENV FORMIO_VERSION=v2.2.3 \
    FORMIO_CLIENT_VERSION=master \
    ENABLE_SMTP=FALSE \
    ENABLE_CRON=FALSE \
    ZABBIX_HOSTNAME=formio-api-app

### Install Runtime Dependencies
RUN set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .formio-build-deps \
                git \
                g++ \
                make \
                python3 \
                && \
    \
    sudo -u nodejs git clone -b $FORMIO_VERSION https://github.com/formio/formio.git /app/ && \
    sudo -u nodejs git clone -b $FORMIO_CLIENT_VERSION https://github.com/formio/formio-app-formio.git /app/client && \
    \
    cd /app && \
    sudo -u nodejs npm install && \
    \
### Misc & Cleanup
    mkdir -p /app/templates && \
    chown -R nodejs. /app && \
    apk del .formio-build-deps && \
    rm -rf /tmp/* /var/cache/apk/*

WORKDIR /app/

### Networking Configuration
EXPOSE 3001 

### Add Files
ADD install /

