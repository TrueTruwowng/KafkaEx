package com.example.producer;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
@Slf4j
public class KafkaProducer {

    @Value("${kafka.topic.name}")
    private String topicName;

    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    public void sendMessage(String message) {
        log.info("Sending message to Kafka topic: {}", topicName);
        log.info("Message content: {}", message);

        CompletableFuture<SendResult<String, String>> future = kafkaTemplate.send(topicName, message);

        future.whenComplete((result, ex) -> {
            if (ex == null) {
                log.info("Message sent successfully with offset: {}", result.getRecordMetadata().offset());
            } else {
                log.error("Failed to send message: {}", ex.getMessage());
            }
        });
    }

    public void sendMessageWithKey(String key, String message) {
        log.info("Sending message with key to Kafka topic: {}", topicName);
        log.info("Key: {}, Message: {}", key, message);

        CompletableFuture<SendResult<String, String>> future = kafkaTemplate.send(topicName, key, message);

        future.whenComplete((result, ex) -> {
            if (ex == null) {
                log.info("Message sent successfully with offset: {}", result.getRecordMetadata().offset());
            } else {
                log.error("Failed to send message: {}", ex.getMessage());
            }
        });
    }
}

