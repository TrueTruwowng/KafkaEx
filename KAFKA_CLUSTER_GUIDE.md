# 🚀 KAFKA CLUSTER - HƯỚNG DẪN SỬ DỤNG

## 📋 Tổng Quan Hệ Thống

Hệ thống bao gồm:
- **Kafka Cluster**: 3 brokers (localhost:9092, 9093, 9094)
- **Zookeeper**: 1 instance (localhost:2181)
- **Producer Service**: Spring Boot app (Port 8081)
- **Consumer Service**: Spring Boot app (Port 8082)
- **Kafka UI**: Web interface (Port 8090)

---

## 🎯 BƯỚC 1: Khởi động Kafka Cluster (3 Brokers)

### Cách 1: Sử dụng Script (Khuyến nghị)
```cmd
start-cluster.bat
```

### Cách 2: Thủ công
```cmd
docker-compose -f docker-compose-cluster.yml up -d
```

**Chờ 60 giây** để cluster khởi động hoàn toàn.

### Kiểm tra:
```cmd
docker ps
```

Bạn sẽ thấy 5 containers:
- kafka-broker-1
- kafka-broker-2
- kafka-broker-3
- zookeeper
- kafka-ui

---

## 🎯 BƯỚC 2: Kiểm tra Cluster và Leader

### Sử dụng script:
```cmd
check-cluster.bat
```

### Hoặc xem trên Kafka UI:
Mở trình duyệt: **http://localhost:8090**

Tại đây bạn sẽ thấy:
- Danh sách topics
- Thông tin về partitions
- **Leader của mỗi partition**
- ISR (In-Sync Replicas)

### Kiểm tra topic thủ công:
```cmd
docker exec kafka-broker-1 kafka-topics --bootstrap-server localhost:9092 --describe --topic orders-topic
```

**Output mẫu:**
```
Topic: orders-topic     PartitionCount: 6       ReplicationFactor: 3
        Partition: 0    Leader: 1       Replicas: 1,2,3 Isr: 1,2,3
        Partition: 1    Leader: 2       Replicas: 2,3,1 Isr: 2,3,1
        Partition: 2    Leader: 3       Replicas: 3,1,2 Isr: 3,1,2
        ...
```

**Leader** là broker chịu trách nhiệm xử lý read/write cho partition đó.

---

## 🎯 BƯỚC 3: Chạy Producer Service (Ứng dụng 1)

### Tạo file pom.xml cho Producer:
Copy file `producer-service-pom.xml` thành `producer-service/pom.xml`

### Chạy Producer:
```cmd
cd producer-service
mvn spring-boot:run -DskipTests
```

**Hoặc** tạo file `run-producer.bat`:
```cmd
cd producer-service
mvn spring-boot:run -DskipTests
```

Producer sẽ chạy trên: **http://localhost:8081**

### Kiểm tra health:
```cmd
curl http://localhost:8081/api/orders/health
```

---

## 🎯 BƯỚC 4: Chạy Consumer Service (Ứng dụng 2)

### Tạo file pom.xml cho Consumer:
Copy file `producer-service-pom.xml` và chỉnh sửa artifactId thành `ConsumerService`

### Chạy Consumer:
```cmd
cd consumer-service
mvn spring-boot:run -DskipTests
```

**Hoặc** tạo file `run-consumer.bat`:
```cmd
cd consumer-service
mvn spring-boot:run -DskipTests
```

Consumer sẽ chạy trên: **http://localhost:8082**

---

## 🎯 BƯỚC 5: Test Trao Đổi Dữ Liệu JSON

### Gửi Order từ Producer:

```cmd
curl -X POST http://localhost:8081/api/orders/create ^
  -H "Content-Type: application/json" ^
  -d "{\"customerName\":\"Nguyen Van A\",\"productName\":\"Laptop Dell\",\"quantity\":2,\"totalPrice\":30000000}"
```

### Kết quả mong đợi:

**Producer Service Log:**
```
📤 Sending order to Kafka: ORD-XXXXXXXX
✅ Order sent successfully!
   Order ID: ORD-XXXXXXXX
   Topic: orders-topic
   Partition: 3
   Offset: 0
```

**Consumer Service Log:**
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
   Partition: 3
   Offset: 0
═══════════════════════════════════════════════════════════
⚙️  Processing order: ORD-XXXXXXXX
✅ Order ORD-XXXXXXXX processed successfully
```

---

## 🎯 BƯỚC 6: Test Fault Tolerance - Dừng Leader

### Bước 6.1: Xác định Leader
```cmd
check-cluster.bat
```

Hoặc xem trên Kafka UI: **http://localhost:8090**

### Bước 6.2: Dừng Broker Leader
```cmd
stop-leader.bat
```

Script sẽ hỏi bạn muốn dừng broker nào (1, 2, hoặc 3).

### Bước 6.3: Kiểm tra Cluster sau khi dừng Leader

**Cluster sẽ tự động:**
1. Phát hiện broker bị down
2. Bầu chọn leader mới cho các partitions
3. Tiếp tục hoạt động bình thường với 2 brokers còn lại

### Bước 6.4: Test hệ thống vẫn hoạt động

**Gửi order mới:**
```cmd
curl -X POST http://localhost:8081/api/orders/create ^
  -H "Content-Type: application/json" ^
  -d "{\"customerName\":\"Tran Thi B\",\"productName\":\"iPhone 15\",\"quantity\":1,\"totalPrice\":25000000}"
