FROM matomo:apache

ENV PHP_MEMORY_LIMIT=512M

RUN { \
      echo 'upload_max_filesize=512M'; \
      echo 'post_max_size=512M'; \
    } > /usr/local/etc/php/conf.d/zzz-matomo.ini