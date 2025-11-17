package com.example.producer.controller;

import com.example.producer.model.Order;
import com.example.producer.service.OrderProducerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/orders")
@Slf4j
public class OrderController {

    @Autowired
    private OrderProducerService orderProducerService;

    @PostMapping("/create")
    public ResponseEntity<Map<String, Object>> createOrder(@RequestBody Order order) {
        log.info("📝 Received order creation request: {}", order.getCustomerName());

        // Set order ID and date if not provided
        if (order.getOrderId() == null || order.getOrderId().isEmpty()) {
            order.setOrderId("ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        }
        if (order.getOrderDate() == null) {
            order.setOrderDate(LocalDateTime.now());
        }
        if (order.getStatus() == null || order.getStatus().isEmpty()) {
            order.setStatus("PENDING");
        }

        // Send to Kafka
        orderProducerService.sendOrder(order);

        Map<String, Object> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "Order created and sent to processing queue");
        response.put("orderId", order.getOrderId());
        response.put("timestamp", LocalDateTime.now());

        return ResponseEntity.ok(response);
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "Producer Service");
        response.put("port", "8081");
        return ResponseEntity.ok(response);
    }
}

