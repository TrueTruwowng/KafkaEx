# Running the Application - Quick Guide

## 🚀 How to Run (Step-by-Step)

### Step 1: Start Kafka

Open a new Command Prompt and run:
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample
docker-compose up -d
```

**Wait 30 seconds** for Kafka to fully start.

### Step 2: Run the Spring Boot Application (Skip Tests)

In another Command Prompt:
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample
mvn spring-boot:run -DskipTests
```

**Or** to build and run:
```cmd
mvn clean install -DskipTests
mvn spring-boot:run
```

### Step 3: Test the Application

In a third Command Prompt:
```cmd
curl -X POST http://localhost:8080/api/kafka/publish -H "Content-Type: application/json" -d "{\"message\":\"Hello Kafka!\"}"
```

---

## 💡 Why Skip Tests?

The tests require Kafka to be running, so we skip them during the build. To run tests properly:

1. Start Kafka first
2. Then run: `mvn test`

---

## ✅ Expected Success Output

When the application starts successfully, you'll see:

```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.2.0)

Started Main in X.XXX seconds (JVM running for X.XXX)
```

---

## 🧪 Testing the Producer-Consumer Flow

### Test 1: Simple Message
```cmd
curl -X POST http://localhost:8080/api/kafka/publish ^
  -H "Content-Type: application/json" ^
  -d "{\"message\":\"Test message 1\"}"
```

**Expected in logs:**
```
INFO  c.e.producer.KafkaProducer - Sending message to Kafka topic: example-topic
INFO  c.e.producer.KafkaProducer - Message content: Test message 1
INFO  c.e.producer.KafkaProducer - Message sent successfully with offset: 0

INFO  c.e.consumer.KafkaConsumer - ========================================
INFO  c.e.consumer.KafkaConsumer - Received message from Kafka:
INFO  c.e.consumer.KafkaConsumer - Partition: 0
INFO  c.e.consumer.KafkaConsumer - Offset: 0
INFO  c.e.consumer.KafkaConsumer - Message: Test message 1
INFO  c.e.consumer.KafkaConsumer - ========================================
```

### Test 2: Message with Key
```cmd
curl -X POST http://localhost:8080/api/kafka/publish-with-key ^
  -H "Content-Type: application/json" ^
  -d "{\"key\":\"order-123\",\"message\":\"Order placed successfully\"}"
```

### Test 3: Health Check
```cmd
curl http://localhost:8080/api/kafka/health
```

**Expected response:**
```json
{
  "status": "UP",
  "service": "Kafka Producer/Consumer"
}
```

---

## 🛑 Stopping Everything

### Stop Spring Boot
Press `Ctrl+C` in the terminal running the application

### Stop Kafka
```cmd
docker-compose down
```

---

## 🔍 Useful Commands

### Check Kafka is running:
```cmd
docker ps
```

### View Kafka logs:
```cmd
docker-compose logs -f kafka
```

### View application logs in real-time:
The logs appear in the terminal where you ran `mvn spring-boot:run`

### List Kafka topics:
```cmd
docker exec -it kafkaexample-kafka-1 kafka-topics --bootstrap-server localhost:9092 --list
```

### Read messages from topic:
```cmd
docker exec -it kafkaexample-kafka-1 kafka-console-consumer --bootstrap-server localhost:9092 --topic example-topic --from-beginning
```

---

## ⚠️ Common Issues

### Issue: "Connection refused" or "Broker may not be available"
**Solution:** Kafka is not running. Start it with `docker-compose up -d`

### Issue: "Port 8080 already in use"
**Solution:** Change the port in `src/main/resources/application.properties`:
```properties
server.port=8081
```

### Issue: "Failed to execute goal... testCompile"
**Solution:** Skip tests with `-DskipTests`:
```cmd
mvn spring-boot:run -DskipTests
```

### Issue: Docker not found
**Solution:** Install Docker Desktop from https://www.docker.com/products/docker-desktop/

---

## 📊 Full Workflow Example

```cmd
# Terminal 1: Start Kafka
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample
docker-compose up -d

# Wait 30 seconds...

# Terminal 2: Start Application
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample
mvn spring-boot:run -DskipTests

# Wait for app to start...

# Terminal 3: Send Test Messages
curl -X POST http://localhost:8080/api/kafka/publish -H "Content-Type: application/json" -d "{\"message\":\"Message 1\"}"
curl -X POST http://localhost:8080/api/kafka/publish -H "Content-Type: application/json" -d "{\"message\":\"Message 2\"}"
curl -X POST http://localhost:8080/api/kafka/publish -H "Content-Type: application/json" -d "{\"message\":\"Message 3\"}"

# Watch the logs in Terminal 2 - you'll see messages being produced and consumed!
```

---

## 🎉 Success Indicators

You'll know everything is working when:

✅ Kafka containers are running (`docker ps` shows 2 containers)  
✅ Spring Boot app starts without errors  
✅ You can access http://localhost:8080/api/kafka/health  
✅ When you send a message, you see it in both producer AND consumer logs  
✅ No connection errors in the logs  

---

**Happy Coding!** 🚀

