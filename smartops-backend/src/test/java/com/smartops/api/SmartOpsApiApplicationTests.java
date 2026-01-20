package com.smartops.api;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class SmartOpsApiApplicationTests {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    void contextLoads() {
        // Verifies the Spring application context starts
    }

    @Test
    void statusEndpointReturnsCorrectMessage() {
        String body = this.restTemplate.getForObject("/api/status", String.class);
        assertThat(body).contains("Caprivax SmartOps API");
    }
}
