package servlet;

import db.DBConnection;
import java.io.*;
import java.sql.*;
import java.util.UUID;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 15     // 15 MB
)
public class UploadServlet extends HttpServlet {

    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp", ".gif"};

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String price = request.getParameter("price");
        String fuel = request.getParameter("fuel_type");
        String description = request.getParameter("description");

        Part filePart = request.getPart("image");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("admin.jsp?error=no_file");
            return;
        }

        String originalFileName = filePart.getSubmittedFileName();
        if (originalFileName == null || originalFileName.isEmpty()) {
            response.sendRedirect("admin.jsp?error=invalid_file");
            return;
        }

        // Validate extension
        String extension = "";
        int i = originalFileName.lastIndexOf('.');
        if (i > 0) {
            extension = originalFileName.substring(i).toLowerCase();
        }

        boolean allowed = false;
        for (String ext : ALLOWED_EXTENSIONS) {
            if (ext.equals(extension)) {
                allowed = true;
                break;
            }
        }

        if (!allowed) {
            response.sendRedirect("admin.jsp?error=invalid_type");
            return;
        }

        // Generate safe unique filename
        String safeFileName = UUID.randomUUID().toString() + extension;

        String uploadPath = getServletContext().getRealPath("/") + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // Write file safely
        filePart.write(uploadPath + File.separator + safeFileName);

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "INSERT INTO cars(brand,model,price,description,image,fuel_type) VALUES(?,?,?,?,?,?)")) {

            ps.setString(1, brand);
            ps.setString(2, model);
            ps.setString(3, price);
            ps.setString(4, description);
            ps.setString(5, "uploads/" + safeFileName); // Store relative path
            ps.setString(6, fuel);

            ps.executeUpdate();
            response.sendRedirect("admin.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=database");
        }
    }
}