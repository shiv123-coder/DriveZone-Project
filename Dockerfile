# ==========================================
# Stage 1: Build
# ==========================================
FROM maven:3.8.4-openjdk-11-slim AS build

WORKDIR /app

# Step 1: Copy only pom.xml (cache dependencies)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Step 2: Copy full project (forces rebuild if code changes)
COPY . .

# Step 3: Clean + build fresh WAR (NO CACHE ISSUE)
RUN mvn clean package -DskipTests

# ==========================================
# Stage 2: Run
# ==========================================
FROM tomcat:10.1-jdk11

ENV TZ=Asia/Kolkata

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy fresh WAR
COPY --from=build /app/target/DriveZone.war /usr/local/tomcat/webapps/ROOT.war

# Ensure uploads directory exists
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/uploads

EXPOSE 8080

CMD ["catalina.sh", "run"]