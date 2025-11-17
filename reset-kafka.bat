@echo off
echo ╔════════════════════════════════════════════════════════╗
echo ║   SỬA LỖI DESERIALIZATION - RESET KAFKA               ║
echo ╚════════════════════════════════════════════════════════╝
echo.

echo ⚠️  Lỗi: Consumer không thể deserialize messages cũ
echo ✅  Giải pháp: Xóa data cũ và restart với config mới
echo.

pause

echo.
echo BƯỚC 1: Dừng Kafka Cluster...
docker-compose -f docker-compose-cluster.yml down -v

echo.
echo BƯỚC 2: Chờ 5 giây...
timeout /t 5 /nobreak

echo.
echo BƯỚC 3: Khởi động lại Kafka Cluster...
docker-compose -f docker-compose-cluster.yml up -d

echo.
echo BƯỚC 4: Chờ 60 giây để Kafka khởi động hoàn toàn...
timeout /t 60 /nobreak

echo.
echo ✅ Kafka đã được reset và khởi động lại!
echo.
echo ========================================
echo TIẾP THEO:
echo ========================================
echo.
echo 1. Rebuild Consumer:
echo    cd consumer-service
echo    mvn clean install -DskipTests
echo    mvn spring-boot:run
echo.
echo 2. Rebuild Producer:
echo    cd producer-service
echo    mvn clean install -DskipTests
echo    mvn spring-boot:run
echo.
echo 3. Test gửi order:
echo    curl -X POST http://localhost:8081/api/orders/create ^
echo      -H "Content-Type: application/json" ^
echo      -d "{\"customerName\":\"Test\",\"productName\":\"Laptop\",\"quantity\":1,\"totalPrice\":1500}"
echo.
echo ========================================
pause

