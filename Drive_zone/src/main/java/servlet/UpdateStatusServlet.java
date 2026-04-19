package servlet;

import db.DBConnection;
import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class UpdateStatusServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String enquiryIdStr = request.getParameter("id");
        String status = request.getParameter("status");

        if (enquiryIdStr == null || status == null) {
            response.sendRedirect("admin.jsp?error=missing_id");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "UPDATE enquiries SET status = ? WHERE id = ?")) {

            ps.setString(1, status);
            ps.setInt(2, Integer.parseInt(enquiryIdStr));

            ps.executeUpdate();
            
            response.sendRedirect("admin.jsp?updated=true");
        } catch(Exception e){
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=true");
        }
    }
}
