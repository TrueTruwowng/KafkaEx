@echo off
echo ╔════════════════════════════════════════════════════════╗
echo ║   KAFKA CLUSTER - TEST SUITE                          ║
echo ╚════════════════════════════════════════════════════════╝
echo.

:menu
echo ========================================
echo CHỌN TEST SCENARIO:
echo ========================================
echo.
echo 1. Test gửi 1 order
echo 2. Test gửi 5 orders liên tục
echo 3. Test health check
echo 4. Xem cluster status
echo 5. Xem topic details
echo 6. Dừng Broker 1 và test
echo 7. Dừng Broker 2 và test
echo 8. Dừng Broker 3 và test
echo 9. Khởi động lại tất cả brokers
echo 0. Thoát
echo.
echo ========================================

set /p choice="Nhập lựa chọn (0-9): "

if "%choice%"=="1" goto test_single
if "%choice%"=="2" goto test_multiple
if "%choice%"=="3" goto test_health
if "%choice%"=="4" goto cluster_status
if "%choice%"=="5" goto topic_details
if "%choice%"=="6" goto stop_broker1
if "%choice%"=="7" goto stop_broker2
if "%choice%"=="8" goto stop_broker3
if "%choice%"=="9" goto start_all
if "%choice%"=="0" goto end

echo Lựa chọn không hợp lệ!
pause
goto menu

:test_single
echo.
echo ========================================
echo TEST: Gửi 1 Order
echo ========================================
echo.
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Nguyen Van A\",\"productName\":\"Laptop Dell\",\"quantity\":2,\"totalPrice\":30000000}"
echo.
echo.
echo ✅ Order đã được gửi!
echo Kiểm tra logs của Producer và Consumer.
echo.
pause
goto menu

:test_multiple
echo.
echo ========================================
echo TEST: Gửi 5 Orders Liên Tục
echo ========================================
echo.
for /L %%i in (1,1,5) do (
    echo Gửi order %%i...
    curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Customer %%i\",\"productName\":\"Product %%i\",\"quantity\":%%i,\"totalPrice\":%%i000}"
    echo.
    timeout /t 2 /nobreak >nul
)
echo.
echo ✅ Đã gửi 5 orders!
echo Kiểm tra Consumer logs.
echo.
pause
goto menu

:test_health
echo.
echo ========================================
echo TEST: Health Check
echo ========================================
echo.
echo Producer Health:
curl http://localhost:8081/api/orders/health
echo.
echo.
echo Consumer Health:
curl http://localhost:8082/actuator/health 2>nul || echo Consumer không có health endpoint
echo.
echo.
pause
goto menu

:cluster_status
echo.
echo ========================================
echo CLUSTER STATUS
echo ========================================
echo.
echo Running Kafka Brokers:
docker ps --filter "name=kafka-broker"
echo.
echo.
pause
goto menu

:topic_details
echo.
echo ========================================
echo TOPIC DETAILS: orders-topic
echo ========================================
echo.
docker exec kafka-broker-1 kafka-topics --bootstrap-server localhost:9092 --describe --topic orders-topic 2>nul || docker exec kafka-broker-2 kafka-topics --bootstrap-server localhost:9093 --describe --topic orders-topic
echo.
echo.
pause
goto menu

:stop_broker1
echo.
echo ========================================
echo TEST FAULT TOLERANCE: Dừng Broker 1
echo ========================================
echo.
echo Dừng Broker 1...
docker stop kafka-broker-1
echo.
echo Broker 1 đã dừng!
echo.
echo Chờ 10 giây để cluster rebalance...
timeout /t 10 /nobreak
echo.
echo Gửi test order...
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Test After Broker1 Down\",\"productName\":\"Test Product\",\"quantity\":1,\"totalPrice\":1000}"
echo.
echo.
echo ✅ Kiểm tra xem order có được nhận không!
echo.
echo Để khởi động lại Broker 1:
echo   docker start kafka-broker-1
echo.
pause
goto menu

:stop_broker2
echo.
echo ========================================
echo TEST FAULT TOLERANCE: Dừng Broker 2
echo ========================================
echo.
echo Dừng Broker 2...
docker stop kafka-broker-2
echo.
echo Broker 2 đã dừng!
echo.
echo Chờ 10 giây để cluster rebalance...
timeout /t 10 /nobreak
echo.
echo Gửi test order...
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Test After Broker2 Down\",\"productName\":\"Test Product\",\"quantity\":1,\"totalPrice\":1000}"
echo.
echo.
echo ✅ Kiểm tra xem order có được nhận không!
echo.
echo Để khởi động lại Broker 2:
echo   docker start kafka-broker-2
echo.
pause
goto menu

:stop_broker3
echo.
echo ========================================
echo TEST FAULT TOLERANCE: Dừng Broker 3
echo ========================================
echo.
echo Dừng Broker 3...
docker stop kafka-broker-3
echo.
echo Broker 3 đã dừng!
echo.
echo Chờ 10 giây để cluster rebalance...
timeout /t 10 /nobreak
echo.
echo Gửi test order...
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Test After Broker3 Down\",\"productName\":\"Test Product\",\"quantity\":1,\"totalPrice\":1000}"
echo.
echo.
echo ✅ Kiểm tra xem order có được nhận không!
echo.
echo Để khởi động lại Broker 3:
echo   docker start kafka-broker-3
echo.
pause
goto menu

:start_all
echo.
echo ========================================
echo KHỞI ĐỘNG LẠI TẤT CẢ BROKERS
echo ========================================
echo.
echo Starting Broker 1...
docker start kafka-broker-1
echo Starting Broker 2...
docker start kafka-broker-2
echo Starting Broker 3...
docker start kafka-broker-3
echo.
echo Chờ 20 giây để brokers rejoin cluster...
timeout /t 20 /nobreak
echo.
echo ✅ Tất cả brokers đã được khởi động!
echo.
docker ps --filter "name=kafka-broker"
echo.
pause
goto menu

:end
echo.
echo Tạm biệt!
echo.

