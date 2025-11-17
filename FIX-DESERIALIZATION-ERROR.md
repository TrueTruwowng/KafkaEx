# 🔴 SỬA LỖI DESERIALIZATION

## ❌ LỖI BẠN GẶP:

```
ClassNotFoundException: com.example.producer.model.Order
RecordDeserializationException: Error deserializing key/value
```

## 🎯 NGUYÊN NHÂN:

Producer gửi JSON với **type metadata** (class name từ Producer)
→ Consumer cố tìm class `com.example.producer.model.Order`
→ Không tìm thấy vì Consumer chỉ có `com.example.consumer.model.Order`
→ ❌ Lỗi deserialization!

---

## ✅ GIẢI PHÁP ĐÃ THỰC HIỆN:

### 1. **Sửa Producer Config** ✅
Tắt type info headers:
```java
configProps.put(JsonSerializer.ADD_TYPE_INFO_HEADERS, false);
```

### 2. **Sửa Consumer Config** ✅  
- Thêm `ErrorHandlingDeserializer`
- Tắt `USE_TYPE_INFO_HEADERS`
- Chỉ định class local: `Order.class`

---

## 🚀 CÁCH SỬA (4 BƯỚC):

### **BƯỚC 1: Reset Kafka (Xóa messages cũ)**

```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample
reset-kafka.bat
```

Hoặc thủ công:
```cmd
docker-compose -f docker-compose-cluster.yml down -v
docker-compose -f docker-compose-cluster.yml up -d
```

**Chờ 60 giây!**

---

### **BƯỚC 2: Rebuild Consumer**

```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample\consumer-service
mvn clean install -DskipTests
mvn spring-boot:run
```

Chờ Consumer start thành công.

---

### **BƯỚC 3: Rebuild Producer**

Mở terminal mới:
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample\producer-service
mvn clean install -DskipTests
mvn spring-boot:run
```

Chờ Producer start thành công.

---

### **BƯỚC 4: Test**

```cmd
curl -X POST http://localhost:8081/api/orders/create -H "Content-Type: application/json" -d "{\"customerName\":\"Nguyen Van A\",\"productName\":\"Laptop\",\"quantity\":1,\"totalPrice\":1500}"
```

---

## ✅ KẾT QUẢ MONG ĐỢI:

### **Producer Log:**
```
📤 Sending order to Kafka: ORD-XXXXXXXX
✅ Order sent successfully!
   Partition: 2
   Offset: 0
```

### **Consumer Log:**
```
═══════════════════════════════════════════════════════════
📥 RECEIVED ORDER FROM KAFKA CLUSTER
═══════════════════════════════════════════════════════════
🔹 Order ID: ORD-XXXXXXXX
🔹 Customer: Nguyen Van A
🔹 Product: Laptop
🔹 Quantity: 1
🔹 Total Price: $1500.0
✅ Order ORD-XXXXXXXX processed successfully
```

### **KHÔNG CÒN LỖI:**
- ❌ ClassNotFoundException
- ❌ RecordDeserializationException
- ❌ Consumer restart liên tục

---

## 📝 THAY ĐỔI TRONG CODE:

### **Producer Config:**
```java
// Thêm dòng này
configProps.put(JsonSerializer.ADD_TYPE_INFO_HEADERS, false);
```

### **Consumer Config:**
```java
// Sử dụng ErrorHandlingDeserializer
props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, ErrorHandlingDeserializer.class);
props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ErrorHandlingDeserializer.class);

// Tắt type headers
props.put(JsonDeserializer.USE_TYPE_INFO_HEADERS, false);
props.put(JsonDeserializer.VALUE_DEFAULT_TYPE, Order.class);
```

---

## 💡 TẠI SAO PHẢI RESET KAFKA?

Messages cũ vẫn chứa type metadata `com.example.producer.model.Order`
→ Consumer mới không thể đọc được
→ Phải xóa messages cũ (`down -v`)
→ Gửi messages mới (không có type metadata)
→ Consumer đọc được!

---

## 🎯 CHECKLIST:

- [x] Sửa Producer Config (ADD_TYPE_INFO_HEADERS = false)
- [x] Sửa Consumer Config (ErrorHandlingDeserializer + USE_TYPE_INFO_HEADERS = false)  
- [ ] Reset Kafka (`docker-compose down -v`)
- [ ] Restart Kafka
- [ ] Rebuild Consumer
- [ ] Rebuild Producer
- [ ] Test gửi order mới
- [ ] Kiểm tra Consumer nhận được

---

## ⚠️ LƯU Ý:

1. **Phải reset Kafka** để xóa messages cũ
2. **Rebuild cả 2 services** để áp dụng config mới
3. **Test với messages MỚI** - messages cũ đã bị xóa
4. Kafka UI: http://localhost:8090 để monitor

---

**SAU KHI LÀM THEO 4 BƯỚC TRÊN, HỆ THỐNG SẼ HOẠT ĐỘNG HOÀN HẢO!** ✅

