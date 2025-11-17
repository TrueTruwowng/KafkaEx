@echo off
echo ========================================
echo STARTING KAFKA - PLEASE WAIT
echo ========================================
echo.

echo Step 1: Checking Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not installed!
    echo.
    echo Please install Docker Desktop from:
    echo https://www.docker.com/products/docker-desktop/
    echo.
    echo After installing Docker, run this file again.
    pause
    exit /b 1
)

echo ✓ Docker is installed
echo.

echo Step 2: Starting Kafka and Zookeeper...
echo This will take about 30 seconds...
echo.

docker-compose up -d

if errorlevel 1 (
    echo.
    echo ERROR: Failed to start Kafka
    echo.
    echo Try these commands manually:
    echo   docker-compose down
    echo   docker-compose up -d
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS! Kafka is starting...
echo ========================================
echo.
echo Waiting 30 seconds for Kafka to be ready...
timeout /t 30 /nobreak

echo.
echo ✓ Kafka should now be ready!
echo.
echo Checking Kafka containers...
docker ps

echo.
echo ========================================
echo NEXT STEPS:
echo ========================================
echo.
echo Now you can run your Spring Boot application:
echo.
echo   mvn spring-boot:run -DskipTests
echo.
echo Or simply run: run-spring-boot.bat
echo.
echo ========================================
pause

