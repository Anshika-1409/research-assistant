# Use official Java 21 runtime
FROM eclipse-temurin:21-jre

# Set working directory
WORKDIR /app

# Copy jar
COPY target/*.jar app.jar

# Expose port (Render uses PORT env)
EXPOSE 8080

# Start app
ENTRYPOINT ["java","-jar","/app/app.jar"]
