#!/bin/sh

set -e

pushd /
    echo "Stopping postgresql"
    sudo systemctl stop postgresql

    echo "Removing postgresql data"
    sudo rm -rf /var/lib/postgres/data
    sudo mkdir /var/lib/postgres/data
    sudo chown postgres:postgres /var/lib/postgres/data

    echo "Initializing postgresql database"
    sudo -u postgres initdb --locale=C.UTF-8 --encoding=UTF8 -D /var/lib/postgres/data --data-checksums

    echo "Starting postgresql"
    sudo systemctl start postgresql

    echo "Creating postgresql user"
    sudo -u postgres createuser -s $USER
popd
