#!/bin/sh
# wait-for-it.sh

set -e

host="$1"
shift
cmd="python3 manage.py migrate"
USER=root
PASSWARD=455050954

until mysql -h "$host" -u $USER -p $PASSWARD-e "show databases;" >/dev/null;do
    >&2 echo "Mysql is unavailable - sleeping"
    sleep 1
done
>&2 echo "Mysql is up - executing command"
exec $cmd
