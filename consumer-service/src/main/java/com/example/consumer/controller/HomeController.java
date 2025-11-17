package com.example.consumer.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
public class HomeController {

    @GetMapping("/")
    @ResponseBody
    public Map<String, Object> home() {
        Map<String, Object> response = new HashMap<>();
        response.put("service", "Consumer Service");
        response.put("status", "Running");
        response.put("port", 8082);
        response.put("description", "This service automatically consumes orders from Kafka topic: orders-topic");
        response.put("consumerGroup", "order-consumer-group");
        response.put("note", "Check the console logs to see consumed messages");
        return response;
    }
}

