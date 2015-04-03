FROM tutum/ubuntu:latest

MAINTAINER Maintainer <peter.foerger@dkd.de>

ENV TYPO3_VERSION dev-master


# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        git \
        graphicsmagick \
        apache2 \
        libapache2-mod-php5 \
        mysql-client \
        php5-mcrypt \
        php5-mysql \
        php5-gd \
        php5-curl \
		php5-cli \
        php5-xdebug \
        php5-xhprof && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini



# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh


# Fetch typo3_src
RUN composer create-project typo3/cms-base-distribution CmsBaseDistribution $TYPO3_VERSION

# Link distribution to document root
RUN rm -rf /var/www/html && ln -s /CmsBaseDistribution /var/www/html

EXPOSE 80
WORKDIR /CmsBaseDistribution
CMD ["/run.sh"]
