package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import io.github.cdimascio.dotenv.Dotenv;

public class DBConnection {

    // Load .env file. Ignore if missing to fallback to system environment variables (useful for production)
    private static final Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();

    private static final String URL = dotenv.get("DB_URL");
    private static final String USER = dotenv.get("DB_URL") != null ? dotenv.get("DB_USER") : System.getenv("DB_USER"); // dotenv.get falls back to System env internally, but explicit check handles edge cases. Actually Dotenv handles it automatically, but we use dotenv.get() directly. Let's rely on dotenv.get()
    
    // Better to use a getter for dotenv to access other env vars like ADMIN_USER
    public static Dotenv getEnv() {
        return dotenv;
    }

    public static Connection getConnection() {
        String dbUrl = dotenv.get("DB_URL");
        String dbUser = dotenv.get("DB_USER");
        String dbPass = dotenv.get("DB_PASS");

        try {
            if (dbUrl == null || dbUser == null || dbPass == null) {
                throw new RuntimeException("❌ Environment variables not set properly! Please configure DB_URL, DB_USER, DB_PASS in .env or system environment.");
            }

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            return con;

        } catch (ClassNotFoundException e) {
            throw new RuntimeException("❌ MySQL Driver not found!", e);
        } catch (SQLException e) {
            throw new RuntimeException("❌ Database Connection Failed! Check ENV variables.", e);
        }
    }
}