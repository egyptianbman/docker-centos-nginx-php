#!/usr/bin/env bash

# Tweak nginx to match the workers to cpu's
procs=$(cat /proc/cpuinfo |grep processor | wc -l)
sed -i -e "s/worker_processes auto/worker_processes $procs/" /etc/nginx/nginx.conf

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
