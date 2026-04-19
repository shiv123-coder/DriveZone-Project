package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class EditServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String price = request.getParameter("price");
        String fuel = request.getParameter("fuel_type");
        String description = request.getParameter("description");

        if (idStr != null) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                    "UPDATE cars SET brand=?, model=?, price=?, fuel_type=?, description=? WHERE id=?")) {
                
                ps.setString(1, brand);
                ps.setString(2, model);
                ps.setString(3, price);
                ps.setString(4, fuel);
                ps.setString(5, description);
                ps.setInt(6, Integer.parseInt(idStr));
                
                ps.executeUpdate();
                response.sendRedirect("admin.jsp?updated=true");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin.jsp?error=true");
            }
        }
    }
}
