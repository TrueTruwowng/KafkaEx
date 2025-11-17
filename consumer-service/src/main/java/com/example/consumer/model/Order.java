package com.example.consumer.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Order {
    private String orderId;
    private String customerName;
    private String productName;
    private int quantity;
    private double totalPrice;
    private LocalDateTime orderDate;
    private String status;
}

