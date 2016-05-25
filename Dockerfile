# lsclassroom
#
# VERSION    0.1
# PRODUCTION VERSION
#
FROM debian:8
MAINTAINER Sven Kroll

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install --force-yes \
  php5-gd \
  php5-mysql \
  php5 \
  php5-cli \
  php5-mcrypt \
  apache2 \
  libapache2-mod-php5

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install --force-yes \
  tshark \
  mtr \
  wget \
  librsvg2-bin \
  gsfonts \
  rrdtool

# Installing sensor - voipmonitor service
RUN mkdir /usr/src/voipmonitor && \
    cd /usr/src/voipmonitor && \
    wget --content-disposition http://www.voipmonitor.org/current-stable-sniffer-static-64bit.tar.gz && \
    tar xzf voipmonitor*.tar.gz && \
    cd voipmonitor-* && \
    ./install-script.sh

# Installing IOncube - php loader / decryptor
RUN wget http://voipmonitor.org/ioncube/x86_64/ioncube_loader_lin_5.6.so -O /usr/lib/php5/20131226/ioncube_loader_lin_5.6.so && \
  echo "zend_extension = /usr/lib/php5/20131226/ioncube_loader_lin_5.6.so" > /etc/php5/mods-available/ioncube.ini && \
  ln -s /etc/php5/mods-available/ioncube.ini /etc/php5/apache2/conf.d/01-ioncube.ini && \
  ln -s /etc/php5/mods-available/ioncube.ini /etc/php5/cli/conf.d/01-ioncube.ini

# Install voipmonitor gui
RUN cd /var/www/html && \
  rm -f index.html && \
  wget "http://www.voipmonitor.org/download-gui?version=latest&major=5&phpver=56&festry" -O w.tar.gz && \
  tar xzf w.tar.gz && \
  mv voipmonitor-gui*/* ./ && \
  mkdir -p /var/spool/voipmonitor/ && \
  chown www-data /var/spool/voipmonitor/ && \
  chown -R www-data /var/www/html && \
  /etc/init.d/apache2 restart

COPY voipmonitor.conf /etc/

RUN echo " * * * * * root php /var/www/html/php/run.php cron" >> /etc/crontab

# install Supervisord
RUN apt-get update && apt-get install -y --force-yes python-setuptools;
RUN easy_install supervisor==3.1.0 && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor
COPY supervisord.conf /etc/supervisor/supervisord.conf

CMD ["/usr/local/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]

Expose 80 5029