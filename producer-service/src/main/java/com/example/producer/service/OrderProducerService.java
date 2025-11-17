package com.example.producer.service;

import com.example.producer.model.Order;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
@Slf4j
public class OrderProducerService {

    @Value("${kafka.topic.orders}")
    private String ordersTopic;

    @Autowired
    private KafkaTemplate<String, Object> kafkaTemplate;

    public void sendOrder(Order order) {
        log.info("📤 Sending order to Kafka: {}", order.getOrderId());

        CompletableFuture<SendResult<String, Object>> future =
            kafkaTemplate.send(ordersTopic, order.getOrderId(), order);

        future.whenComplete((result, ex) -> {
            if (ex == null) {
                log.info("✅ Order sent successfully!");
                log.info("   Order ID: {}", order.getOrderId());
                log.info("   Topic: {}", result.getRecordMetadata().topic());
                log.info("   Partition: {}", result.getRecordMetadata().partition());
                log.info("   Offset: {}", result.getRecordMetadata().offset());
                log.info("   Timestamp: {}", result.getRecordMetadata().timestamp());
            } else {
                log.error("❌ Failed to send order: {}", ex.getMessage());
            }
        });
    }
}

