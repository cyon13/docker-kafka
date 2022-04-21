#!/bin/bash


SERVER_HOST_NAME=$HOSTNAME
KAFKA_HOME=$KAFKA_HOME
BROKER_ID=${BROKER_ID}
# ssh 실행
service ssh start

# 노드 목록
nodes="kafka1 kafka2 kafka3 zk1 zk2 zk3"
kafkanodes="kafka1 kafka2 kafka3"

# hosts 파일 복사
if [ $SERVER_HOST_NAME == kafka1 ];
then
	for node in $nodes
	do	
		IPADDR=$(ssh -o  StrictHostKeyChecking=no $node "ifconfig  | grep broadcast| awk '{print \$ 2}'")
		NAME=$(ssh -o  StrictHostKeyChecking=no $node "echo \$HOSTNAME")
		HOST="$IPADDR		$NAME"
		if [[ -z `grep "$node" /etc/hosts` ]]
		then
			echo $HOST >> /etc/hosts
			echo $HOST
		fi
	done

	for node in $kafkanodes
	do	
		scp /etc/hosts $node:/etc/hosts
		scp ~/.ssh/known_hosts $node:~/.ssh/known_hosts
	done
fi


# kafka 실행
if [ $SERVER_HOST_NAME == kafka1 ] || [ $SERVER_HOST_NAME == kafka2 ] || [ $SERVER_HOST_NAME == kafka3 ];
then
    if [[ -z `grep "broker.id" $KAFKA_HOME/config/server.properties`  ]]
    then
	    echo "broker.id=${BROKER_ID}" >> $KAFKA_HOME/config/server.properties
	    echo "advertised.listeners=PLAINTEXT://${SERVER_HOST_NAME}:9092" >> $KAFKA_HOME/config/server.properties
    fi
    echo `$KAFKA_HOME/bin/kafka-server-start.sh -daemon $KAFKA_HOME/config/server.properties`
fi


tail -f /dev/null
                  
