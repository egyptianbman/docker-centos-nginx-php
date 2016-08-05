#!/usr/bin/env bash

# Tweak nginx to match the workers to cpu's
procs=$(cat /proc/cpuinfo |grep processor | wc -l)
sed -i -e "s/worker_processes auto/worker_processes $procs/" /etc/nginx/nginx.conf

# execute local startup script if one is available
if [ -f "/docker/start.sh" ]; then
    chmod +x /docker/start.sh
    /docker/start.sh
fi

# Start supervisord and services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf
