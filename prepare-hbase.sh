#!/bin/sh -x

. /build/config-hbase.sh

apt-get update -y

apt-get install $minimal_apt_get_args $HBASE_BUILD_PACKAGES

cd /opt

curl -SL $HBASE_DIST/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz | tar -x -z && mv hbase-${HBASE_VERSION} hbase
curl -s http://www-us.apache.org/dist/phoenix/apache-phoenix-4.9.0-HBase-1.2/bin/apache-phoenix-4.9.0-HBase-1.2-bin.tar.gz | tar -xz -C /tmp/
cp /tmp/apache-phoenix-4.9.0-HBase-1.2-bin/phoenix-4.9.0-HBase-1.2-hive.jar /opt/hbase/lib/ && cp /tmp/apache-phoenix-4.9.0-HBase-1.2-bin/phoenix-core-4.9.0-HBase-1.2.jar /opt/hbase/lib/
