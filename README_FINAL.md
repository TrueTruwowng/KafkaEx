# ✅ HỆ THỐNG KAFKA CLUSTER - HOÀN CHỈNH

## 🎯 BÀI TẬP ĐÃ HOÀN THÀNH

✅ **1. Tạo 2 ứng dụng Spring Boot trao đổi JSON qua Kafka**
- Producer Service (Port 8081) ✅
- Consumer Service (Port 8082) ✅

✅ **2. Kafka Cluster 3 brokers**
- Broker 1: localhost:9092 ✅
- Broker 2: localhost:9093 ✅
- Broker 3: localhost:9094 ✅
- Kafka UI: http://localhost:8090 ✅

✅ **3. Kiểm tra Leader**
- Script: `check-cluster.bat` ✅
- Kafka UI: http://localhost:8090 ✅

✅ **4. Test Fault Tolerance**
- Script: `stop-leader.bat` ✅
- Hệ thống vẫn hoạt động khi dừng leader ✅

---

## 🚀 BẮT ĐẦU NGAY

### Bước 1: Start Kafka Cluster
```cmd
start-cluster.bat
```
Chờ 60 giây.

### Bước 2: Start Producer (Terminal mới)
```cmd
cd producer-service
run-producer.bat
```

### Bước 3: Start Consumer (Terminal mới)
```cmd
cd consumer-service
run-consumer.bat
```

### Bước 4: Test
```cmd
test-scenarios.bat
```

Hoặc:
```cmd
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Test\",\"productName\":\"Laptop\",\"quantity\":1,\"totalPrice\":1500}"
```

---

## 📁 FILES QUAN TRỌNG

| File | Mô tả |
|------|-------|
| **START_HERE.md** | ⭐ ĐỌC FILE NÀY TRƯỚC! |
| **test-scenarios.bat** | ⭐ Menu test tất cả scenarios |
| `start-cluster.bat` | Khởi động Kafka cluster |
| `check-cluster.bat` | Kiểm tra leader |
| `stop-leader.bat` | Test fault tolerance |
| `producer-service/run-producer.bat` | Chạy Producer |
| `consumer-service/run-consumer.bat` | Chạy Consumer |
| `KAFKA_CLUSTER_GUIDE.md` | Hướng dẫn đầy đủ |
| `README_CLUSTER.md` | Đáp án bài tập |

---

## 🎓 KIẾN THỨC

### Kafka Leader
- Mỗi partition có 1 leader
- Leader xử lý tất cả read/write
- Khi leader down → Tự động chọn leader mới

### Fault Tolerance
- Replication Factor = 3
- Min ISR = 2
- Chịu được tối đa 1 broker down

### Kết luận
**✅ Hệ thống VẪN hoạt động khi dừng leader!**

---

## 📊 PORTS

| Service | Port |
|---------|------|
| Kafka Broker 1 | 9092 |
| Kafka Broker 2 | 9093 |
| Kafka Broker 3 | 9094 |
| Producer | 8081 |
| Consumer | 8082 |
| Kafka UI | 8090 |

---

**🎉 TẤT CẢ ĐÃ SẴN SÀNG - CHẠY NGAY!**

Đọc `START_HERE.md` để bắt đầu! 🚀

