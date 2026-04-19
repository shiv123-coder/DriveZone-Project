package servlet;

import db.DBConnection;
import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class EnquiryServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String carIdStr = request.getParameter("car_id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        if (carIdStr == null || name == null || email == null) {
            response.sendRedirect("home.jsp?error=missing_data");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "INSERT INTO enquiries(car_id, user_name, user_email, message) VALUES(?,?,?,?)")) {

            ps.setInt(1, Integer.parseInt(carIdStr));
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, message != null ? message : "");

            ps.executeUpdate();
            
            // Redirect back to details page with success
            response.sendRedirect("carDetails.jsp?id=" + carIdStr + "&enquiry_success=true");
        } catch(Exception e){
            e.printStackTrace();
            response.sendRedirect("carDetails.jsp?id=" + carIdStr + "&error=true");
        }
    }
}
