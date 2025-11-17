package com.example.consumer.service;

import com.example.consumer.model.Order;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@Slf4j
public class OrderConsumerService {

    @KafkaListener(
            topics = "${kafka.topic.orders}",
            groupId = "${spring.kafka.consumer.group-id}",
            containerFactory = "kafkaListenerContainerFactory"
    )
    public void consumeOrder(
            @Payload Order order,
            @Header(KafkaHeaders.RECEIVED_PARTITION) int partition,
            @Header(KafkaHeaders.OFFSET) long offset,
            @Header(KafkaHeaders.RECEIVED_TOPIC) String topic) {

        log.info("═══════════════════════════════════════════════════════════");
        log.info("📥 RECEIVED ORDER FROM KAFKA CLUSTER");
        log.info("═══════════════════════════════════════════════════════════");
        log.info("🔹 Order ID: {}", order.getOrderId());
        log.info("🔹 Customer: {}", order.getCustomerName());
        log.info("🔹 Product: {}", order.getProductName());
        log.info("🔹 Quantity: {}", order.getQuantity());
        log.info("🔹 Total Price: ${}", order.getTotalPrice());
        log.info("🔹 Status: {}", order.getStatus());
        log.info("───────────────────────────────────────────────────────────");
        log.info("📊 Kafka Metadata:");
        log.info("   Topic: {}", topic);
        log.info("   Partition: {}", partition);
        log.info("   Offset: {}", offset);
        log.info("═══════════════════════════════════════════════════════════");

        // Process the order
        processOrder(order);
    }

    private void processOrder(Order order) {
        log.info("⚙️  Processing order: {}", order.getOrderId());

        try {
            // Simulate processing time
            Thread.sleep(1000);

            // Update order status
            order.setStatus("PROCESSED");

            log.info("✅ Order {} processed successfully at {}",
                    order.getOrderId(), LocalDateTime.now());

        } catch (InterruptedException e) {
            log.error("❌ Error processing order {}: {}", order.getOrderId(), e.getMessage());
            order.setStatus("FAILED");
        }
    }
}

