package com.research.assistant;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

@Service
public class ResearchService {

    @Value("${gemini.api.url}")
    private String geminiApiUrl;

    @Value("${gemini.api.key}")
    private String geminiApiKey;

    private final WebClient webClient;

    public ResearchService(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.build();
    }

    public String processContent(ResearchRequest request) {

        String prompt = buildPrompt(request);

        Map<String, Object> requestBody = Map.of(
            "contents", List.of(
                Map.of("parts", List.of(
                    Map.of("text", prompt)
                ))
            )
        );

        Map response = webClient.post()
            .uri(geminiApiUrl + "?key=" + geminiApiKey)
            .bodyValue(requestBody)
            .retrieve()
            .bodyToMono(Map.class)
            .block();

        return extractText(response);
    }

    private String extractText(Map response) {
        try {
            List<Map> candidates = (List<Map>) response.get("candidates");
            Map content = (Map) candidates.get(0).get("content");
            List<Map> parts = (List<Map>) content.get("parts");
            return parts.get(0).get("text").toString();
        } catch (Exception e) {
            return "Failed to parse Gemini response";
        }
    }

    private String buildPrompt(ResearchRequest request) {

        String prefix;

        switch (request.getOperation()) {
            case "summarize":
                prefix = "Summarize the following content:\n";
                break;
            case "analyze":
                prefix = "Analyze the following content:\n";
                break;
            case "extract keywords":
                prefix = "Extract keywords from:\n";
                break;
            case "suggest references":
                prefix = "Suggest references for:\n";
                break;
            default:
                throw new IllegalArgumentException("Unsupported operation");
        }

        return prefix + request.getContent();
    }
}
