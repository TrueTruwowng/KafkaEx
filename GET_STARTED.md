# 🚀 GET STARTED - Read This First!

## ⚠️ IMPORTANT: Kafka is Not Running

You're seeing this error because **Kafka is not running on your computer**:

```
Connection to node -1 (localhost/127.0.0.1:9092) could not be established. 
Broker may not be available.
```

## ✅ Quick Fix (3 Steps)

### Step 1: Start Kafka

**Double-click this file:** `start-kafka.bat`

Choose Option 1 to start Kafka using Docker (easiest way)

OR manually run:
```cmd
docker-compose up -d
```

### Step 2: Wait 30 seconds

Kafka needs time to start up. Wait about 30 seconds.

### Step 3: Restart your Spring Boot application

Now run your application again (skip tests since Kafka needs to be running for tests):
```cmd
mvn spring-boot:run -DskipTests
```

**Or** build and run:
```cmd
mvn clean install -DskipTests
mvn spring-boot:run
```

**That's it!** Your application should now connect successfully.

---

## 📚 What You've Built

This is a **complete Kafka Producer-Consumer application** with:

✅ **REST API** to publish messages  
✅ **Kafka Producer** to send messages to Kafka  
✅ **Kafka Consumer** to automatically receive and process messages  
✅ **Spring Boot 3.2.0** with modern Java 21  
✅ **Docker support** for easy Kafka setup  
✅ **Complete documentation** and examples  

---

## 🎯 Test Your Application

Once Kafka is running and your app is started, open a new terminal:

### Test 1: Health Check
```cmd
curl http://localhost:8080/api/kafka/health
```

### Test 2: Send a Message
```cmd
curl -X POST http://localhost:8080/api/kafka/publish -H "Content-Type: application/json" -d "{\"message\":\"Hello Kafka!\"}"
```

### Test 3: Check the Logs

In your application logs, you should see:

**Producer:**
```
Sending message to Kafka topic: example-topic
Message sent successfully with offset: 0
```

**Consumer:**
```
========================================
Received message from Kafka:
Partition: 0
Offset: 0
Message: Hello Kafka!
========================================
```

---

## 📖 Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Complete documentation |
| `QUICKSTART.md` | Quick start guide |
| `TROUBLESHOOTING.md` | **← Read this if you have errors** |
| `PROJECT_OVERVIEW.md` | Architecture and design |
| `start-kafka.bat` | **← Run this to start Kafka** |
| `run-app.bat` | Helper script for the app |

---

## 🐳 Docker Commands (If Using Docker)

```cmd
# Start Kafka
docker-compose up -d

# Check if running
docker ps

# View logs
docker-compose logs -f kafka

# Stop Kafka
docker-compose down
```

---

## 🔧 Project Structure

```
src/main/java/com/example/
├── Main.java                    # Spring Boot app entry point
├── controller/
│   └── KafkaController.java    # REST API endpoints
├── producer/
│   └── KafkaProducer.java      # Sends messages to Kafka
├── consumer/
│   └── KafkaConsumer.java      # Receives messages from Kafka
├── config/
│   └── KafkaTopicConfig.java   # Topic configuration
└── model/
    └── Message.java             # Message model
```

---

## 🎓 How It Works

```
1. You send HTTP POST → http://localhost:8080/api/kafka/publish
                          ↓
2. KafkaController receives it
                          ↓
3. KafkaProducer publishes to Kafka topic
                          ↓
4. Kafka stores the message
                          ↓
5. KafkaConsumer automatically receives it
                          ↓
6. Consumer processes and logs the message
```

---

## ⚡ Quick Commands

```cmd
# Start Kafka (Docker)
start-kafka.bat

# Start the application (skip tests for now)
mvn spring-boot:run -DskipTests

# Test the API
curl -X POST http://localhost:8080/api/kafka/publish -H "Content-Type: application/json" -d "{\"message\":\"Test\"}"

# Import Postman collection
File: Kafka-Example-API.postman_collection.json
```

---

## 🆘 Still Having Issues?

1. **Make sure Docker is running** (if using Docker)
2. **Check if port 9092 is free**: `netstat -ano | findstr :9092`
3. **Read**: `TROUBLESHOOTING.md`
4. **Verify Java 21 is installed**: `java -version`
5. **Reload Maven dependencies** in your IDE

---

## 📦 Technologies Used

- Java 21
- Spring Boot 3.2.0
- Spring Kafka
- Apache Kafka
- Lombok
- Maven

---

## 🎉 Next Steps

After your app is running successfully:

1. ✅ Try the Postman collection
2. ✅ Modify the consumer to add your business logic
3. ✅ Create additional topics
4. ✅ Add JSON message support
5. ✅ Implement error handling
6. ✅ Add monitoring and metrics

---

## 📞 Summary

**RIGHT NOW YOU NEED TO:**

1. **Run** `start-kafka.bat` to start Kafka
2. **Wait** 30 seconds
3. **Restart** your Spring Boot application

**Then you're ready to go!** 🚀

---

Happy Coding! 💻✨

