# 🚀 HƯỚNG DẪN CHẠY NHANH - KAFKA CLUSTER

## ✅ TÓM TẮT: Tất cả files đã được tạo sẵn!

Cấu trúc đã HOÀN CHỈNH:
- ✅ Producer Service: `producer-service/src/main/java/com/example/producer/`
- ✅ Consumer Service: `consumer-service/src/main/java/com/example/consumer/`
- ✅ Kafka Cluster: `docker-compose-cluster.yml`
- ✅ Scripts: `start-cluster.bat`, `check-cluster.bat`, `stop-leader.bat`

---

## 🎯 CHẠY NGAY (3 BƯỚC)

### BƯỚC 1: Khởi động Kafka Cluster (3 brokers)

Mở Terminal 1:
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample
start-cluster.bat
```

**Chờ 60 giây** để Kafka cluster khởi động.

**Kiểm tra:** Mở http://localhost:8090 (Kafka UI)

---

### BƯỚC 2: Khởi động Producer Service

Mở Terminal 2:
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample\producer-service
run-producer.bat
```

Hoặc:
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample\producer-service
mvn clean install -DskipTests
mvn spring-boot:run
```

**Chờ** cho đến khi thấy:
```
Started ProducerServiceApplication in X.XXX seconds
```

Producer chạy trên: **http://localhost:8081**

---

### BƯỚC 3: Khởi động Consumer Service

Mở Terminal 3:
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample\consumer-service
run-consumer.bat
```

Hoặc:
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample\consumer-service
mvn clean install -DskipTests
mvn spring-boot:run
```

**Chờ** cho đến khi thấy:
```
Started ConsumerServiceApplication in X.XXX seconds
```

Consumer chạy trên: **http://localhost:8082**

---

## 🧪 BƯỚC 4: Test Gửi Order

Mở Terminal 4 (hoặc sử dụng Postman):

### Test 1: Gửi 1 order
```cmd
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Nguyen Van A\",\"productName\":\"Laptop Dell\",\"quantity\":2,\"totalPrice\":30000000}"
```

**Kết quả mong đợi:**

**Terminal 2 (Producer):**
```
📤 Sending order to Kafka: ORD-XXXXXXXX
✅ Order sent successfully!
   Order ID: ORD-XXXXXXXX
   Topic: orders-topic
   Partition: 2
   Offset: 0
```

**Terminal 3 (Consumer):**
```
═══════════════════════════════════════════════════════════
📥 RECEIVED ORDER FROM KAFKA CLUSTER
═══════════════════════════════════════════════════════════
🔹 Order ID: ORD-XXXXXXXX
🔹 Customer: Nguyen Van A
🔹 Product: Laptop Dell
🔹 Quantity: 2
🔹 Total Price: $30000000.0
🔹 Status: PENDING
───────────────────────────────────────────────────────────
📊 Kafka Metadata:
   Topic: orders-topic
   Partition: 2
   Offset: 0
═══════════════════════════════════════════════════════════
⚙️  Processing order: ORD-XXXXXXXX
✅ Order ORD-XXXXXXXX processed successfully
```

### Test 2: Gửi nhiều orders
```cmd
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Tran Thi B\",\"productName\":\"iPhone 15\",\"quantity\":1,\"totalPrice\":25000000}"

curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Le Van C\",\"productName\":\"MacBook Pro\",\"quantity\":1,\"totalPrice\":45000000}"
```

---

## 🔍 BƯỚC 5: Kiểm Tra Leader và Cluster

### Xem leader của các partitions:
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample
check-cluster.bat
```

**Hoặc** mở Kafka UI: http://localhost:8090
- Click vào topic "orders-topic"
- Tab "Partitions" → Xem cột "Leader"

**Output mẫu:**
```
Topic: orders-topic     PartitionCount: 6       ReplicationFactor: 3
        Partition: 0    Leader: 1       Replicas: 1,2,3 Isr: 1,2,3
        Partition: 1    Leader: 2       Replicas: 2,3,1 Isr: 2,3,1
        Partition: 2    Leader: 3       Replicas: 3,1,2 Isr: 3,1,2
        Partition: 3    Leader: 1       Replicas: 1,2,3 Isr: 1,2,3
        Partition: 4    Leader: 2       Replicas: 2,3,1 Isr: 2,3,1
        Partition: 5    Leader: 3       Replicas: 3,1,2 Isr: 3,1,2
```

**Leader = Broker chịu trách nhiệm read/write cho partition đó**

---

## 🛑 BƯỚC 6: Test Fault Tolerance (Dừng Leader)

