# Quick Start Guide - Kafka Example

## Step-by-Step Setup

### 1. Install Prerequisites
- Install Java 21 (JDK)
- Install Maven
- Install Docker (optional, for easy Kafka setup)

### 2. Start Kafka

#### Option A: Using Docker (Recommended)
```cmd
docker-compose up -d
```

#### Option B: Manual Installation
Download Kafka from https://kafka.apache.org/downloads

**Terminal 1 - Start Zookeeper:**
```cmd
cd C:\kafka
bin\windows\zookeeper-server-start.bat config\zookeeper.properties
```

**Terminal 2 - Start Kafka:**
```cmd
cd C:\kafka
bin\windows\kafka-server-start.bat config\server.properties
```

### 3. Build the Project
```cmd
mvn clean install
```

### 4. Run the Application
```cmd
mvn spring-boot:run
```

Or use the provided batch file:
```cmd
run-app.bat
```

### 5. Test the Application

#### Using cURL:
```cmd
curl -X POST http://localhost:8080/api/kafka/publish -H "Content-Type: application/json" -d "{\"message\":\"Hello Kafka!\"}"
```

#### Using Postman:
1. Import `Kafka-Example-API.postman_collection.json`
2. Send requests from the collection

#### Check Health:
```cmd
curl http://localhost:8080/api/kafka/health
```

## Expected Output

### Producer Log:
```
Sending message to Kafka topic: example-topic
Message content: Hello Kafka!
Message sent successfully with offset: 0
```

### Consumer Log:
```
========================================
Received message from Kafka:
Partition: 0
Offset: 0
Message: Hello Kafka!
========================================
Processing message: Hello Kafka!
```

## Common Commands

### View Kafka Topics:
```cmd
# Windows
bin\windows\kafka-topics.bat --bootstrap-server localhost:9092 --list

# Linux/Mac
bin/kafka-topics.sh --bootstrap-server localhost:9092 --list
```

### View Messages in Topic:
```cmd
# Windows
bin\windows\kafka-console-consumer.bat --bootstrap-server localhost:9092 --topic example-topic --from-beginning

# Linux/Mac
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic example-topic --from-beginning
```

### Produce Messages Manually:
```cmd
# Windows
bin\windows\kafka-console-producer.bat --bootstrap-server localhost:9092 --topic example-topic

# Linux/Mac
bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic example-topic
```

## Troubleshooting

### Problem: "Cannot connect to Kafka"
**Solution:** Make sure Kafka and Zookeeper are running

### Problem: "Port 8080 already in use"
**Solution:** Change port in `application.properties`:
```properties
server.port=8081
```

### Problem: "Dependencies not found"
**Solution:** Run Maven install:
```cmd
mvn clean install -U
```

## Next Steps

1. Modify the `KafkaConsumer.java` to add your business logic
2. Add JSON serialization for complex objects
3. Implement error handling and retry mechanisms
4. Add monitoring and metrics
5. Configure multiple topics for different message types

Happy Coding! 🚀

