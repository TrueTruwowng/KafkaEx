@echo off
echo ========================================
echo KAFKA CLUSTER - STARTUP SCRIPT
echo ========================================
echo.

echo Step 1: Starting Kafka Cluster (3 Brokers + Zookeeper + UI)
echo This will take about 60 seconds...
echo.

docker-compose -f docker-compose-cluster.yml up -d

if errorlevel 1 (
    echo.
    echo ERROR: Failed to start Kafka cluster
    pause
    exit /b 1
)

echo.
echo Waiting for cluster to initialize (60 seconds)...
timeout /t 60 /nobreak

echo.
echo ========================================
echo ✅ KAFKA CLUSTER STARTED SUCCESSFULLY!
echo ========================================
echo.
echo 📊 Cluster Information:
echo   - Zookeeper:  localhost:2181
echo   - Broker 1:   localhost:9092
echo   - Broker 2:   localhost:9093
echo   - Broker 3:   localhost:9094
echo   - Kafka UI:   http://localhost:8090
echo.
echo 🔍 Checking cluster status...
docker ps --filter "name=kafka"

echo.
echo ========================================
echo 📝 NEXT STEPS:
echo ========================================
echo.
echo 1. Check Kafka UI: http://localhost:8090
echo 2. Run: check-cluster.bat (to see leader info)
echo 3. Start Producer: run-producer.bat
echo 4. Start Consumer: run-consumer.bat
echo.
pause

