# Kafka Example - Spring Boot Application

This is a Spring Boot application that demonstrates Producer-Consumer interaction using Apache Kafka.

## Features

- **Kafka Producer**: Sends messages to Kafka topics
- **Kafka Consumer**: Consumes messages from Kafka topics
- **REST API**: HTTP endpoints to publish messages
- **Spring Boot**: Modern Spring Boot 3.2.0 application
- **Lombok**: Reduced boilerplate code

## Prerequisites

Before running this application, make sure you have:

1. **Java 21** installed
2. **Maven** installed
3. **Apache Kafka** installed and running

## Setting up Kafka

### Windows

1. Download Apache Kafka from https://kafka.apache.org/downloads
2. Extract the archive to a directory (e.g., `C:\kafka`)
3. Open two command prompts

**Start Zookeeper (Terminal 1):**
```cmd
cd C:\kafka
bin\windows\zookeeper-server-start.bat config\zookeeper.properties
```

**Start Kafka Server (Terminal 2):**
```cmd
cd C:\kafka
bin\windows\kafka-server-start.bat config\server.properties
```

### Linux/Mac

**Start Zookeeper (Terminal 1):**
```bash
cd /path/to/kafka
bin/zookeeper-server-start.sh config/zookeeper.properties
```

**Start Kafka Server (Terminal 2):**
```bash
cd /path/to/kafka
bin/kafka-server-start.sh config/server.properties
```

## Running the Application

1. **Build the project:**
```cmd
mvn clean install
```

2. **Run the Spring Boot application:**
```cmd
mvn spring-boot:run
```

The application will start on `http://localhost:8080`

## API Endpoints

### 1. Health Check
**GET** `http://localhost:8080/api/kafka/health`

Response:
```json
{
  "status": "UP",
  "service": "Kafka Producer/Consumer"
}
```

### 2. Publish Message
**POST** `http://localhost:8080/api/kafka/publish`

Request Body:
```json
{
  "message": "Hello, Kafka!"
}
```

Response:
```json
{
  "status": "success",
  "message": "Message published to Kafka topic",
  "data": "Hello, Kafka!"
}
```

### 3. Publish Message with Key
**POST** `http://localhost:8080/api/kafka/publish-with-key`

Request Body:
```json
{
  "key": "message-key-1",
  "message": "Hello, Kafka with key!"
}
```

Response:
```json
{
  "status": "success",
  "message": "Message published to Kafka topic with key",
  "key": "message-key-1",
  "data": "Hello, Kafka with key!"
}
```

## Testing with cURL

### Publish a simple message:
```cmd
curl -X POST http://localhost:8080/api/kafka/publish -H "Content-Type: application/json" -d "{\"message\":\"Hello from cURL!\"}"
```

### Publish a message with key:
```cmd
curl -X POST http://localhost:8080/api/kafka/publish-with-key -H "Content-Type: application/json" -d "{\"key\":\"test-key\",\"message\":\"Hello with key!\"}"
```

## Testing with Postman

1. Open Postman
2. Create a new POST request to `http://localhost:8080/api/kafka/publish`
3. Set Headers: `Content-Type: application/json`
4. Set Body (raw JSON):
```json
{
  "message": "Test message from Postman"
}
```
5. Click Send

## Application Configuration

The application configuration is in `src/main/resources/application.properties`:

```properties
# Server configuration
server.port=8080

# Kafka configuration
spring.kafka.bootstrap-servers=localhost:9092

# Topic name
kafka.topic.name=example-topic
```

You can modify these settings as needed.

## Project Structure

```
src/main/java/com/example/
├── Main.java                          # Spring Boot main application
├── config/
│   └── KafkaTopicConfig.java         # Kafka topic configuration
├── controller/
│   └── KafkaController.java          # REST API endpoints
├── producer/
│   └── KafkaProducer.java            # Kafka message producer
├── consumer/
│   └── KafkaConsumer.java            # Kafka message consumer
└── model/
    └── Message.java                   # Message model
```

## How It Works

1. When you send a POST request to `/api/kafka/publish`, the controller receives it
2. The controller calls the `KafkaProducer` to send the message to Kafka
3. The message is published to the `example-topic` Kafka topic
4. The `KafkaConsumer` listens to the topic and automatically receives the message
5. The consumer processes and logs the received message

## Viewing Logs

When you publish a message, you'll see logs like:

**Producer logs:**
```
Sending message to Kafka topic: example-topic
Message content: Hello, Kafka!
Message sent successfully with offset: 0
```

**Consumer logs:**
```
========================================
Received message from Kafka:
Partition: 0
Offset: 0
Message: Hello, Kafka!
========================================
Processing message: Hello, Kafka!
```

## Troubleshooting

1. **Connection refused**: Make sure Kafka and Zookeeper are running
2. **Port already in use**: Change the server port in `application.properties`
3. **Topic not found**: The topic will be auto-created on first use

## Dependencies

- Spring Boot 3.2.0
- Spring Kafka
- Lombok
- Spring Web

## License

This is a sample project for educational purposes.

