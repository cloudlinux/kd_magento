FROM kuberdock/php-nginx

ENV MAGENTO_VERSION 2.1.2

RUN curl https://codeload.github.com/magento/magento2/tar.gz/$MAGENTO_VERSION | tar xz \
    && mv magento2-$MAGENTO_VERSION /usr/src/app/magento2 \
    && cd magento2 && composer install \
    && sed -i 's/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/g' /etc/php5/fpm/php.ini \
    && rm /usr/src/app/magento2/var/.regenerate && chown -R www-data:www-data /usr/src/app

RUN echo "* * * * * /usr/bin/php /usr/src/app/magento2/bin/magento cron:run" | crontab -u www-data -

COPY nginx.conf /etc/nginx/conf.d/default.conf
