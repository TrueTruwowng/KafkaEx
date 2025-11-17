# 🎯 BÀI TẬP KAFKA CLUSTER - HOÀN CHỈNH

## 📝 Yêu Cầu Bài Tập

✅ **1. Tạo 2 ứng dụng Spring Boot trao đổi dữ liệu (JSON) với nhau thông qua Kafka**

✅ **2. Nâng cấp Kafka thành cluster gồm 3 máy**

✅ **3. Kiểm tra trong 3 máy trong cụm, máy nào làm leader**

✅ **4. Dừng máy Kafka leader, kiểm tra xem hệ thống có còn hoạt động bình thường?**

---

## 🎉 GIẢI PHÁP ĐÃ ĐƯỢC TẠO

### 1️⃣ HAI ỨNG DỤNG SPRING BOOT

#### **Producer Service** (Ứng dụng 1)
- **Port**: 8081
- **Chức năng**: Nhận HTTP POST request với JSON order data
- **API Endpoint**: `POST /api/orders/create`
- **Công nghệ**: Spring Boot 3.2.0 + Spring Kafka
- **File**: Thư mục `producer-service/`

#### **Consumer Service** (Ứng dụng 2)
- **Port**: 8082
- **Chức năng**: Tự động nhận và xử lý order JSON từ Kafka
- **Công nghệ**: Spring Boot 3.2.0 + Spring Kafka
- **File**: Thư mục `consumer-service/`

#### **Order Model (JSON)**
```json
{
  "orderId": "ORD-12345678",
  "customerName": "Nguyen Van A",
  "productName": "Laptop Dell",
  "quantity": 2,
  "totalPrice": 30000000,
  "orderDate": "2025-11-17T10:30:00",
  "status": "PENDING"
}
```

---

### 2️⃣ KAFKA CLUSTER 3 BROKERS

**Cấu hình:**
- **Broker 1**: localhost:9092
- **Broker 2**: localhost:9093
- **Broker 3**: localhost:9094
- **Zookeeper**: localhost:2181
- **Kafka UI**: http://localhost:8090

**Đặc điểm:**
- ✅ Replication Factor: 3 (mỗi partition có 3 bản sao)
- ✅ Min ISR: 2 (cần ít nhất 2 broker đồng bộ)
- ✅ Partitions: 6 (phân tán tải)
- ✅ Auto topic creation
- ✅ Fault tolerance

**File**: `docker-compose-cluster.yml`

---

### 3️⃣ KIỂM TRA LEADER

#### **Cách 1: Sử dụng Script**
```cmd
check-cluster.bat
```

#### **Cách 2: Kafka UI**
Mở: **http://localhost:8090**
- Click vào topic "orders-topic"
- Xem tab "Partitions"
- Cột "Leader" hiển thị broker ID

#### **Cách 3: Command Line**
```cmd
docker exec kafka-broker-1 kafka-topics --bootstrap-server localhost:9092 --describe --topic orders-topic
```

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

**Giải thích:**
- **Leader: 1** = Broker 1 là leader cho partition đó
- **Replicas: 1,2,3** = Data được lưu trên cả 3 brokers
- **Isr: 1,2,3** = Cả 3 brokers đang đồng bộ

---

### 4️⃣ TEST FAULT TOLERANCE (DỪNG LEADER)

#### **Bước 1: Xác định Leader**
```cmd
check-cluster.bat
```
Giả sử Broker 1 là leader của một số partitions.

#### **Bước 2: Dừng Broker Leader**
```cmd
# Cách 1: Sử dụng script
stop-leader.bat

# Cách 2: Thủ công
docker stop kafka-broker-1
```

#### **Bước 3: Cluster Tự Động Recovery**
**Điều gì xảy ra:**
1. ⏱️ Zookeeper phát hiện Broker 1 bị down (~5-10 giây)
2. 🔄 Tự động bầu chọn leader mới từ ISR
3. ✅ Broker 2 hoặc 3 trở thành leader mới
4. 📊 Cluster tiếp tục hoạt động với 2 brokers

