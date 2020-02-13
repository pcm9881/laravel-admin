#!/usr/bin/env bash

### run supervisor
sudo ADMIN_USER=$ADMIN_USER WEB_ROOT=$WEB_ROOT supervisord -n -c "/etc/supervisor/supervisord.conf"

### dev
php artisan ide-helper:generate
php artisan ide-helper:meta
php artisan ide-helper:models --no-interaction
