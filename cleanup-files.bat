
@echo off
echo ╔════════════════════════════════════════════════════════╗
echo ║   DỌN DẸP FILES Ở NGOÀI SOURCE ROOT                   ║
echo ╚════════════════════════════════════════════════════════╝
echo.

echo ⚠️  Có một số files Java đang nằm ngoài src/main/java/
echo ✅  Script này sẽ xóa các files/folders cũ đó
echo.

pause

cd /d E:\StudyDoc\NAM3\PTUDDN\KafkaExample

echo.
echo ========================================
echo CLEANING PRODUCER SERVICE
echo ========================================

cd producer-service

echo Xóa folders cũ ngoài src/...
if exist config rmdir /s /q config
if exist controller rmdir /s /q controller
if exist model rmdir /s /q model
if exist service rmdir /s /q service
if exist application.properties del /q application.properties
if exist ProducerServiceApplication.java del /q ProducerServiceApplication.java
if exist producer-service\src rmdir /s /q producer-service

echo ✅ Producer service đã clean!

cd ..

echo.
echo ========================================
echo CLEANING CONSUMER SERVICE
echo ========================================

cd consumer-service

echo Xóa folders cũ ngoài src/...
if exist config rmdir /s /q config
if exist model rmdir /s /q model
if exist service rmdir /s /q service
if exist application.properties del /q application.properties
if exist ConsumerServiceApplication.java del /q ConsumerServiceApplication.java

echo ✅ Consumer service đã clean!

cd ..

echo.
echo ========================================
echo CLEANING ROOT FOLDER
echo ========================================

if exist src\main\java\KafkaTopicConfig.java del /q src\main\java\KafkaTopicConfig.java
if exist src\main\java\ProducerServiceApplication.java del /q src\main\java\ProducerServiceApplication.java

echo ✅ Root folder đã clean!

echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║   ✅ HOÀN TẤT DỌN DẸP!                                 ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo Bây giờ cấu trúc đã ĐÚNG:
echo.
echo producer-service/
echo   └── src/main/java/com/example/producer/
echo       ├── ProducerServiceApplication.java ✅
echo       ├── config/ ✅
echo       ├── controller/ ✅
echo       ├── model/ ✅
echo       └── service/ ✅
echo.
echo consumer-service/
echo   └── src/main/java/com/example/consumer/
echo       ├── ConsumerServiceApplication.java ✅
echo       ├── config/ ✅
echo       ├── controller/ ✅
echo       ├── model/ ✅
echo       └── service/ ✅
echo.
echo Không còn cảnh báo "outside of source root" nữa!
echo.
pause