**Kiểm tra leader mới:**
```cmd
# Từ broker còn hoạt động
docker exec kafka-broker-2 kafka-topics --bootstrap-server localhost:9093 --describe --topic orders-topic
```

**Output sau khi dừng Broker 1:**
```
Partition: 0    Leader: 2       Replicas: 1,2,3 Isr: 2,3
Partition: 1    Leader: 2       Replicas: 2,3,1 Isr: 2,3
Partition: 2    Leader: 3       Replicas: 3,1,2 Isr: 3,2
```

**Thay đổi:**
- ✅ Leader đã chuyển từ Broker 1 → Broker 2/3
- ⚠️ ISR giảm từ 3 → 2 brokers
- ⚠️ Under-replicated (thiếu 1 replica)

#### **Bước 4: Test Hệ Thống Vẫn Hoạt Động**

**Gửi order mới:**
```cmd
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Test After Failure\",\"productName\":\"Laptop\",\"quantity\":1,\"totalPrice\":1500}"
```

**✅ KẾT QUẢ: HỆ THỐNG VẪN HOẠT ĐỘNG BÌNH THƯỜNG!**

**Producer log:**
```
📤 Sending order to Kafka: ORD-XXXXXXXX
✅ Order sent successfully!
   Partition: 2
   Offset: 5
```

**Consumer log:**
```
📥 RECEIVED ORDER FROM KAFKA CLUSTER
🔹 Customer: Test After Failure
🔹 Product: Laptop
📊 Partition: 2
   Offset: 5
✅ Order processed successfully
```

#### **Bước 5: Khởi Động Lại Broker**
```cmd
docker start kafka-broker-1
```

**Điều gì xảy ra:**
1. ⏱️ Broker 1 rejoin cluster (~10-20 giây)
2. 🔄 Sync lại data từ leader
3. ✅ ISR trở lại đầy đủ: Isr: 1,2,3
4. ⚖️ Leader có thể rebalance (hoặc không)

---

## 🚀 HƯỚNG DẪN CHẠY

### ⚡ Khởi Động Nhanh (4 Bước)

#### **1. Start Kafka Cluster**
```cmd
start-cluster.bat
```
Chờ 60 giây.

#### **2. Start Producer Service**
```cmd
cd producer-service
mvn spring-boot:run -DskipTests
```

#### **3. Start Consumer Service** (terminal mới)
```cmd
cd consumer-service
mvn spring-boot:run -DskipTests
```

#### **4. Test**
```cmd
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Nguyen Van A\",\"productName\":\"Laptop\",\"quantity\":1,\"totalPrice\":1500}"
```

---

## 📊 DEMO KỊCH BẢN

### **Kịch Bản 1: Hoạt Động Bình Thường**
1. Cluster 3 brokers đang chạy
2. Gửi 5 orders từ Producer
3. Consumer nhận và xử lý tất cả 5 orders
4. ✅ Kết quả: Tất cả orders được xử lý thành công

### **Kịch Bản 2: Dừng Leader - Hệ Thống Vẫn Hoạt Động**
1. Xác định Broker 1 là leader của partition 0
2. Dừng Broker 1: `docker stop kafka-broker-1`
3. Chờ 10 giây cho cluster rebalance
4. Gửi 5 orders mới từ Producer
5. ✅ Kết quả: Consumer VẪN nhận được tất cả 5 orders
6. Leader mới: Broker 2 hoặc 3

### **Kịch Bản 3: Khôi Phục Broker**
1. Start lại Broker 1: `docker start kafka-broker-1`
2. Broker 1 rejoin cluster và sync data
3. Gửi orders mới
4. ✅ Kết quả: Hệ thống hoạt động với cả 3 brokers

### **Kịch Bản 4: Dừng 2 Brokers - Hệ Thống Ngừng**
1. Dừng Broker 1 và 2: `docker stop kafka-broker-1 kafka-broker-2`
2. Chỉ còn 1 broker (không đủ ISR = 2)
3. Gửi order
4. ❌ Kết quả: Lỗi! Không đủ ISR để commit

