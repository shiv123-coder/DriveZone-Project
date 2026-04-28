# =========================
# Build Stage
# =========================
FROM maven:3.8.4-openjdk-11 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests


# =========================
# Runtime Stage
# =========================
FROM tomcat:10.1-jdk11

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy WAR
COPY --from=build /app/target/DriveZone.war /usr/local/tomcat/webapps/ROOT.war

# Fix timezone (important for DB apps)
RUN apt-get update && apt-get install -y tzdata

ENV TZ=Asia/Kolkata

EXPOSE 8080

CMD ["catalina.sh", "run"]