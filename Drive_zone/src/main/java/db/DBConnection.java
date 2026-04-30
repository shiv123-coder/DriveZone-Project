package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = System.getenv("DB_URL");
    private static final String USER = System.getenv("DB_USER");
    private static final String PASS = System.getenv("DB_PASS");

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("✅ Database Connected Successfully!");
            return con;

        } catch (ClassNotFoundException e) {
            System.err.println("❌ Driver Error: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("❌ DB Error: " + e.getMessage());
            System.err.println("URL: " + URL);
            System.err.println("USER: " + USER);
        }
        return null;
    }
}