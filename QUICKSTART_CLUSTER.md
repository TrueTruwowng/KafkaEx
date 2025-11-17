# ⚡ HƯỚNG DẪN NHANH - BẮT ĐẦU NGAY

## 📋 Chuẩn Bị

### 1. Cài đặt Docker Desktop
- Download: https://www.docker.com/products/docker-desktop/
- Khởi động Docker Desktop

### 2. Cài đặt Java 21 và Maven
- Java 21 JDK
- Maven 3.8+

---

## 🚀 CHẠY HỆ THỐNG (5 BƯỚC)

### BƯỚC 1: Khởi động Kafka Cluster
```cmd
start-cluster.bat
```
**Chờ 60 giây**

### BƯỚC 2: Setup Producer Service

**Tạo cấu trúc thư mục:**
```cmd
mkdir producer-service\src\main\java\com\example\producer
mkdir producer-service\src\main\java\com\example\producer\config
mkdir producer-service\src\main\java\com\example\producer\controller
mkdir producer-service\src\main\java\com\example\producer\model
mkdir producer-service\src\main\java\com\example\producer\service
mkdir producer-service\src\main\resources
```

**Copy files:**
1. Copy `producer-service-pom.xml` → `producer-service\pom.xml`
2. Copy các file Java từ thư mục `producer-service\` vào đúng package
3. Copy `producer-service\application.properties` → `producer-service\src\main\resources\`

**Chạy Producer:**
```cmd
cd producer-service
mvn clean install -DskipTests
mvn spring-boot:run
```

Producer chạy trên: **http://localhost:8081**

### BƯỚC 3: Setup Consumer Service

**Tạo cấu trúc thư mục:**
```cmd
mkdir consumer-service\src\main\java\com\example\consumer
mkdir consumer-service\src\main\java\com\example\consumer\config
mkdir consumer-service\src\main\java\com\example\consumer\model
mkdir consumer-service\src\main\java\com\example\consumer\service
mkdir consumer-service\src\main\resources
```

**Copy files:**
1. Copy `consumer-service-pom.xml` → `consumer-service\pom.xml`
2. Copy các file Java từ thư mục `consumer-service\` vào đúng package
3. Copy `consumer-service\application.properties` → `consumer-service\src\main\resources\`

**Chạy Consumer (terminal mới):**
```cmd
cd consumer-service
mvn clean install -DskipTests
mvn spring-boot:run
```

Consumer chạy trên: **http://localhost:8082**

### BƯỚC 4: Test Gửi Order

```cmd
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Nguyen Van A\",\"productName\":\"Laptop\",\"quantity\":1,\"totalPrice\":1500}"
```

**Kiểm tra:**
- Producer log: Thấy order được gửi
- Consumer log: Thấy order được nhận và xử lý

### BƯỚC 5: Test Fault Tolerance

**Xem leader:**
```cmd
check-cluster.bat
```

**Dừng leader:**
```cmd
stop-leader.bat
```

**Gửi order mới:** (Hệ thống vẫn hoạt động!)
```cmd
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Test After Failure\",\"productName\":\"Test\",\"quantity\":1,\"totalPrice\":100}"
```

---

## 📊 Monitoring

### Kafka UI
**URL:** http://localhost:8090

Tại đây bạn thấy:
- Cluster topology
- Topics và partitions
- **Leader của mỗi partition** ⭐
- Messages realtime
- Consumer groups

---

## 🔍 Kiểm Tra Cluster

### Xem cluster status:
```cmd
docker ps --filter "name=kafka"
```

### Xem topic details:
```cmd
docker exec kafka-broker-1 kafka-topics --bootstrap-server localhost:9092 --describe --topic orders-topic
```

### Output mẫu:
```
Topic: orders-topic     PartitionCount: 6       ReplicationFactor: 3
        Partition: 0    Leader: 1       Replicas: 1,2,3 Isr: 1,2,3
        Partition: 1    Leader: 2       Replicas: 2,3,1 Isr: 2,3,1
        Partition: 2    Leader: 3       Replicas: 3,1,2 Isr: 3,1,2
        Partition: 3    Leader: 1       Replicas: 1,2,3 Isr: 1,2,3
        Partition: 4    Leader: 2       Replicas: 2,3,1 Isr: 2,3,1
        Partition: 5    Leader: 3       Replicas: 3,1,2 Isr: 3,1,2
