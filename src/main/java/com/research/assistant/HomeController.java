<<<<<<< HEAD
package com.research.assistant;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "Research Assistant Backend is running successfully 🚀";
    }
}
=======
package com.research.assistant;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "Research Assistant Backend is running successfully 🚀";
    }
}
>>>>>>> 41f91ae (Add home endpoint)
