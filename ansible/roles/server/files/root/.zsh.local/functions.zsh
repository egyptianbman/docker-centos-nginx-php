function restart-nginx {
    kill $(ps -eo pid,comm | grep nginx | awk 'NR == 1 {print $1}');
}

function restart-php-fpm {
    kill $(ps -eo pid,comm | grep php-fpm | awk 'NR == 1 {print $1}');
}
