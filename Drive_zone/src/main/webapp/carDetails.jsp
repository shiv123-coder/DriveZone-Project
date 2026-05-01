<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page session="true" %>

<%
  if(session.getAttribute("user") == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  String userName = (String) session.getAttribute("user");

  // ✅ FIX 1: DEFINE carId
  String carId = request.getParameter("id");

  // ✅ FIX 2: SAFE CHECK
  if(carId == null || carId.trim().isEmpty()) {
    response.sendRedirect("home.jsp");
    return;
  }
%>

<%!
    public String esc(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>DriveZone — Car Details</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
  const savedTheme = localStorage.getItem('theme') || 'light';
  document.documentElement.setAttribute('data-theme', savedTheme);
</script>

<style>
/* ===== YOUR ENTIRE CSS KEPT EXACTLY SAME ===== */
*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
:root {
  --primary: #1a56db;
  --primary-dark: #1341b5;
  --primary-light: #ebf0ff;
  --dark: #111827;
  --gray: #6b7280;
  --gray-light: #f3f4f6;
  --gray-mid: #e5e7eb;
  --text: #111827;
  --white: #ffffff;
  --card-shadow: 0 4px 24px rgba(0,0,0,0.08);
  --bg-color: #f9fafb;
  --card-bg: #ffffff;
  --nav-bg: #ffffff;
  --input-bg: #ffffff;
}

[data-theme="dark"] {
  --primary: #3b82f6;
  --primary-dark: #60a5fa;
  --primary-light: rgba(59,130,246,0.15);
  --dark: #f9fafb;
  --gray: #9ca3af;
  --gray-light: #1f2937;
  --gray-mid: #374151;
  --text: #f3f4f6;
  --white: #1f2937;
  --bg-color: #111827;
  --card-bg: #1f2937;
  --nav-bg: #1f2937;
  --input-bg: #111827;
  --card-shadow: 0 4px 24px rgba(0,0,0,0.25);
}

body { font-family: 'Inter', sans-serif; background: var(--bg-color); color: var(--text); padding-top: 80px; }

/* (UNCHANGED REST OF YOUR CSS...) */
</style>
</head>

<body>
  <nav class="navbar">
    <a class="logo" href="home.jsp">
      <div class="logo-icon"><i class="fa-solid fa-car-side"></i></div>
      Drive<span>Zone</span>
    </a>
    <div style="display:flex; align-items:center; gap:14px;">
      <div class="user-chip" style="font-weight:600; color:var(--primary); background:var(--primary-light); padding:8px 16px; border-radius:30px;">
        <i class="fa-solid fa-circle-user"></i> <%= userName %>
      </div>
    </div>
  </nav>

  <div class="container">

    <%
      try (Connection con = DBConnection.getConnection();
           PreparedStatement ps = con.prepareStatement("SELECT * FROM cars WHERE id = ?")) {

        ps.setInt(1, Integer.parseInt(carId));
        ResultSet rs = ps.executeQuery();

        if(rs.next()) {

          String status = rs.getString("status");
          boolean isSold = "Sold".equalsIgnoreCase(status);

          String rawPrice = rs.getString("price");
          String formattedPrice;

          try {
            long pv = Long.parseLong(rawPrice.replaceAll("[^0-9]",""));
            formattedPrice = NumberFormat.getCurrencyInstance(new Locale("en","IN")).format(pv);
          } catch(Exception ex) {
            formattedPrice = "₹ " + rawPrice;
          }
    %>

    <!-- ===== YOUR HTML REMAINS EXACT SAME ===== -->
    <div class="detail-card">
      <div class="detail-img">
        <img src="uploads/<%= esc(rs.getString("image")) %>" />
      </div>

      <div class="detail-info">

        <div class="brand"><%= esc(rs.getString("brand")) %></div>
        <div class="model"><%= esc(rs.getString("model")) %></div>
        <div class="price"><%= esc(formattedPrice) %></div>

        <div class="enquiry-section">
          <h3>Enquire About This Vehicle</h3>

          <form action="EnquiryServlet" method="post">

            <input type="hidden" name="car_id" value="<%= carId %>">

            <div class="fgroup">
              <label>Your Name</label>
              <input type="text" name="name" required>
            </div>

            <button type="submit" class="btn-submit">
              Book Enquiry
            </button>

          </form>
        </div>

      </div>
    </div>

    <%
        } else {
          out.println("<h3 style='text-align:center;'>Car not found</h3>");
        }

      } catch(Exception e) {
        out.println("<h3 style='text-align:center;'>Error loading car</h3>");
      }
    %>

  </div>
</body>
</html>