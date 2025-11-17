tuS@echo off
echo ========================================
echo SETUP PRODUCER SERVICE - AUTO
echo ========================================
echo.

cd /d E:\StudyDoc\NAM3\PTUDDN\KafkaExample\producer-service

echo Step 1: Cleaning up old structure...
if exist src\main\java\com\example\producer\*.java del /Q src\main\java\com\example\producer\*.java
if exist src\main\java\com\example\producer\config\*.java del /Q src\main\java\com\example\producer\config\*.java
if exist src\main\java\com\example\producer\controller\*.java del /Q src\main\java\com\example\producer\controller\*.java
if exist src\main\java\com\example\producer\model\*.java del /Q src\main\java\com\example\producer\model\*.java
if exist src\main\java\com\example\producer\service\*.java del /Q src\main\java\com\example\producer\service\*.java

echo Step 2: Creating directory structure...
if not exist src\main\java\com\example\producer\config mkdir src\main\java\com\example\producer\config
if not exist src\main\java\com\example\producer\controller mkdir src\main\java\com\example\producer\controller
if not exist src\main\java\com\example\producer\model mkdir src\main\java\com\example\producer\model
if not exist src\main\java\com\example\producer\service mkdir src\main\java\com\example\producer\service
if not exist src\main\resources mkdir src\main\resources

echo Step 3: Copying Java files to correct locations...

REM Check if ProducerServiceApplication.java exists in root
if exist ProducerServiceApplication.java (
    copy /Y ProducerServiceApplication.java src\main\java\com\example\producer\
    echo ✓ Copied ProducerServiceApplication.java
)

REM Copy config files
if exist config\KafkaProducerConfig.java (
    copy /Y config\KafkaProducerConfig.java src\main\java\com\example\producer\config\
    echo ✓ Copied KafkaProducerConfig.java
)
if exist config\KafkaTopicConfig.java (
    copy /Y config\KafkaTopicConfig.java src\main\java\com\example\producer\config\
    echo ✓ Copied KafkaTopicConfig.java
)

REM Copy controller
if exist controller\OrderController.java (
    copy /Y controller\OrderController.java src\main\java\com\example\producer\controller\
    echo ✓ Copied OrderController.java
)

REM Copy model
if exist model\Order.java (
    copy /Y model\Order.java src\main\java\com\example\producer\model\
    echo ✓ Copied Order.java
)

REM Copy service
if exist service\OrderProducerService.java (
    copy /Y service\OrderProducerService.java src\main\java\com\example\producer\service\
    echo ✓ Copied OrderProducerService.java
)

REM Copy application.properties
if exist application.properties (
    copy /Y application.properties src\main\resources\
    echo ✓ Copied application.properties
)

echo.
echo Step 4: Verifying structure...
dir /b src\main\java\com\example\producer\*.java
dir /b src\main\java\com\example\producer\config\*.java
dir /b src\main\java\com\example\producer\controller\*.java
dir /b src\main\java\com\example\producer\model\*.java
dir /b src\main\java\com\example\producer\service\*.java

echo.
echo ========================================
echo ✅ SETUP COMPLETE!
echo ========================================
echo.
echo Now you can run:
echo   mvn clean install -DskipTests
echo   mvn spring-boot:run
echo.
pause

