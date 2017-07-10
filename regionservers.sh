#!/usr/bin/env bash

bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin" >/dev/null && pwd`

if [ $# -lt 2 ]; then
  S=`basename "${BASH_SOURCE-$0}"`
  echo "Usage: $S [--config <conf-dir>] [start|stop] offset(s)"
  echo ""
  echo "    e.g. $S start 1 2"
  exit
fi

. "$bin"/hbase-config.sh

# sanity check: make sure your regionserver opts don't use ports [i.e. JMX/DBG]
export HBASE_REGIONSERVER_OPTS="$HBASE_REGIONSERVER_OPTS -XX:MaxRAMFraction=3 -XX:+UseParNewGC -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70"

run_regionserver () {
  DN=$2
  export HBASE_REGIONSERVER_OPTS="$HBASE_REGIONSERVER_OPTS \
   -Dcom.sun.management.jmxremote.local.only=true \
   -Dcom.sun.management.jmxremote \
   -Dcom.sun.management.jmxremote.authenticate=false \
   -Dcom.sun.management.jmxremote.ssl=false \
   -Dcom.sun.management.jmxremote.port=`expr 20010 + $DN`"
  export HBASE_IDENT_STRING="$USER-$DN"
  HBASE_REGIONSERVER_ARGS="\
    -D hbase.regionserver.port=`expr 16200 + $DN` \
    -D hbase.regionserver.info.port=`expr 16300 + $DN`"
  "$bin"/hbase-daemon.sh  --config "${HBASE_CONF_DIR}" $1 regionserver $HBASE_REGIONSERVER_ARGS
}

cmd=$1
shift;

for i in $*
do
  if [[ "$i" =~ ^[0-9]+$ ]]; then
   run_regionserver $cmd $i
  else
   echo "Invalid argument"
  fi
done
