@echo off
REM Kafka Management Scripts for Windows

echo ========================================
echo Kafka Management Menu
echo ========================================
echo 1. Start Application (Spring Boot)
echo 2. Test Publish Message
echo 3. Test Publish Message with Key
echo 4. Check Health
echo 5. Exit
echo ========================================

set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" goto start_app
if "%choice%"=="2" goto test_publish
if "%choice%"=="3" goto test_publish_key
if "%choice%"=="4" goto health_check
if "%choice%"=="5" goto end

:start_app
echo Starting Spring Boot Application...
mvn spring-boot:run
goto end

:test_publish
echo.
echo Publishing test message to Kafka...
curl -X POST http://localhost:8080/api/kafka/publish -H "Content-Type: application/json" -d "{\"message\":\"Hello from Kafka Example!\"}"
echo.
echo.
pause
goto end

:test_publish_key
echo.
echo Publishing test message with key to Kafka...
curl -X POST http://localhost:8080/api/kafka/publish-with-key -H "Content-Type: application/json" -d "{\"key\":\"test-key-123\",\"message\":\"Hello with key from Kafka Example!\"}"
echo.
echo.
pause
goto end

:health_check
echo.
echo Checking application health...
curl http://localhost:8080/api/kafka/health
echo.
echo.
pause
goto end

:end
echo Goodbye!