---

## 📁 CẤU TRÚC FILE

```
KafkaExample/
│
├── 📄 KAFKA_CLUSTER_GUIDE.md          ⭐ Hướng dẫn đầy đủ
├── 📄 QUICKSTART_CLUSTER.md           ⭐ Hướng dẫn nhanh
├── 📄 README_CLUSTER.md               ⭐ File này
│
├── 🐳 docker-compose-cluster.yml      Kafka cluster 3 nodes
├── 🔧 start-cluster.bat               Script khởi động
├── 🔍 check-cluster.bat               Script kiểm tra leader
├── 🛑 stop-leader.bat                 Script test fault tolerance
│
├── 📦 producer-service/               Producer App
│   ├── pom.xml (copy từ producer-service-pom.xml)
│   ├── ProducerServiceApplication.java
│   ├── config/, controller/, model/, service/
│   └── application.properties
│
└── 📦 consumer-service/               Consumer App
    ├── pom.xml (copy từ consumer-service-pom.xml)
    ├── ConsumerServiceApplication.java
    ├── config/, model/, service/
    └── application.properties
```

---

## 🎓 KIẾN THỨC NỀN TẢNG

### **Leader trong Kafka**
- Mỗi partition có 1 leader
- Leader xử lý TẤT CẢ read/write requests
- Followers chỉ replicate data từ leader

### **ISR (In-Sync Replicas)**
- Tập hợp replicas đang đồng bộ với leader
- Min ISR = 2: Cần ít nhất 2 brokers sync để commit
- Nếu ISR < min → Không thể write (để đảm bảo durability)

### **Replication Factor**
- RF = 3: Mỗi partition có 3 copies
- Tăng fault tolerance
- Nếu 1 broker down, vẫn còn 2 copies

### **Fault Tolerance**
- Với RF=3 và min ISR=2:
  - ✅ Chịu được 1 broker down
  - ❌ Không chịu được 2 brokers down cùng lúc

---

## ✅ KẾT LUẬN

### **Câu Hỏi Bài Tập:**
> Dừng máy Kafka leader, kiểm tra xem hệ thống có còn hoạt động bình thường?

### **TRẢ LỜI:**

**✅ CÓ, HỆ THỐNG VẪN HOẠT ĐỘNG BÌNH THƯỜNG!**

**Lý do:**
1. **Kafka cluster có cơ chế Fault Tolerance**
   - Replication Factor = 3 (mỗi partition có 3 bản sao)
   - Min ISR = 2 (cần ít nhất 2 broker sync)

2. **Khi leader down:**
   - Zookeeper phát hiện và trigger leader election
   - Một broker trong ISR được chọn làm leader mới
   - Process diễn ra tự động trong vài giây

3. **Producer và Consumer:**
   - Tự động reconnect tới leader mới
   - Không mất dữ liệu (data đã replicate)
   - Có thể có độ trễ nhỏ trong quá trình rebalance

4. **Giới hạn:**
   - Chỉ chịu được tối đa 1 broker down (vì min ISR = 2)
   - Nếu 2 brokers down → Hệ thống ngừng write

---

## 📞 LIÊN HỆ & HỖ TRỢ

Nếu có vấn đề:
1. Đọc `KAFKA_CLUSTER_GUIDE.md` - Hướng dẫn chi tiết
2. Đọc `QUICKSTART_CLUSTER.md` - Hướng dẫn nhanh
3. Check Docker logs: `docker logs kafka-broker-1`
4. Check Kafka UI: http://localhost:8090

---

**🎉 HOÀN THÀNH BÀI TẬP THÀNH CÔNG!**

Bạn đã:
- ✅ Tạo 2 ứng dụng Spring Boot trao đổi JSON qua Kafka
- ✅ Cấu hình Kafka cluster 3 brokers
- ✅ Kiểm tra leader của các partitions
- ✅ Chứng minh fault tolerance khi dừng leader

