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
            if (URL == null || USER == null || PASS == null) {
                throw new RuntimeException("❌ Environment variables not set properly!");
            }

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(URL, USER, PASS);

            System.out.println("✅ Database Connected Successfully!");
            return con;

        } catch (ClassNotFoundException e) {
            throw new RuntimeException("❌ MySQL Driver not found!", e);
        } catch (SQLException e) {
            throw new RuntimeException("❌ Database Connection Failed! Check ENV variables.", e);
        }
    }
}