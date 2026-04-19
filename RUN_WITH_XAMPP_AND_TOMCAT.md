# Running the Java Web Project with XAMPP and Eclipse Tomcat

This application is a Java Web Application (JSP/Servlets). **It cannot be hosted on XAMPP Apache.** It must be hosted on Apache Tomcat (via Eclipse). However, **XAMPP is used for the MySQL Database.**

Follow these steps to run the project correctly:

## 1. Start the Database (XAMPP)
1. Open the **XAMPP Control Panel**.
2. Start the **MySQL** module by clicking the `Start` button next to it.
   > [!IMPORTANT]
   > Do **NOT** start the Apache module in XAMPP. XAMPP Apache is only for PHP projects. You do not need it for this Java project.
3. Open your browser and navigate to `http://localhost/phpmyadmin` (If you didn't start Apache, you can access your database using a desktop tool like MySQL Workbench or HeidiSQL. If you prefer to use phpMyAdmin, you *may* start Apache in XAMPP just to access the DB interface, but the Java app itself will run on Tomcat).

## 2. Setup the Database
1. Go to your MySQL client (phpMyAdmin, MySQL Workbench, etc.).
2. Open the `setup_instructions.sql` file provided in the project root.
3. Copy all the contents from the `.sql` file.
4. Execute the SQL queries to create the `car_management` database and required tables.

## 3. Verify Database Credentials
By default, the application is configured to connect to standard XAMPP MySQL. 
Verify the credentials in `Drive_zone/src/main/java/db/DBConnection.java`:
```java
private static final String URL = "jdbc:mysql://localhost:3306/car_management";
private static final String USER = "root";
private static final String PASS = ""; // XAMPP default has no password
```

## 4. Run the Application (Eclipse Tomcat)
1. Open **Eclipse IDE**.
2. Ensure the `Drive_zone` project is loaded in your workspace.
3. Right-click the `Drive_zone` project folder in Eclipse -> `Run As` -> `Run on Server`.
4. Select your **Tomcat Server** and click **Finish**.
5. The application will start and automatically open in your browser, typically at:
   `http://localhost:8080/Drive_zone/` (or whichever port Tomcat is configured to use).
