# 🔧 SỬA LỖI 404 - HƯỚNG DẪN SỬ DỤNG ĐÚNG

## ❌ LỖI BẠN GẶP PHẢI

```
Whitelabel Error Page
type=Not Found, status=404
```

**Nguyên nhân:** Bạn đang truy cập sai URL!

---

## ✅ CÁCH SỬ DỤNG ĐÚNG

### 📌 Producer Service (Port 8081)

#### 1. Root URL (Trang chủ - Thông tin service)
```
http://localhost:8081/
```
**Hoặc:**
```cmd
curl http://localhost:8081/
```

#### 2. Health Check
```
http://localhost:8081/api/orders/health
```
**Hoặc:**
```cmd
curl http://localhost:8081/api/orders/health
```

#### 3. Tạo Order (POST)
**URL:** `http://localhost:8081/api/orders/create`

**Với curl:**
```cmd
curl -X POST http://localhost:8081/api/orders/create ^
  -H "Content-Type: application/json" ^
  -d "{\"customerName\":\"Nguyen Van A\",\"productName\":\"Laptop Dell\",\"quantity\":2,\"totalPrice\":30000000}"
```

**Với Postman:**
- Method: POST
- URL: `http://localhost:8081/api/orders/create`
- Headers: `Content-Type: application/json`
- Body (raw JSON):
```json
{
  "customerName": "Nguyen Van A",
  "productName": "Laptop Dell",
  "quantity": 2,
  "totalPrice": 30000000
}
```

---

### 📌 Consumer Service (Port 8082)

#### 1. Root URL (Trang chủ - Thông tin service)
```
http://localhost:8082/
```
**Hoặc:**
```cmd
curl http://localhost:8082/
```

**Lưu ý:** Consumer không có API endpoint, nó tự động nhận messages từ Kafka. Xem logs trong console!

---

## 🧪 TEST NHANH

### Test 1: Kiểm tra services đang chạy

**Producer:**
```cmd
curl http://localhost:8081/
```

**Consumer:**
```cmd
curl http://localhost:8082/
```

### Test 2: Health check Producer

```cmd
curl http://localhost:8081/api/orders/health
```

**Kết quả mong đợi:**
```json
{
  "status": "UP",
  "service": "Producer Service",
  "port": "8081"
}
```

### Test 3: Gửi order

```cmd
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Test User\",\"productName\":\"iPhone 15\",\"quantity\":1,\"totalPrice\":25000000}"
```

**Kết quả mong đợi:**
```json
{
  "status": "success",
  "message": "Order created and sent to processing queue",
  "orderId": "ORD-XXXXXXXX",
  "timestamp": "2025-11-17T11:20:00"
}
```

**Kiểm tra Consumer logs** - Bạn sẽ thấy order được nhận!

---

## 📝 TẤT CẢ ENDPOINTS

### Producer Service (8081):

| Method | URL | Mô tả |
|--------|-----|-------|
| GET | `http://localhost:8081/` | Trang chủ, thông tin service |
| GET | `http://localhost:8081/api/orders/health` | Health check |
| POST | `http://localhost:8081/api/orders/create` | Tạo order mới |

### Consumer Service (8082):

| Method | URL | Mô tả |
|--------|-----|-------|
| GET | `http://localhost:8082/` | Trang chủ, thông tin service |

---

## 🔄 RESTART SERVICES (Để áp dụng HomeController mới)

### Bước 1: Stop services hiện tại
Nhấn **Ctrl+C** trong terminal của Producer và Consumer

### Bước 2: Rebuild và restart

**Producer:**
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample\producer-service
mvn clean install -DskipTests
mvn spring-boot:run
```

**Consumer:**
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample\consumer-service
mvn clean install -DskipTests
mvn spring-boot:run
```

### Bước 3: Test lại

```cmd
curl http://localhost:8081/
curl http://localhost:8082/
```

Bây giờ không còn lỗi 404 nữa! ✅

---

## 💡 LƯU Ý QUAN TRỌNG

### ❌ SAI:
```
http://localhost:8081/orders/create
http://localhost:8081/health
```

### ✅ ĐÚNG:
```
http://localhost:8081/api/orders/create
http://localhost:8081/api/orders/health
```

**Lý do:** Trong `@RequestMapping("/api/orders")` nên path phải có `/api/orders`

---

## 🎯 WORKFLOW HOÀN CHỈNH

1. **Start Kafka Cluster**
   ```cmd
   start-cluster.bat
   ```

2. **Start Producer**
   ```cmd
   cd producer-service
   run-producer.bat
   ```

3. **Start Consumer**
   ```cmd
   cd consumer-service
   run-consumer.bat
   ```

4. **Test Root URLs**
   ```cmd
   curl http://localhost:8081/
   curl http://localhost:8082/
   ```

5. **Send Order**
   ```cmd
   curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Test\",\"productName\":\"Product\",\"quantity\":1,\"totalPrice\":1000}"
   ```

6. **Check Consumer Logs** - Xem message được nhận!

---

## 📞 CÁC URL QUAN TRỌNG

- **Producer Root:** http://localhost:8081/
- **Producer Health:** http://localhost:8081/api/orders/health
- **Producer Create:** http://localhost:8081/api/orders/create (POST)
- **Consumer Root:** http://localhost:8082/
- **Kafka UI:** http://localhost:8090/

---

**✅ BÂY GIỜ HỆ THỐNG SẼ HOẠT ĐỘNG ĐÚNG!**

Sau khi restart services, truy cập `http://localhost:8081/` và bạn sẽ thấy thông tin service thay vì lỗi 404! 🎉

