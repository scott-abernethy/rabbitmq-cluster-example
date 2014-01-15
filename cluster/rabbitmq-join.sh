#!/bin/bash

JOIN=$1

# Join the cluster
rabbitmqctl stop_app
rabbitmqctl join_cluster rabbit@$JOIN
rabbitmqctl start_app
rabbitmqctl cluster_status

# Test configuration
rabbitmqadmin declare exchange name=test.exchange type=direct durable=true auto_delete=false
rabbitmqadmin declare queue name=test.queue durable=true auto_delete=false
rabbitmqadmin declare binding source=test.exchange destination=test.queue destination_type=queue routing_key=test.route

# Cluster mode
rabbitmqctl set_policy test.queue "^test\." '{"ha-mode":"exactly","ha-params":2}'

# done
