@echo off
echo ========================================
echo KAFKA CLUSTER - LEADER CHECK
echo ========================================
echo.

echo Checking topic metadata and leader information...
echo.

echo === TOPIC: orders-topic ===
docker exec kafka-broker-1 kafka-topics --bootstrap-server localhost:9092 --describe --topic orders-topic

echo.
echo.
echo === CLUSTER METADATA ===
docker exec kafka-broker-1 kafka-broker-api-versions --bootstrap-server localhost:9092

echo.
echo.
echo === CONTROLLER INFO ===
echo Checking which broker is the controller...
docker exec zookeeper zkCli.sh get /controller

echo.
echo ========================================
echo TIP: Check Kafka UI for visual representation
echo URL: http://localhost:8090
echo ========================================
echo.
pause

