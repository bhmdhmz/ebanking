# Use an official Java 17 image as the base
FROM openjdk:17-alpine

# Set the working directory to /app
WORKDIR /app

# Copy the Maven settings file (if you have one)
COPY .mvn /app/.mvn
COPY mvnw /app/mvnw
COPY pom.xml /app/pom.xml

# Copy the source code
COPY src /app/src

# Install Maven and set the Maven settings
RUN ./mvnw install -DskipTests
RUN ./mvnw dependency:go-offline

# Compile and package the application
RUN ./mvnw package -DskipTests

# Create a new directory for the compiled application
RUN mkdir -p target

# Define the PROJECT_NAME variable
ENV PROJECT_NAME=ebanking

# Move the compiled WAR file to the target directory
RUN mv target/${PROJECT_NAME}-*.war target/app.war

# Expose the port for the Spring Boot application
EXPOSE 8080

# Run the application when the container starts
CMD ["java", "-jar", "target/app.war"]