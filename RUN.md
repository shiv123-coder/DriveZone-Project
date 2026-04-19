# Running DriveZone

This guide covers setting up DriveZone in Eclipse using XAMPP for the MySQL database.

## Prerequisites
1.  **Java JDK**: Version 8 or higher.
2.  **Eclipse IDE for Enterprise Java Web Developers**.
3.  **Apache Tomcat**: Version 9 or 10.
4.  **XAMPP**: For MySQL database.
5.  **MySQL Connector/J**: JDBC driver (should be placed in `Drive_zone/src/main/webapp/WEB-INF/lib` if not already present).

## Step 1: Database Setup
1.  Open **XAMPP Control Panel** and start **Apache** and **MySQL**.
2.  Navigate to `http://localhost/phpmyadmin` in your browser.
3.  Create a new database named `test`. (Note: Make sure this matches `DBConnection.java`).
4.  Click on the `test` database, go to the **SQL** tab, and execute the following queries to create the necessary tables:

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255)
);

CREATE TABLE cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(100),
    model VARCHAR(100),
    price DECIMAL(10, 2),
    fuel_type VARCHAR(50),
    description TEXT,
    image_url VARCHAR(255)
);

CREATE TABLE enquiries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    user_name VARCHAR(100),
    user_email VARCHAR(100),
    message TEXT,
    status VARCHAR(20) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE
);
```

## Step 2: Project Import in Eclipse
1.  Open Eclipse.
2.  Go to **File** > **Import** > **General** > **Existing Projects into Workspace**.
3.  Click **Next**.
4.  Browse and select the `Drive_zone` directory from this repository.
5.  Click **Finish**.

## Step 3: Configure Build Path & Server
1.  Right-click the `Drive_zone` project in the Project Explorer -> **Properties** -> **Java Build Path** -> **Libraries**.
2.  If the Apache Tomcat server is missing, click **Add Library** -> **Server Runtime**, select **Apache Tomcat**, and click **Finish**.
3.  Ensure the MySQL JDBC connector jar is present in your build path. (Usually found in `src/main/webapp/WEB-INF/lib`).

## Step 4: Run the Application
1.  Right-click the `Drive_zone` project -> **Run As** -> **Run on Server**.
2.  Select your configured Tomcat server and click **Finish**.
3.  The application will build and open in your default browser at `http://localhost:8080/Drive_zone/home.jsp` (or similar depending on your Tomcat port).

### Important Default Accounts
*   **Admin Access**: Register an account with the username `SSP` or `admin`. Only these users are permitted to access `admin.jsp` and `editCar.jsp`.
