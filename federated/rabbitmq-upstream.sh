#!/bin/bash
rabbitmqadmin declare exchange name=test.exchange type=direct durable=true auto_delete=false
rabbitmqadmin declare queue name=test.queue1 durable=true auto_delete=false
rabbitmqadmin declare binding source=test.exchange destination=test.queue1 destination_type=queue routing_key=test.route1

