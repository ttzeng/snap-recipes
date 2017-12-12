#!/bin/sh

initialize_SVR_dB() {
    PROGRAM=$1
    SVR_DB_JSON=$2
    [ ! -f "$SVR_DB_JSON" ] && SVR_DB_JSON=$(dirname $PROGRAM)/oic_svr_db.json
    [ ! -f "$SVR_DB_JSON" ] && SVR_DB_JSON=$SNAP/usr/local/src/template/iotivity/oic_svr_db.json
    PERSISTENCE_DIR=$(echo $HOME/.iotivity-node/`echo -n $PROGRAM | sha256sum` | cut -d' ' -f 1)
    SVR_DB=$PERSISTENCE_DIR/oic_svr_db.dat
    echo Create persistence state for $PROGRAM at
    echo $PERSISTENCE_DIR'\n'
    rm -rf $PERSISTENCE_DIR
    mkdir -p $PERSISTENCE_DIR
    cp -f $SVR_DB_JSON $PERSISTENCE_DIR
    LD_LIBRARY_PATH=$SNAP/lib/node_modules/iotivity-node/iotivity-installed/lib \
    $SNAP/bin/json2cbor $SVR_DB_JSON $SVR_DB
    ln -s $PROGRAM $PERSISTENCE_DIR
    echo '\nSVR DB of '$PROGRAM' generated.\n'
}

if [ "$#" -gt 2 ] || ! [ -f "$1" ]; then
    echo "Usage: $0 <script-file> [<SVR-dB-JSON>]" >&2
    exit 1
fi

initialize_SVR_dB $(realpath $1) $2
