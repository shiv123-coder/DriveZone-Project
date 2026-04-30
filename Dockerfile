# ==========================================
# Stage 1: Build
# ==========================================
FROM maven:3.8.4-openjdk-11-slim AS build

WORKDIR /app

COPY . .

RUN mvn dependency:go-offline -B
RUN mvn clean package -DskipTests

# ==========================================
# Stage 2: Run
# ==========================================
FROM tomcat:10.1-jdk11

ENV TZ=Asia/Kolkata

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR
COPY --from=build /app/target/DriveZone.war /usr/local/tomcat/webapps/ROOT.war

# Create uploads directory
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/uploads

EXPOSE 8080

CMD ["catalina.sh", "run"]