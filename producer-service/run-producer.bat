@echo off
echo ========================================
echo PRODUCER SERVICE - START
echo ========================================
echo.

cd /d E:\StudyDoc\NAM3\PTUDDN\KafkaExample\producer-service

echo Building and running Producer Service...
echo Port: 8081
echo.

mvn clean install -DskipTests && mvn spring-boot:run

pause

