FROM tomcat:10.1-jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

# Copy ONLY your project folder
COPY Drive_zone/src/main/webapp /usr/local/tomcat/webapps/ROOT

EXPOSE 8080

CMD ["catalina.sh", "run"]