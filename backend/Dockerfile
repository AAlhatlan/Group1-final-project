# Backend Dockerfile (Spring Boot)
# Multi-stage: build with Maven, run on JRE image

FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /workspace

# Copy pom first to utilize layer caching for dependencies
COPY backend/pom.xml ./pom.xml
RUN mvn -B -ntp -q -e -DskipTests dependency:go-offline || true

# Copy source and build
COPY backend/src ./src
RUN mvn -B -ntp -DskipTests package

FROM eclipse-temurin:21-jre AS runtime
WORKDIR /app

# Copy the built jar
COPY --from=build /workspace/target/*.jar /app/app.jar

# Default Spring Boot port
EXPOSE 8080

ENTRYPOINT ["java","-jar","/app/app.jar"]