```

**Leader** = Broker xử lý read/write cho partition
**Replicas** = Các broker lưu bản sao
**Isr** = In-Sync Replicas (đang đồng bộ)

---

## 🧪 Test Scenarios

### 1. Gửi 1 order
```cmd
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"John\",\"productName\":\"Phone\",\"quantity\":1,\"totalPrice\":1000}"
```

### 2. Gửi nhiều orders
```cmd
for /L %i in (1,1,5) do curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Customer%i\",\"productName\":\"Product%i\",\"quantity\":1,\"totalPrice\":100}"
```

### 3. Dừng Broker 1 (leader)
```cmd
docker stop kafka-broker-1
```

**Kiểm tra:** Gửi order mới, hệ thống vẫn hoạt động!

### 4. Restart broker đã dừng
```cmd
docker start kafka-broker-1
```

Broker sẽ rejoin cluster và sync lại data.

---

## 🎯 CẤU TRÚC THƯ MỤC HOÀN CHỈNH

```
KafkaExample/
├── docker-compose-cluster.yml          # Kafka cluster 3 nodes
├── start-cluster.bat                   # Script khởi động cluster
├── check-cluster.bat                   # Script kiểm tra leader
├── stop-leader.bat                     # Script test fault tolerance
├── KAFKA_CLUSTER_GUIDE.md             # Hướng dẫn đầy đủ
│
├── producer-service/
│   ├── pom.xml
│   └── src/main/
│       ├── java/com/example/producer/
│       │   ├── ProducerServiceApplication.java
│       │   ├── config/
│       │   │   ├── KafkaProducerConfig.java
│       │   │   └── KafkaTopicConfig.java
│       │   ├── controller/
│       │   │   └── OrderController.java
│       │   ├── model/
│       │   │   └── Order.java
│       │   └── service/
│       │       └── OrderProducerService.java
│       └── resources/
│           └── application.properties
│
└── consumer-service/
    ├── pom.xml
    └── src/main/
        ├── java/com/example/consumer/
        │   ├── ConsumerServiceApplication.java
        │   ├── config/
        │   │   └── KafkaConsumerConfig.java
        │   ├── model/
        │   │   └── Order.java
        │   └── service/
        │       └── OrderConsumerService.java
        └── resources/
            └── application.properties
```

---

## 🛠️ Troubleshooting

### Lỗi: Cannot connect to Kafka
**Giải pháp:** 
```cmd
docker-compose -f docker-compose-cluster.yml down
docker-compose -f docker-compose-cluster.yml up -d
```
Chờ 60 giây.

### Lỗi: Port already in use
**Giải pháp:**
```cmd
# Dừng tất cả containers
docker-compose -f docker-compose-cluster.yml down

# Check ports
netstat -ano | findstr :9092
netstat -ano | findstr :8081
netstat -ano | findstr :8082
```

### Producer/Consumer không start
**Giải pháp:**
```cmd
# Trong thư mục service
mvn clean install -DskipTests
mvn spring-boot:run
```

---

## ✅ Checklist Hoàn Thành

- [ ] Docker Desktop đang chạy
- [ ] Kafka cluster khởi động (3 brokers + Zookeeper + UI)
- [ ] Producer service chạy thành công (port 8081)
- [ ] Consumer service chạy thành công (port 8082)
- [ ] Gửi order và nhận được ở consumer
- [ ] Xác định được leader của các partitions
- [ ] Dừng leader và hệ thống vẫn hoạt động
- [ ] Kafka UI hiển thị cluster info

---

## 📞 Ports Summary

| Service | Port | URL |
|---------|------|-----|
| Zookeeper | 2181 | - |
| Kafka Broker 1 | 9092 | localhost:9092 |
| Kafka Broker 2 | 9093 | localhost:9093 |
| Kafka Broker 3 | 9094 | localhost:9094 |
| Producer Service | 8081 | http://localhost:8081 |
| Consumer Service | 8082 | http://localhost:8082 |
| Kafka UI | 8090 | http://localhost:8090 |

---

**🎉 Chúc bạn thành công!**

Đọc `KAFKA_CLUSTER_GUIDE.md` để biết thêm chi tiết.

