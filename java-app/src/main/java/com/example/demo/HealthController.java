
package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import java.util.Map;

@RestController
public class HealthController {

    @Autowired
    private DatabaseHealthChecker dbHealthChecker;

    @GetMapping("/health")
    public Map<String, String> healthCheck() {
        Map<String, String> status = new HashMap<>();
        status.put("status", "UP");
        return status;
    }

    @GetMapping("/db-health")
    public Map<String, String> dbHealthCheck() {
        Map<String, String> status = new HashMap<>();
        if (dbHealthChecker.isDatabaseUp()) {
            status.put("db-status", "UP");
        } else {
            status.put("db-status", "DOWN");
        }
        return status;
    }
}
