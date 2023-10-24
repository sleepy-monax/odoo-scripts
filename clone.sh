#!/bin/sh

set -e

ODOO_REPO=$1
if [ -z "$ODOO_REPO" ]; then
    echo "Usage: $0 <repo>"
    exit 1
fi

ODOO_OUTPUT="$ODOO_REPO"
if [ "$ODOO_REPO" = "community" ]; then
    ODOO_REPO=odoo
fi

mkdir -p $ODOO_OUTPUT
cd $ODOO_OUTPUT
git init
git remote add odoo git@github.com:odoo/$ODOO_REPO.git
git remote add odoo-dev git@github.com:odoo-dev/$ODOO_REPO.git
git remote set-url --push odoo no_push
git fetch odoo master
git switch master
