#!/bin/bash

echo Provision script for rabbitmq

TMP=/vagrant/tmp

if [ ! -d "$TMP" ] ; then
	mkdir -p $TMP
fi

cd $TMP

cat >> /etc/hosts <<EOF
192.168.64.10	rabbitmq1
192.168.64.20	rabbitmq2
EOF

# Install erlang
ERLANG_DEB=erlang-solutions_1.0_all.deb
if [ ! -f "$ERLANG_DEB" ] ; then
	wget http://packages.erlang-solutions.com/$ERLANG_DEB
fi
dpkg -i $ERLANG_DEB
apt-get update
apt-get install -y esl-erlang

# Install rabbitmq
RABBITMQ_DEB=rabbitmq-server_3.1.5-1_all.deb
if [ ! -f "$RABBITMQ_DEB" ] ; then
	wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.1.5/$RABBITMQ_DEB
fi
dpkg -i $RABBITMQ_DEB

# Enable rabbitmq plugins
rabbitmq-plugins enable rabbitmq_management
rabbitmq-plugins enable rabbitmq_federation
rabbitmq-plugins enable rabbitmq_federation_management
service rabbitmq-server restart

# Install rabbitmqadmin tool
cd /tmp
wget http://localhost:15672/cli/rabbitmqadmin
chmod a+x rabbitmqadmin
mv rabbitmqadmin /usr/local/bin
 
# Create erlang cookie, that must be identical on each server.
ERLANG_COOKIE=/var/lib/rabbitmq/.erlang.cookie
service rabbitmq-server stop
echo -n "45hj24jk2349234jklk234" > $ERLANG_COOKIE
chmod 600 $ERLANG_COOKIE
chown rabbitmq: $ERLANG_COOKIE
rm -rf /var/lib/rabbitmq/mnesia
service rabbitmq-server start

rabbitmqctl cluster_status

# done
