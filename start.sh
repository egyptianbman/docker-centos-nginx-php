#!/usr/bin/env bash

# Tweak nginx to match the workers to cpu's
procs=$(cat /proc/cpuinfo |grep processor | wc -l)
sed -i -e "s/worker_processes auto/worker_processes $procs/" /etc/nginx/nginx.conf

# helper functions to restart nginx and php-fpm.
echo "function restart-nginx {kill \$(ps -eo pid,comm | grep nginx | awk 'NR == 1 {print \$1}'); }" >> /root/.bashrc
echo "function restart-php-fpm {kill \$(ps -eo pid,comm | grep php-fpm | awk 'NR == 1 {print \$1}'); }" >> /root/.bashrc

# execute local startup script if one is available
if [ -f "/docker/start.sh" ]; then
    chmod +x /docker/start.sh
    /docker/start.sh
fi

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
