# Northwind Coffee Co. - staging image.
# Bakes the site's wp-content (theme, plugins, must-use plugins) on top of a
# stock WordPress so the environment boots consistently anywhere.
FROM wordpress:6.7-php8.2-apache

# The official image seeds /var/www/html from /usr/src/wordpress on first boot.
COPY wp-content/ /usr/src/wordpress/wp-content/

# Host PHP mail configuration.
COPY php/zz-mail.ini /usr/local/etc/php/conf.d/zz-mail.ini
