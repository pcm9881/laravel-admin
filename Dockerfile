FROM ubuntu:18.04

RUN apt-get update -y

ENV WEB_ROOT    /app/admin
ENV ADMIN_USER  pcm

### Ensure UTF-8
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

### UTC Time -> KST
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

### prepare apt-repository
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ondrej/php
RUN add-apt-repository -y ppa:nginx/stable

RUN apt-get update -y

RUN apt-get install -y \
    wget \
    curl \
    git \
    sudo \
    supervisor 

RUN apt-get install -y \
    php7.3 \
    php7.3-fpm \
    php7.3-zip \
    php7.3-mbstring \
    php7.3-xml \
    php7.3-pgsql

RUN adduser --disabled-password --gecos "" ${ADMIN_USER}
RUN usermod -a -G www-data ${ADMIN_USER}
RUN usermod -a -G sudo ${ADMIN_USER}
RUN echo ${ADMIN_USER} ALL=NOPASSWD: ALL >> /etc/sudoers

RUN mkdir -p ${WEB_ROOT}
RUN chown -R ${ADMIN_USER}:${ADMIN_USER} ${WEB_ROOT}

### supervisord
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/


EXPOSE 80 443
VOLUME [ "${WEB_ROOT}" ]

RUN service php7.3-fpm start

## composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

ADD entrypoint.sh /app/
RUN chown ${ADMIN_USER}:${ADMIN_USER} /app/entrypoint.sh
RUN chmod 744 /app/entrypoint.sh

WORKDIR ${WEB_ROOT}

CMD ["/app/entrypoint.sh"]