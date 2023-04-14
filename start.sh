#!/bin/sh

ODOO_ROOT=community
ODOO_DB=odoo
ODOO_ADDONS=addons
ODOO_EXTRA=""

function clearDatabase() {
    echo "Are you sure to clear the database '$ODOO_DB'? [Y/n]"
    read answer
    if [ "$answer" == "" ] ;then
        answer="Y"
    fi
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        pushd /
            echo "Clearing database..."
            sudo -u postgres dropdb $ODOO_DB || true # The database may not exist
            sudo -u postgres createdb $ODOO_DB
        popd
    fi
}

function usage() {
    echo "Usage: start.sh [options]"
    echo "Options:"
    echo "  -c, --clean             Clear the database before starting Odoo"
    echo "  -r, --root              Path to the Odoo root directory"
    echo "  -e, --enterprise        Use the enterprise addons"
    echo "  -d, --database          Name of the database to use"
    echo "  -a, --addons            Path to the addons directory"
    echo "  -h, --help              Show this help"
}

while [ "$1" != "" ]; do
    case $1 in
        -c | --clean )          shift
                                clearDatabase
                                ;;
        -r | --root )           shift
                                ODOO_ROOT=$1
                                ;;
        -e | --enterprise )     shift
                                ODOO_ADDONS="$ODOO_ADDONS,../enterprise"
                                ;;
        -d | --database )       shift
                                ODOO_DB=$1
                                ;;
        -a | --addons )         shift
                                ODOO_ADDONS="$ODOO_ADDONS,$1"
                                ;;
        -h | --help )           shift
                                usage
                                exit
                                ;;
        --dev )                 shift
                                ODOO_EXTRA="$ODOO_EXTRA --dev=$1"
                                ;;
    esac
done

echo ""
echo "Starting Odoo (ODOO_ROOT=$ODOO_ROOT, ODOO_DB=$ODOO_DB, ODOO_ADDONS=$ODOO_ADDONS)"
echo "Press Ctrl+C to stop"
echo ""
pushd $ODOO_ROOT
./odoo-bin --addons-path="$ODOO_ADDONS" -d $ODOO_DB -i base,website $ODOO_EXTRA
popd
