# ==========================================
# Stage 1: Build
# ==========================================
FROM maven:3.8.4-openjdk-11-slim AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY . .

RUN mvn clean package -DskipTests

# ==========================================
# Stage 2: Run
# ==========================================
FROM tomcat:10.1-jdk11

ENV TZ=Asia/Kolkata

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR as ROOT
COPY --from=build /app/target/DriveZone.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]