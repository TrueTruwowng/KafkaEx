# Troubleshooting Guide

## Error: "Connection to node -1 (localhost/127.0.0.1:9092) could not be established. Broker may not be available."

### Problem
The Spring Boot application cannot connect to Kafka broker because Kafka is not running.

### Solution

You have **3 options** to fix this:

---

## Option 1: Start Kafka Using Docker (EASIEST - RECOMMENDED)

### Prerequisites
- Install Docker Desktop for Windows from https://www.docker.com/products/docker-desktop/

### Steps

1. **Start Docker Desktop** (if not already running)

2. **Open Command Prompt** in the project directory:
```cmd
cd E:\StudyDoc\NAM3\PTUDDN\KafkaExample
```

3. **Start Kafka and Zookeeper using Docker Compose**:
```cmd
docker-compose up -d
```

4. **Verify Kafka is running**:
```cmd
docker ps
```
You should see two containers running: `cp-kafka` and `cp-zookeeper`

5. **Now restart your Spring Boot application**

6. **To stop Kafka later**:
```cmd
docker-compose down
```

---

## Option 2: Install and Run Kafka Locally

### Download and Install

1. **Download Kafka** from https://kafka.apache.org/downloads
   - Download the latest binary (e.g., `kafka_2.13-3.6.0.tgz`)

2. **Extract to a directory** (e.g., `C:\kafka`)

### Start Kafka

**Open TWO Command Prompt windows:**

**Terminal 1 - Start Zookeeper:**
```cmd
cd C:\kafka
.\bin\windows\zookeeper-server-start.bat .\config\zookeeper.properties
```

**Terminal 2 - Start Kafka Server:**
```cmd
cd C:\kafka
.\bin\windows\kafka-server-start.bat .\config\server.properties
```

**Keep both terminals running!**

### Now restart your Spring Boot application

---

## Option 3: Run Application Without Kafka (For Development)

If you just want to test the application structure without actually running Kafka:

### Disable Kafka Auto-Configuration

Update `src/main/resources/application.properties`:

```properties
# Disable Kafka auto-configuration
spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.kafka.KafkaAutoConfiguration
```

**Note:** This will disable all Kafka functionality, but the application will start.

---

## Verification Steps

### Check if Kafka is Running

**Using Docker:**
```cmd
docker ps
```
Should show containers for Kafka and Zookeeper

**Using netstat (for local installation):**
```cmd
netstat -ano | findstr :9092
```
Should show something listening on port 9092

### Test Kafka Connection

**List topics:**
```cmd
# Docker
docker exec -it kafkaexample-kafka-1 kafka-topics --bootstrap-server localhost:9092 --list

# Local installation
cd C:\kafka
.\bin\windows\kafka-topics.bat --bootstrap-server localhost:9092 --list
```

---

## Common Issues

### Issue: Docker containers won't start
**Solution:** 
- Make sure Docker Desktop is running
- Check if ports 9092 and 2181 are not already in use
- Try: `docker-compose down` then `docker-compose up -d`

### Issue: Port 9092 already in use
**Solution:** 
- Check what's using the port: `netstat -ano | findstr :9092`
- Kill that process or change the Kafka port in `application.properties`

### Issue: "Cannot resolve symbol 'springframework'" errors
**Solution:**
- Maven dependencies need to be downloaded
- In IntelliJ IDEA: Right-click `pom.xml` → Maven → Reload Project
- Or run: `mvn clean install`

---

## Quick Start Checklist

Before running the Spring Boot application, ensure:

- [ ] Kafka is installed (Docker or local)
- [ ] Zookeeper is running (if using local installation)
- [ ] Kafka broker is running
- [ ] Port 9092 is accessible
- [ ] Maven dependencies are downloaded

---

## Recommended Approach

For beginners, we recommend **Option 1 (Docker)** because:
- ✅ Easy setup (one command)
- ✅ No complex configuration
- ✅ Easy to start/stop
- ✅ Isolated environment
- ✅ Same configuration across all machines

---

## Need Help?

If you still face issues:

1. Check Docker/Kafka logs
2. Verify firewall settings
3. Ensure Java 21 is installed
4. Check if antivirus is blocking ports

---

**Once Kafka is running, restart your Spring Boot application and the error will be gone!**

