package com.example.producer.controller;

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
        response.put("service", "Producer Service");
        response.put("status", "Running");
        response.put("port", 8081);
        response.put("endpoints", new String[]{
            "GET  /api/orders/health - Health check",
            "POST /api/orders/create - Create order"
        });
        response.put("example", Map.of(
            "method", "POST",
            "url", "http://localhost:8081/api/orders/create",
            "body", Map.of(
                "customerName", "Nguyen Van A",
                "productName", "Laptop",
                "quantity", 1,
                "totalPrice", 1500
            )
        ));
        return response;
    }
}

