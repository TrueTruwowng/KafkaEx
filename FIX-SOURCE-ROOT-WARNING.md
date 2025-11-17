# 🔧 SỬA CẢNH BÁO "OUTSIDE OF SOURCE ROOT"

## ⚠️ VẤN ĐỀ:

IntelliJ/IDE báo cảnh báo:
```
Java file is located outside of the module source root, so it won't be compiled
```

## 🎯 NGUYÊN NHÂN:

Có một số files/folders Java đang nằm rải rác ngoài thư mục `src/main/java/`:

**Producer Service:**
```
producer-service/
├── config/              ❌ SAI - ngoài src
├── controller/          ❌ SAI - ngoài src
├── model/               ❌ SAI - ngoài src
├── service/             ❌ SAI - ngoài src
└── src/main/java/com/example/producer/
    ├── config/          ✅ ĐÚNG
    ├── controller/      ✅ ĐÚNG
    ├── model/           ✅ ĐÚNG
    └── service/         ✅ ĐÚNG
```

**Consumer Service:** Tương tự

## ✅ GIẢI PHÁP:

### **Cách 1: Sử dụng Script (NHANH)**

```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample
cleanup-files.bat
```

Script sẽ tự động xóa tất cả files/folders nằm ngoài `src/`.

### **Cách 2: Thủ công**

#### **Producer Service:**
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample\producer-service

rmdir /s /q config
rmdir /s /q controller
rmdir /s /q model
rmdir /s /q service
del application.properties
del ProducerServiceApplication.java
```

#### **Consumer Service:**
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample\consumer-service

rmdir /s /q config
rmdir /s /q model
rmdir /s /q service
del application.properties
del ConsumerServiceApplication.java
```

---

## 📁 CẤU TRÚC ĐÚNG SAU KHI CLEAN:

### **Producer Service:**
```
producer-service/
├── pom.xml                               ✅
├── run-producer.bat                      ✅
└── src/
    └── main/
        ├── java/
        │   └── com/example/producer/
        │       ├── ProducerServiceApplication.java  ✅
        │       ├── config/
        │       │   ├── KafkaProducerConfig.java     ✅
        │       │   └── KafkaTopicConfig.java        ✅
        │       ├── controller/
        │       │   ├── HomeController.java          ✅
        │       │   └── OrderController.java         ✅
        │       ├── model/
        │       │   └── Order.java                   ✅
        │       └── service/
        │           └── OrderProducerService.java    ✅
        └── resources/
            └── application.properties               ✅
```

### **Consumer Service:**
```
consumer-service/
├── pom.xml                               ✅
├── run-consumer.bat                      ✅
└── src/
    └── main/
        ├── java/
        │   └── com/example/consumer/
        │       ├── ConsumerServiceApplication.java  ✅
        │       ├── config/
        │       │   └── KafkaConsumerConfig.java     ✅
        │       ├── controller/
        │       │   └── HomeController.java          ✅
        │       ├── model/
        │       │   └── Order.java                   ✅
        │       └── service/
        │           └── OrderConsumerService.java    ✅
        └── resources/
            └── application.properties               ✅
```

---

## ✅ SAU KHI CLEAN:

1. **Không còn cảnh báo "outside of source root"**
2. **IDE nhận diện đúng source root**
3. **Maven build vẫn hoạt động bình thường**
4. **Services chạy OK**

---

## 🚀 REBUILD SAU KHI CLEAN:

### **Producer:**
```cmd
cd producer-service
mvn clean install -DskipTests
mvn spring-boot:run
```

### **Consumer:**
```cmd
cd consumer-service
mvn clean install -DskipTests
mvn spring-boot:run
```

---

## 💡 TẠI SAO CÓ FILES Ở 2 NƠI?

Ban đầu tôi tạo files trực tiếp trong `producer-service/` và `consumer-service/`, sau đó mới copy vào `src/main/java/`. Files cũ vẫn còn → Cảnh báo!

**Giải pháp:** Xóa files cũ, chỉ giữ files trong `src/main/java/`

---

## ⚠️ LƯU Ý:

- Files trong `src/main/java/` là files CHÍNH
- Files ngoài `src/` chỉ là BẢN SAO cũ
- Xóa files ngoài `src/` không ảnh hưởng gì
- Maven chỉ compile files trong `src/main/java/`

---

## 🎯 CHECKLIST:

- [ ] Chạy `cleanup-files.bat`
- [ ] Kiểm tra không còn cảnh báo trong IDE
- [ ] Rebuild Producer: `mvn clean install`
- [ ] Rebuild Consumer: `mvn clean install`
- [ ] Test services hoạt động

---

**SAU KHI CLEAN UP, HỆ THỐNG VẪN HOẠT ĐỘNG BÌNH THƯỜNG, NHƯNG KHÔNG CÒN CẢNH BÁO!** ✅

