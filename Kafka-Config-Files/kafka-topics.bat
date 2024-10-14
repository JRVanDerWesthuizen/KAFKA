@echo off

:: Kafka container ID
set KAFKA_CONTAINER_ID=716e220a5058

:: Create Kafka topics with 3 partitions each
docker exec -it %KAFKA_CONTAINER_ID% kafka-topics.bat --create --topic logistics --bootstrap-server localhost:9092 --replication-factor 1 --partitions 3
docker exec -it %KAFKA_CONTAINER_ID% kafka-topics.bat --create --topic standard_delivery --bootstrap-server localhost:9092 --replication-factor 1 --partitions 3
docker exec -it %KAFKA_CONTAINER_ID% kafka-topics.bat --create --topic express_delivery --bootstrap-server localhost:9092 --replication-factor 1 --partitions 3
docker exec -it %KAFKA_CONTAINER_ID% kafka-topics.bat --create --topic international_delivery --bootstrap-server localhost:9092 --replication-factor 1 --partitions 3

:: List created topics
docker exec -it %KAFKA_CONTAINER_ID% kafka-topics.bat --list --bootstrap-server localhost:9092
