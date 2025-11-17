package com.example.consumer;

import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class KafkaConsumer {

    @KafkaListener(topics = "${kafka.topic.name}", groupId = "${spring.kafka.consumer.group-id}")
    public void consume(@Payload String message,
                        @Header(KafkaHeaders.RECEIVED_PARTITION) int partition,
                        @Header(KafkaHeaders.OFFSET) long offset) {
        log.info("========================================");
        log.info("Received message from Kafka:");
        log.info("Partition: {}", partition);
        log.info("Offset: {}", offset);
        log.info("Message: {}", message);
        log.info("========================================");

        // Process the message here
        processMessage(message);
    }

    private void processMessage(String message) {
        // Add your business logic here
        log.info("Processing message: {}", message);
        // Example: Save to database, trigger another service, etc.
    }
}

