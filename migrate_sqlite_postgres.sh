#!/bin/bash
# Migrate SQLite DB to Postgres
# You need to install pgloader 'sudo apt install pgloader'
# Also make sure postgres is installed 'sudo apt install postgres'

read -p 'Enter postgres username (leave blank use default user "postgres"): ' postgres_username
read -p 'Enter postgres database name: ' db_name

[[ -z $db_name ]] && { echo "DB name must not be empty" ; exit 1; }

: ${postgres_username:="postgres"}


echo "
load database
    from data/database.sqlite3
    into postgresql:///${db_name}
with data only

set work_mem to '16MB', maintenance_work_mem to '512 MB';
" > database.load
sudo -u $postgres_username pgloader database.load


files=data/ext_*.sqlite3


for f in $files
do
    filename=${f:9}

    echo "
    load database
        from $f
        into postgresql:///${db_name}
    with data only
    set search_path to '${filename%%.*}',work_mem to '16MB', maintenance_work_mem to '512 MB';
    " > extensions.load
    sudo -u $postgres_username pgloader extensions.load
done
