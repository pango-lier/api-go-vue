#!/bin/sh
set -e

# chmod -R o+rw bootstrap/cache
# chmod -R o+rw storage

# Enable Laravel schedule
if [[ "${ENABLE_CRONTAB:-0}" = "1" ]]; then
  cp -f /etc/supervisor.d/cron.conf.default /etc/supervisor.d/cron.conf
  echo "* * * * * php /var/www/html/artisan schedule:run >> /dev/null 2>&1" >>/etc/crontabs/www-data
else
  rm -f /etc/supervisor.d/cron.conf
  rm -f /etc/crontabs/www-data
fi

# Enable Laravel queue workers
if [[ "${ENABLE_WORKER:-0}" = "1" ]]; then
  cp -f /etc/supervisor.d/worker.conf.default /etc/supervisor.d/worker.conf
else
  rm -f /etc/supervisor.d/worker.conf
fi

# Enable Laravel horizon
if [[ "${ENABLE_HORIZON:-0}" = "1" ]]; then
  cp -f /etc/supervisor.d/horizon.conf.default /etc/supervisor.d/horizon.conf
else
  rm -f /etc/supervisor.d/horizon.conf
fi

exec "$@"
