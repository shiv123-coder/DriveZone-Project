package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import db.DBConnection;

public class DeleteEnquiryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("DELETE FROM enquiries WHERE id = ?")) {
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
                response.sendRedirect("admin.jsp?enq_deleted=success");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin.jsp?error=database");
            }
        } else {
            response.sendRedirect("admin.jsp");
        }
    }
}
