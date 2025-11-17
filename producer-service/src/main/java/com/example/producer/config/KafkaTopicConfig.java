package com.example.producer.config;

import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.TopicBuilder;

@Configuration
public class KafkaTopicConfig {

    @Bean
    public NewTopic orderTopic() {
        return TopicBuilder.name("orders-topic")
                .partitions(6)  // 6 partitions for better distribution
                .replicas(3)     // 3 replicas for fault tolerance
                .build();
    }
}

