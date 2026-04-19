package servlet;

import db.DBConnection;
import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

@MultipartConfig
public class UploadServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String price = request.getParameter("price");
        String fuel = request.getParameter("fuel_type");
        String description = request.getParameter("description");

        Part filePart = request.getPart("image");
        String fileName = filePart.getSubmittedFileName();

        String uploadPath = getServletContext().getRealPath("/") + "uploads";
        File uploadDir = new File(uploadPath);

        if(!uploadDir.exists()) uploadDir.mkdir();

        filePart.write(uploadPath + File.separator + fileName);

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "INSERT INTO cars(brand,model,price,description,image,fuel_type) VALUES(?,?,?,?,?,?)")) {

            ps.setString(1, brand);
            ps.setString(2, model);
            ps.setString(3, price);
            ps.setString(4, description);
            ps.setString(5, fileName);
            ps.setString(6, fuel);

            ps.executeUpdate();
            response.sendRedirect("admin.jsp?success=true");
        } catch(Exception e){
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=true");
        }
    }
}