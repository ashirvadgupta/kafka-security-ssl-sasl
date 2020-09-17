#!/usr/bin/env bash

docker run -it --rm --network kafka-cluster-network confluentinc/cp-kafka:5.5.1 kafka-topics --zookeeper zookeeper-1:22181 --create --topic test --partitions 10 --replication-factor 3

cd ssl-only
#Console producer with SSL files mapped in the container
export KAFKA_SSL_SECRETS_DIR=$PWD/../secrets && docker run -it --rm -v ${KAFKA_SSL_SECRETS_DIR}/producer:/etc/kafka/secrets -v ${KAFKA_SSL_SECRETS_DIR}/host.producer.ssl.config:/etc/kafka/secrets/host.producer.ssl.config --network kafka-cluster-network confluentinc/cp-kafka:5.5.1  kafka-console-producer --broker-list kafka-broker-1:19093,kafka-broker-2:29093,kafka-broker-3:39093 --topic test --producer.config /etc/kafka/secrets/host.producer.ssl.config


#Console consumer with SSL files mapped in the container
export KAFKA_SSL_SECRETS_DIR=$PWD/../secrets && docker run -it --rm -v ${KAFKA_SSL_SECRETS_DIR}/consumer:/etc/kafka/secrets -v ${KAFKA_SSL_SECRETS_DIR}/host.consumer.ssl.config:/etc/kafka/secrets/host.consumer.ssl.config --network kafka-cluster-network confluentinc/cp-kafka:5.5.1 kafka-console-consumer --bootstrap-server kafka-broker-1:19093,kafka-broker-2:29093,kafka-broker-3:39093 --topic test --from-beginning --consumer.config /etc/kafka/secrets/host.consumer.ssl.config


#Kafka Console
docker run -itd --name kafka-console --network kafka-cluster-network confluentinc/cp-kafka:5.5.1 /bin/bash

docker exec -it kafka-console /bin/bash


#List Topics
kafka-topics --zookeeper zookeeper-1:22181 --list

#Describe Topic Test
kafka-topics --zookeeper zookeeper-1:22181 --describe --topic test