### 6.1. Dừng Broker 1 (giả sử là leader)
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample
stop-leader.bat
```

Chọn broker để dừng (ví dụ: 1)

**Hoặc thủ công:**
```cmd
docker stop kafka-broker-1
```

### 6.2. Chờ 10 giây để cluster rebalance

### 6.3. Gửi order mới
```cmd
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Test After Failure\",\"productName\":\"Test Product\",\"quantity\":1,\"totalPrice\":1000}"
```

### 6.4. ✅ KẾT QUẢ: HỆ THỐNG VẪN HOẠT ĐỘNG!

Producer và Consumer vẫn hoạt động bình thường!

### 6.5. Kiểm tra leader mới
```cmd
check-cluster.bat
```

Hoặc xem trên Kafka UI - Leader đã chuyển sang Broker 2 hoặc 3

### 6.6. Khởi động lại broker
```cmd
docker start kafka-broker-1
```

Broker sẽ rejoin cluster và sync lại data.

---

## 📊 Monitoring với Kafka UI

**URL:** http://localhost:8090

Tại đây bạn có thể:
- ✅ Xem 3 brokers
- ✅ Xem topic "orders-topic" với 6 partitions
- ✅ Xem **Leader** của mỗi partition
- ✅ Xem messages realtime
- ✅ Xem consumer group "order-consumer-group"
- ✅ Monitor lag và offset

---

## 🎯 CẤU TRÚC ĐÃ TẠO

```
KafkaExample/
│
├── 📄 docker-compose-cluster.yml      # Kafka 3 brokers config
├── 🔧 start-cluster.bat               # Start cluster
├── 🔍 check-cluster.bat               # Check leader
├── 🛑 stop-leader.bat                 # Test fault tolerance
│
├── 📦 producer-service/
│   ├── pom.xml                        ✅ Có mainClass config
│   ├── run-producer.bat               ✅ Script chạy
│   └── src/main/java/com/example/producer/
│       ├── ProducerServiceApplication.java  ✅
│       ├── config/
│       │   ├── KafkaProducerConfig.java     ✅
│       │   └── KafkaTopicConfig.java        ✅
│       ├── controller/
│       │   └── OrderController.java         ✅
│       ├── model/
│       │   └── Order.java                   ✅
│       └── service/
│           └── OrderProducerService.java    ✅
│
└── 📦 consumer-service/
    ├── pom.xml                        ✅ Có mainClass config
    ├── run-consumer.bat               ✅ Script chạy
    └── src/main/java/com/example/consumer/
        ├── ConsumerServiceApplication.java  ✅
        ├── config/
        │   └── KafkaConsumerConfig.java     ✅
        ├── model/
        │   └── Order.java                   ✅
        └── service/
            └── OrderConsumerService.java    ✅
```

---

## ⚡ TÓM TẮT LỆNH

| Bước | Lệnh | Terminal |
|------|------|----------|
| 1. Start Kafka | `start-cluster.bat` | Terminal 1 |
| 2. Start Producer | `cd producer-service && run-producer.bat` | Terminal 2 |
| 3. Start Consumer | `cd consumer-service && run-consumer.bat` | Terminal 3 |
| 4. Send Order | `curl -X POST ...` | Terminal 4 |
| 5. Check Leader | `check-cluster.bat` | Terminal 4 |
| 6. Stop Leader | `stop-leader.bat` | Terminal 4 |

---

## 🆘 Troubleshooting

### Lỗi: Unable to find main class
**Đã fix!** Cả 2 pom.xml đã có `<mainClass>` configuration.

### Lỗi: Cannot connect to Kafka
**Giải pháp:** Đảm bảo Kafka cluster đang chạy:
```cmd
docker ps --filter "name=kafka"
```

### Lỗi: Port already in use
**Giải pháp:** Dừng các service cũ:
```cmd
docker-compose -f docker-compose-cluster.yml down
```

---

## ✅ CHECKLIST HOÀN THÀNH

- [x] Kafka cluster (3 brokers) files tạo xong
- [x] Producer service code hoàn chỉnh
- [x] Consumer service code hoàn chỉnh
- [x] POM files có mainClass
- [x] Scripts chạy (.bat files)
- [x] Application.properties đầy đủ
- [x] Hướng dẫn chi tiết

---

## 🎉 KẾT LUẬN

**TẤT CẢ ĐÃ SẴN SÀNG!**

Bạn chỉ cần:
1. Chạy `start-cluster.bat`
2. Chạy `run-producer.bat` 
3. Chạy `run-consumer.bat`
4. Test với curl hoặc Postman

**Hệ thống sẽ hoạt động ngay!** 🚀

Xem thêm:
- `KAFKA_CLUSTER_GUIDE.md` - Hướng dẫn đầy đủ
- `README_CLUSTER.md` - Tổng quan và đáp án bài tập