```

**Hệ thống vẫn hoạt động bình thường!** ✅

Producer sẽ tự động chuyển sang broker còn hoạt động.

### Bước 6.5: Xem Leader mới
```cmd
check-cluster.bat
```

Bạn sẽ thấy:
- Các partition trước đây có leader bị dừng đã có leader mới
- ISR (In-Sync Replicas) chỉ còn 2 brokers
- Replication vẫn đảm bảo (under-replicated)

### Bước 6.6: Khởi động lại Broker bị dừng

```cmd
docker start kafka-broker-1
# hoặc kafka-broker-2, kafka-broker-3
```

Sau vài giây, broker sẽ rejoin cluster và sync data.

---

## 📊 Kiểm Tra Chi Tiết

### 1. Xem tất cả topics:
```cmd
docker exec kafka-broker-1 kafka-topics --bootstrap-server localhost:9092 --list
```

### 2. Xem chi tiết topic:
```cmd
docker exec kafka-broker-1 kafka-topics --bootstrap-server localhost:9092 --describe --topic orders-topic
```

### 3. Đọc messages từ topic:
```cmd
docker exec kafka-broker-1 kafka-console-consumer --bootstrap-server localhost:9092 --topic orders-topic --from-beginning
```

### 4. Xem consumer groups:
```cmd
docker exec kafka-broker-1 kafka-consumer-groups --bootstrap-server localhost:9092 --list
```

### 5. Chi tiết consumer group:
```cmd
docker exec kafka-broker-1 kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group order-consumer-group
```

---

## 🧪 Test Scenarios

### Test 1: Gửi nhiều orders liên tục
```cmd
for /L %i in (1,1,10) do curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Customer %i\",\"productName\":\"Product %i\",\"quantity\":1,\"totalPrice\":1000}"
```

### Test 2: Dừng broker đang là leader
1. Xác định leader của partition 0
2. Dừng broker đó
3. Gửi order mới
4. Kiểm tra Consumer vẫn nhận được

### Test 3: Dừng 2 brokers cùng lúc
```cmd
docker stop kafka-broker-2 kafka-broker-3
```

Hệ thống sẽ **không hoạt động** vì không đủ ISR (cần ít nhất 2).

---

## 🔍 Kafka UI - Giao diện trực quan

Mở: **http://localhost:8090**

Tại đây bạn có thể:
- ✅ Xem cluster topology
- ✅ Xem topics và partitions
- ✅ Xác định leader của mỗi partition
- ✅ Xem messages trong real-time
- ✅ Xem consumer groups và lag
- ✅ Monitor performance

---

## 🛑 Dừng toàn bộ hệ thống

```cmd
# Dừng services
Ctrl+C trong terminal của Producer và Consumer

# Dừng Kafka cluster
docker-compose -f docker-compose-cluster.yml down
```

---

## 📝 Tóm Tắt Kiến Trúc

```
┌─────────────────┐         ┌──────────────────────────┐         ┌─────────────────┐
│  Producer App   │ ─────>  │   Kafka Cluster (3)      │  ─────> │  Consumer App   │
│  Port: 8081     │  JSON   │   - Broker 1 (9092)      │  JSON   │  Port: 8082     │
│                 │         │   - Broker 2 (9093)      │         │                 │
│  Send Orders    │         │   - Broker 3 (9094)      │         │  Process Orders │
└─────────────────┘         │   Topic: orders-topic    │         └─────────────────┘
                            │   Partitions: 6          │
                            │   Replication: 3         │
                            └──────────────────────────┘
                                      ↓
                            ┌──────────────────────────┐
                            │   Kafka UI (8090)        │
                            │   Monitoring Dashboard   │
                            └──────────────────────────┘
```

---

## ✅ Checklist

- [ ] Kafka cluster chạy với 3 brokers
- [ ] Xác định được leader của các partitions
- [ ] Producer service hoạt động (port 8081)
- [ ] Consumer service hoạt động (port 8082)
- [ ] Gửi order và nhận được ở consumer
- [ ] Dừng leader broker
- [ ] Hệ thống tự động chọn leader mới
- [ ] Hệ thống vẫn hoạt động sau khi dừng leader
- [ ] Kafka UI hiển thị đầy đủ thông tin

---

**Chúc bạn thành công!** 🎉

