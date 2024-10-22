#!/bin/bash

apt -y update
apt -y install rabbitmq-server
rabbitmq-plugins enable rabbitmq_management
rabbitmq-plugins enable rabbitmq_shovel
rabbitmq-plugins enable rabbitmq_shovel_management
curl -o /etc/rabbitmq/rabbitmq.conf https://raw.githubusercontent.com/rabbitmq/rabbitmq-server/master/deps/rabbit/docs/rabbitmq.conf.example
echo "listeners.tcp.local = 0.0.0.0:5672" >> /etc/rabbitmq/rabbitmq.conf
systemctl restart rabbitmq-server

rabbitmqctl add_user ${admin_user} ${admin_pass}
rabbitmqctl set_user_tags ${admin_user} administrator

rabbitmqctl add_user ${user} ${pass}
rabbitmqctl set_permissions -p / ${user} ".*" ".*" ".*"

# /var/log/cloud-init-output.log
# rabbitmqctl clear_permissions -p / admin
# rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"