@echo off
echo ========================================
echo CONSUMER SERVICE - START
echo ========================================
echo.

cd /d E:\StudyDoc\NAM3\PTUDDN\KafkaExample\consumer-service

echo Building and running Consumer Service...
echo Port: 8082
echo.

mvn clean install -DskipTests && mvn spring-boot:run

pause

