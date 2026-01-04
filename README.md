# Research Assistant 🧠📄

A **Chrome Extension + Spring Boot backend** project that allows users to **summarize selected text**, **take research notes**, and **save summaries/notes** using **Google Gemini API**.

---

## 🚀 Features

- 🔍 Select text on any webpage and summarize it
- ✨ AI-powered summarization using **Gemini API**
- 📝 Take and save research notes
- 💾 Download notes and summaries as files
- ⚙️ Spring Boot REST API backend
- 🧩 Chrome Side Panel Extension UI

---

## 🛠 Tech Stack

### Frontend (Chrome Extension)
- HTML
- CSS
- JavaScript (Chrome Extensions API)

### Backend
- Java 21+
- Spring Boot 4.x
- Spring Web / WebClient
- Google Gemini API

---

## 📂 Project Structure

research-assistant/
│
├── src/main/java/com/research/assistant
│ ├── ResearchAssistantApplication.java
│ ├── ResearchController.java
│ ├── ResearchService.java
│ ├── ResearchRequest.java
│ └── GeminiResponse.java
│
├── src/main/resources
│ └── application.properties
│
├── chrome-extension/          
│   ├── manifest.json
│   ├── sidepanel.html
│   ├── sidepanel.js
│   ├── sidepanel.css
│   └── icons/
├── pom.xml
└── README.md


## ⚙️ Backend Setup (Spring Boot)

### 1️⃣ Configure Environment Variables

Set your **Gemini API key** (recommended):

**Windows (PowerShell):**
```powershell
setx GEMINI_API_KEY "your_api_key_here"
