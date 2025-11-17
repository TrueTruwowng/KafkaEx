@echo off
echo ========================================
echo STOP KAFKA LEADER TEST
echo ========================================
echo.

echo Step 1: Checking current leader...
docker exec kafka-broker-1 kafka-topics --bootstrap-server localhost:9092 --describe --topic orders-topic

echo.
echo.
echo Which broker do you want to stop?
echo 1. Broker 1 (Port 9092)
echo 2. Broker 2 (Port 9093)
echo 3. Broker 3 (Port 9094)
echo.
set /p choice="Enter choice (1-3): "

if "%choice%"=="1" (
    echo.
    echo Stopping Kafka Broker 1...
    docker stop kafka-broker-1
    set stopped_broker=kafka-broker-1
)
if "%choice%"=="2" (
    echo.
    echo Stopping Kafka Broker 2...
    docker stop kafka-broker-2
    set stopped_broker=kafka-broker-2
)
if "%choice%"=="3" (
    echo.
    echo Stopping Kafka Broker 3...
    docker stop kafka-broker-3
    set stopped_broker=kafka-broker-3
)

echo.
echo ✅ Broker stopped: %stopped_broker%
echo.
echo Waiting 10 seconds for cluster to rebalance...
timeout /t 10 /nobreak

echo.
echo.
echo ========================================
echo 🔍 CHECKING NEW CLUSTER STATE
echo ========================================
echo.

echo === Running Brokers ===
docker ps --filter "name=kafka-broker"

echo.
echo.
echo === Topic Status (from remaining broker) ===
if "%choice%"=="1" (
    docker exec kafka-broker-2 kafka-topics --bootstrap-server localhost:9093 --describe --topic orders-topic
)
if "%choice%"=="2" (
    docker exec kafka-broker-1 kafka-topics --bootstrap-server localhost:9092 --describe --topic orders-topic
)
if "%choice%"=="3" (
    docker exec kafka-broker-1 kafka-topics --bootstrap-server localhost:9092 --describe --topic orders-topic
)

echo.
echo.
echo ========================================
echo 📝 TEST THE SYSTEM NOW!
echo ========================================
echo.
echo Send a test order to check if system still works:
echo.
echo curl -X POST http://localhost:8081/api/orders/create ^
echo   -H "Content-Type: application/json" ^
echo   -d "{\"customerName\":\"John Doe\",\"productName\":\"Laptop\",\"quantity\":1,\"totalPrice\":1500}"
echo.
echo.
echo To restart the stopped broker:
echo   docker start %stopped_broker%
echo.
pause

