# Kafka Producer-Consumer Application

## 📋 Project Overview

This is a complete Spring Boot application demonstrating Kafka Producer and Consumer interaction. The application provides RESTful APIs to publish messages to Kafka topics and automatically consumes them using Spring Kafka.

## 🏗️ Architecture

```
┌─────────────┐      HTTP POST      ┌──────────────────┐
│   Client    │ ──────────────────> │ KafkaController  │
│ (Postman/   │                     │   (REST API)     │
│  cURL/etc)  │ <────────────────── │                  │
└─────────────┘      Response       └──────────────────┘
                                             │
                                             ▼
                                    ┌──────────────────┐
                                    │  KafkaProducer   │
                                    │                  │
                                    └──────────────────┘
                                             │
                                             ▼ publish
                                    ┌──────────────────┐
                                    │  Kafka Broker    │
                                    │  (Topic: example)│
                                    └──────────────────┘
                                             │
                                             ▼ consume
                                    ┌──────────────────┐
                                    │  KafkaConsumer   │
                                    │  (@Listener)     │
                                    └──────────────────┘
```

## 📁 Project Structure

```
KafkaExample/
├── src/
│   ├── main/
│   │   ├── java/com/example/
│   │   │   ├── Main.java                      # Spring Boot Application Entry Point
│   │   │   ├── config/
│   │   │   │   └── KafkaTopicConfig.java      # Kafka Topic Configuration
│   │   │   ├── controller/
│   │   │   │   └── KafkaController.java       # REST API Controllers
│   │   │   ├── producer/
│   │   │   │   └── KafkaProducer.java         # Kafka Message Producer
│   │   │   ├── consumer/
│   │   │   │   └── KafkaConsumer.java         # Kafka Message Consumer
│   │   │   └── model/
│   │   │       └── Message.java                # Message Model
│   │   └── resources/
│   │       ├── application.properties          # Configuration File
│   │       └── application.yml.example         # YAML Config Example
│   └── test/
│       └── java/com/example/
│           └── KafkaExampleApplicationTests.java
├── pom.xml                                     # Maven Dependencies
├── docker-compose.yml                          # Docker Setup for Kafka
├── run-app.bat                                 # Windows Helper Script
├── README.md                                   # Full Documentation
├── QUICKSTART.md                               # Quick Start Guide
├── Kafka-Example-API.postman_collection.json  # Postman Collection
└── .gitignore                                  # Git Ignore Rules
```

## 🔧 Key Components

### 1. KafkaController
- **Endpoint**: `/api/kafka/publish` - Publishes simple messages
- **Endpoint**: `/api/kafka/publish-with-key` - Publishes messages with keys
- **Endpoint**: `/api/kafka/health` - Health check

### 2. KafkaProducer
- Sends messages to Kafka topics
- Supports both simple messages and key-value pairs
- Provides async callback for message delivery status

### 3. KafkaConsumer
- Listens to Kafka topics using `@KafkaListener`
- Automatically processes incoming messages
- Logs partition, offset, and message details

### 4. KafkaTopicConfig
- Auto-creates Kafka topics on startup
- Configures partitions and replication factor

## 🚀 Quick Commands

```bash
# Build project
mvn clean install

# Run application
mvn spring-boot:run

# Start Kafka with Docker
docker-compose up -d

# Stop Kafka
docker-compose down

# Test with cURL
curl -X POST http://localhost:8080/api/kafka/publish \
  -H "Content-Type: application/json" \
  -d "{\"message\":\"Hello Kafka!\"}"
```

## 📊 Configuration Properties

| Property | Default Value | Description |
|----------|---------------|-------------|
| `server.port` | 8080 | Application port |
| `spring.kafka.bootstrap-servers` | localhost:9092 | Kafka broker address |
| `kafka.topic.name` | example-topic | Kafka topic name |
| `spring.kafka.consumer.group-id` | kafka-example-group | Consumer group ID |

## 🔍 Message Flow

1. **Client sends HTTP POST** to `/api/kafka/publish` with JSON body
2. **Controller validates** the request
3. **Producer publishes** message to Kafka topic
4. **Kafka stores** the message in the topic
5. **Consumer automatically receives** the message
6. **Consumer processes** and logs the message

## 🎯 Use Cases

- **Event-Driven Architecture**: Decouple services using async messaging
- **Log Aggregation**: Collect logs from multiple sources
- **Real-time Analytics**: Stream processing of events
- **Notification System**: Send notifications asynchronously
- **Data Pipeline**: ETL and data integration

## 🛡️ Best Practices Implemented

✅ Separation of concerns (Controller, Producer, Consumer)  
✅ Configuration externalization  
✅ Proper error handling  
✅ Logging with SLF4J  
✅ Async message processing  
✅ Docker support for easy setup  
✅ API documentation  

## 📦 Dependencies

- **Spring Boot 3.2.0**: Application framework
- **Spring Kafka**: Kafka integration
- **Lombok**: Boilerplate code reduction
- **Spring Web**: REST API support

## 🔗 Useful Links

- [Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [Spring Kafka Documentation](https://spring.io/projects/spring-kafka)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)

## 📝 Development Notes

### Adding JSON Support
To send JSON objects instead of strings, update the serializers:

```properties
spring.kafka.producer.value-serializer=org.springframework.kafka.support.serializer.JsonSerializer
spring.kafka.consumer.value-deserializer=org.springframework.kafka.support.serializer.JsonDeserializer
spring.kafka.consumer.properties.spring.json.trusted.packages=*
```

### Multiple Topics
Create additional beans in `KafkaTopicConfig`:

```java
@Bean
public NewTopic notificationTopic() {
    return TopicBuilder.name("notification-topic")
        .partitions(3)
        .replicas(1)
        .build();
}
```

### Error Handling
Add error handler to consumer:

```java
@KafkaListener(topics = "${kafka.topic.name}", 
               groupId = "${spring.kafka.consumer.group-id}",
               errorHandler = "kafkaListenerErrorHandler")
```

## 🤝 Contributing

Feel free to enhance this project by:
- Adding more complex message types
- Implementing batch processing
- Adding monitoring and metrics
- Implementing retry mechanisms
- Adding integration tests

## 📄 License

This is an educational project - free to use and modify.

---

**Happy Coding!** 🎉

