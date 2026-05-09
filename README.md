# Research Assistant

Research Assistant is a Chrome Extension with a Spring Boot backend. It lets you select text on a webpage, summarize it with the Google Gemini API, write research notes, and download summaries or notes as text files.

## Features

- Summarize selected text from any webpage
- Generate AI summaries using the Gemini API
- Save research notes in Chrome local storage
- Download notes and summaries as `.txt` files
- Use a Chrome Side Panel interface
- Run the backend with Spring Boot

## Tech Stack

### Chrome Extension

- HTML
- CSS
- JavaScript
- Chrome Extensions API

### Backend

- Java 21+
- Spring Boot 4.x
- Spring Web MVC
- Spring WebClient
- Google Gemini API

## Project Structure

```text
research-assistant/
|-- chrome-extension/
|   |-- background.js
|   |-- image.png
|   |-- manifest.json
|   |-- sidepanel.css
|   |-- sidepanel.html
|   `-- sidepanel.js
|-- scripts/
|   |-- install-startup-task.ps1
|   |-- start-backend.ps1
|   `-- uninstall-startup-task.ps1
|-- src/main/java/com/research/assistant/
|   |-- ResearchAssistantApplication.java
|   |-- ResearchController.java
|   |-- ResearchService.java
|   |-- ResearchRequest.java
|   `-- GeminiResponse.java
|-- src/main/resources/
|   |-- application.properties
|   `-- static/index.html
|-- pom.xml
`-- README.md
```

## Prerequisites

- Java 21 or newer
- Google Chrome
- A Gemini API key

## Backend Setup

Set your Gemini API key as an environment variable.

```powershell
setx GEMINI_API_KEY "your_api_key_here"
```

After setting it, close and reopen PowerShell so the new variable is available.

Build and run the backend manually:

```powershell
.\mvnw.cmd -DskipTests package
java -jar .\target\research-assistant-0.0.1-SNAPSHOT.jar
```

The backend runs at:

```text
http://localhost:8080
```

The Chrome extension sends summarize requests to:

```text
http://localhost:8080/api/research/process
```

## Keep the Backend Running on Windows

The Chrome extension cannot start the Java backend by itself. To make the backend start automatically when you log in to Windows, install the included scheduled task:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-startup-task.ps1
```

This creates a Windows scheduled task named `ResearchAssistantBackend`.

To start the backend manually using the helper script:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start-backend.ps1
```

To remove the startup task:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\uninstall-startup-task.ps1
```

Backend logs are written to:

```text
logs/backend.out.log
logs/backend.err.log
```

## Chrome Extension Setup

1. Open Chrome and go to `chrome://extensions/`.
2. Turn on `Developer mode`.
3. Click `Load unpacked`.
4. Select the `chrome-extension` folder from this project.
5. Pin or open the Research Assistant extension.

Before using summarization, make sure the backend is running on `http://localhost:8080`.

## Usage

1. Select text on any webpage.
2. Open the Research Assistant side panel.
3. Click `Summarize`.
4. Save notes or download the generated summary when needed.

## Verification

Run this command to check that the backend still builds:

```powershell
.\mvnw.cmd -DskipTests package
```

The build should finish with `BUILD SUCCESS`.
