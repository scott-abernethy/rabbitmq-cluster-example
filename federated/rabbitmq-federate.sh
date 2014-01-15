#!/bin/bash

REMOTE=$1

rabbitmqctl set_parameter federation-upstream my-upstream \
	"{\"uri\":\"amqp://$REMOTE\",\"expires\":3600000}"

rabbitmqctl set_policy federate-me '^test\.' \
	'{"federation-upstream-set":"all"}'

rabbitmqadmin declare exchange name=test.exchange type=direct durable=true auto_delete=false
rabbitmqadmin declare queue name=test.queue2 durable=true auto_delete=false
rabbitmqadmin declare binding source=test.exchange destination=test.queue2 destination_type=queue routing_key=test.route2

