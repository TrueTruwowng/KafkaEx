@echo off
echo ╔════════════════════════════════════════════════════════╗
echo ║   KAFKA CLUSTER - TEST ĐÚNG URLs                      ║
echo ╚════════════════════════════════════════════════════════╝
echo.

:menu
echo ========================================
echo CHỌN TEST:
echo ========================================
echo.
echo 1. Test Producer Root (http://localhost:8081/)
echo 2. Test Consumer Root (http://localhost:8082/)
echo 3. Test Producer Health
echo 4. Gửi 1 Order
echo 5. Gửi 5 Orders
echo 6. Xem Kafka UI
echo 7. Hướng dẫn sử dụng đúng
echo 0. Thoát
echo.
echo ========================================

set /p choice="Nhập lựa chọn (0-7): "

if "%choice%"=="1" goto test_producer_root
if "%choice%"=="2" goto test_consumer_root
if "%choice%"=="3" goto test_health
if "%choice%"=="4" goto send_one
if "%choice%"=="5" goto send_five
if "%choice%"=="6" goto kafka_ui
if "%choice%"=="7" goto guide
if "%choice%"=="0" goto end

echo Lựa chọn không hợp lệ!
pause
goto menu

:test_producer_root
echo.
echo ========================================
echo TEST: Producer Root URL
echo ========================================
echo.
echo URL: http://localhost:8081/
echo.
curl http://localhost:8081/
echo.
echo.
echo ✅ Nếu thấy JSON response → Service đang chạy OK!
echo ❌ Nếu thấy lỗi 404 → Cần restart service
echo.
pause
goto menu

:test_consumer_root
echo.
echo ========================================
echo TEST: Consumer Root URL
echo ========================================
echo.
echo URL: http://localhost:8082/
echo.
curl http://localhost:8082/
echo.
echo.
echo ✅ Nếu thấy JSON response → Service đang chạy OK!
echo ❌ Nếu thấy lỗi 404 → Cần restart service
echo.
pause
goto menu

:test_health
echo.
echo ========================================
echo TEST: Producer Health Check
echo ========================================
echo.
echo URL: http://localhost:8081/api/orders/health
echo.
curl http://localhost:8081/api/orders/health
echo.
echo.
echo Expected: {"status":"UP","service":"Producer Service","port":"8081"}
echo.
pause
goto menu

:send_one
echo.
echo ========================================
echo SEND 1 ORDER
echo ========================================
echo.
echo URL: http://localhost:8081/api/orders/create
echo Method: POST
echo.
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Nguyen Van A\",\"productName\":\"Laptop Dell\",\"quantity\":2,\"totalPrice\":30000000}"
echo.
echo.
echo ✅ Kiểm tra logs của Consumer để xem order!
echo.
pause
goto menu

:send_five
echo.
echo ========================================
echo SEND 5 ORDERS
echo ========================================
echo.
for /L %%i in (1,1,5) do (
    echo Sending order %%i...
    curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Customer %%i\",\"productName\":\"Product %%i\",\"quantity\":%%i,\"totalPrice\":%%i000000}"
    echo.
    timeout /t 1 /nobreak >nul
)
echo.
echo ✅ Đã gửi 5 orders! Xem Consumer logs!
echo.
pause
goto menu

:kafka_ui
echo.
echo ========================================
echo KAFKA UI
echo ========================================
echo.
echo Mở trình duyệt và vào:
echo http://localhost:8090
echo.
echo Tại đây bạn có thể xem:
echo - Cluster với 3 brokers
echo - Topic: orders-topic
echo - Messages
echo - Consumer groups
echo - Partitions và Leaders
echo.
start http://localhost:8090
echo.
pause
goto menu

:guide
echo.
echo ========================================
echo HƯ��NG DẪN SỬ DỤNG ĐÚNG
echo ========================================
echo.
echo PRODUCER ENDPOINTS:
echo -------------------
echo 1. Root (GET):
echo    http://localhost:8081/
echo.
echo 2. Health (GET):
echo    http://localhost:8081/api/orders/health
echo.
echo 3. Create Order (POST):
echo    http://localhost:8081/api/orders/create
echo    Body: {"customerName":"...", "productName":"...", ...}
echo.
echo CONSUMER ENDPOINTS:
echo -------------------
echo 1. Root (GET):
echo    http://localhost:8082/
echo.
echo KAFKA UI:
echo ---------
echo http://localhost:8090
echo.
echo ========================================
echo.
echo LƯU Ý:
echo - Producer có endpoints API
echo - Consumer tự động nhận từ Kafka (xem logs)
echo - Phải có /api/orders trong URL
echo.
pause
goto menu

:end
echo.
echo Tạm biệt!
echo.

