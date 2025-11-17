package com.example.controller;

import com.example.producer.KafkaProducer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/kafka")
@Slf4j
public class KafkaController {

    @Autowired
    private KafkaProducer kafkaProducer;

    @PostMapping("/publish")
    public ResponseEntity<Map<String, String>> publishMessage(@RequestBody Map<String, String> request) {
        String message = request.get("message");

        if (message == null || message.isEmpty()) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", "Message cannot be empty");
            return ResponseEntity.badRequest().body(errorResponse);
        }

        log.info("Received request to publish message: {}", message);
        kafkaProducer.sendMessage(message);

        Map<String, String> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "Message published to Kafka topic");
        response.put("data", message);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/publish-with-key")
    public ResponseEntity<Map<String, String>> publishMessageWithKey(@RequestBody Map<String, String> request) {
        String key = request.get("key");
        String message = request.get("message");

        if (key == null || key.isEmpty() || message == null || message.isEmpty()) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", "Key and message cannot be empty");
            return ResponseEntity.badRequest().body(errorResponse);
        }

        log.info("Received request to publish message with key: {} - {}", key, message);
        kafkaProducer.sendMessageWithKey(key, message);

        Map<String, String> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "Message published to Kafka topic with key");
        response.put("key", key);
        response.put("data", message);

        return ResponseEntity.ok(response);
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "Kafka Producer/Consumer");
        return ResponseEntity.ok(response);
    }
}

