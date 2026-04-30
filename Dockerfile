# ==========================================
# Stage 1: Build
# ==========================================
FROM maven:3.8.4-openjdk-11-slim AS build

WORKDIR /app

# Cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy full project
COPY . .

# Build WAR
RUN mvn clean package -DskipTests

# ==========================================
# Stage 2: Run
# ==========================================
FROM tomcat:10.1-jdk11

ENV TZ=Asia/Kolkata

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR (not renamed yet)
COPY --from=build /app/target/DriveZone.war /usr/local/tomcat/webapps/

# 🔥 FORCE extraction (CRITICAL FIX)
RUN cd /usr/local/tomcat/webapps && \
    mv DriveZone.war ROOT.war && \
    jar -xf ROOT.war && \
    rm ROOT.war

# Ensure uploads directory exists (for runtime)
RUN mkdir -p /usr/local/tomcat/webapps/uploads

EXPOSE 8080

CMD ["catalina.sh", "run"]