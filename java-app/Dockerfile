###### Stage 1: Build the application ############
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the JAR
RUN mvn clean package -DskipTests

###### Stage 2: Create the runtime image ##########
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/java-health-check-app-0.0.1-SNAPSHOT.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the JAR
ENTRYPOINT ["java", "-jar", "app.jar"]