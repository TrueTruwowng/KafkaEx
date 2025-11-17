@echo off
echo ========================================
echo Kafka Quick Start Menu
echo ========================================
echo.
echo Choose how to start Kafka:
echo.
echo 1. Start Kafka using Docker (Recommended)
echo 2. Instructions for manual Kafka installation
echo 3. Exit
echo.
echo ========================================

set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" goto docker_start
if "%choice%"=="2" goto manual_instructions
if "%choice%"=="3" goto end

:docker_start
echo.
echo Checking Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not installed or not in PATH
    echo.
    echo Please install Docker Desktop from:
    echo https://www.docker.com/products/docker-desktop/
    echo.
    pause
    goto end
)

echo Docker is installed!
echo.
echo Starting Kafka and Zookeeper with Docker...
echo.
docker-compose up -d

if errorlevel 1 (
    echo.
    echo ERROR: Failed to start Kafka with Docker
    echo.
    echo Try running: docker-compose down
    echo Then: docker-compose up -d
    echo.
) else (
    echo.
    echo ========================================
    echo SUCCESS! Kafka is now running!
    echo ========================================
    echo.
    echo Kafka broker: localhost:9092
    echo Zookeeper: localhost:2181
    echo.
    echo To check status: docker ps
    echo To view logs: docker-compose logs -f
    echo To stop: docker-compose down
    echo.
    echo You can now run your Spring Boot application!
    echo.
)
pause
goto end

:manual_instructions
echo.
echo ========================================
echo Manual Kafka Installation Steps
echo ========================================
echo.
echo 1. Download Kafka from:
echo    https://kafka.apache.org/downloads
echo.
echo 2. Extract to C:\kafka (or your preferred location)
echo.
echo 3. Open TWO Command Prompt windows:
echo.
echo    Terminal 1 - Start Zookeeper:
echo    ---------------------------------
echo    cd C:\kafka
echo    .\bin\windows\zookeeper-server-start.bat .\config\zookeeper.properties
echo.
echo    Terminal 2 - Start Kafka:
echo    ---------------------------------
echo    cd C:\kafka
echo    .\bin\windows\kafka-server-start.bat .\config\server.properties
echo.
echo 4. Keep both terminals running!
echo.
echo 5. Now you can run your Spring Boot application
echo.
echo ========================================
pause
goto end

:end
echo.
echo Goodbye!

