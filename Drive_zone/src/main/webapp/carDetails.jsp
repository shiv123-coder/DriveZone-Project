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
  String carId = request.getParameter("id");
  if(carId == null) {
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
  .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; display: flex; align-items: center; justify-content: space-between; padding: 0 60px; height: 72px; background: var(--nav-bg); border-bottom: 1px solid var(--gray-mid); box-shadow: 0 1px 12px rgba(0,0,0,0.06); }
  .logo { font-size: 1.4rem; font-weight: 800; color: var(--dark); display: flex; align-items: center; gap: 10px; text-decoration: none; }
  .logo-icon { width: 40px; height: 40px; background: linear-gradient(135deg, var(--primary), #3b82f6); border-radius: 10px; display: flex; align-items: center; justify-content: center; color: white; }
  .logo span { color: var(--primary); }
  .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
  .detail-card { background: var(--card-bg); border-radius: 24px; border: 1px solid var(--gray-mid); overflow: hidden; display: flex; box-shadow: var(--card-shadow); }
  .detail-img { flex: 1.2; background: var(--gray-light); position: relative; }
  .detail-img img { width: 100%; height: 100%; object-fit: cover; }
  .detail-info { flex: 1; padding: 48px; }
  .badge-sold { background: #ef4444; color: #fff; padding: 8px 20px; border-radius: 8px; font-weight: 800; font-size: 0.9rem; letter-spacing: 1px; display: inline-block; margin-bottom: 16px; }
  .brand { color: var(--primary); font-weight: 700; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 1.5px; margin-bottom: 8px; }
  .model { font-size: 2.8rem; font-weight: 900; color: var(--dark); margin-bottom: 16px; letter-spacing: -1.5px; line-height: 1.1; }
  .price { font-size: 2rem; font-weight: 800; color: var(--dark); margin-bottom: 24px; }
  .meta-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; margin-bottom: 32px; }
  .meta-item { display: flex; align-items: center; gap: 12px; background: var(--gray-light); padding: 16px; border-radius: 12px; border: 1px solid var(--gray-mid); }
  .meta-item i { color: var(--primary); font-size: 1.1rem; }
  .meta-item span { font-weight: 600; font-size: 0.9rem; }
  .desc { color: var(--gray); line-height: 1.8; font-size: 1rem; margin-bottom: 40px; }
  
  .enquiry-section { background: var(--gray-light); border-radius: 20px; padding: 32px; border: 1.5px solid var(--gray-mid); }
  .enquiry-section h3 { margin-bottom: 20px; font-weight: 800; font-size: 1.2rem; }
  .fgroup { margin-bottom: 16px; }
  .fgroup label { display: block; font-size: 0.8rem; font-weight: 700; color: var(--gray); margin-bottom: 6px; text-transform: uppercase; }
  .fgroup input, .fgroup textarea { width: 100%; padding: 12px 16px; border-radius: 10px; border: 1.5px solid var(--gray-mid); font-family: 'Inter', sans-serif; font-size: 0.9rem; outline: none; transition: border-color 0.2s; background: var(--input-bg); color: var(--text); }
  .fgroup input:focus, .fgroup textarea:focus { border-color: var(--primary); }
  .btn-submit { width: 100%; padding: 14px; background: var(--primary); color: #fff; border: none; border-radius: 10px; font-weight: 700; cursor: pointer; transition: transform 0.2s; }
  .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(26,86,219,0.3); }
  .btn-submit:disabled { background: #d1d5db; cursor: not-allowed; transform: none; }
  
  .back-link { display: inline-flex; align-items: center; gap: 8px; color: var(--gray); text-decoration: none; font-weight: 600; margin-bottom: 24px; transition: color 0.2s; }
  .back-link:hover { color: var(--primary); }
  
  @media (max-width: 900px) {
    .detail-card { flex-direction: column; }
    .detail-info { padding: 32px; }
    .navbar { padding: 0 20px; }
  }
</style>
</head>
<body>
<%@ include file="preloader.jsp" %>

  <nav class="navbar">
    <a class="logo" href="home.jsp">
      <div class="logo-icon"><i class="fa-solid fa-car-side"></i></div>
      Drive<span>Zone</span>
    </a>
    <div style="display:flex; align-items:center; gap:14px;">
      <div class="user-chip" style="font-weight:600; color:var(--primary); background:var(--primary-light); padding:8px 16px; border-radius:30px;">
        <i class="fa-solid fa-circle-user"></i> <%= userName %>
      </div>
      <button onclick="toggleTheme()" title="Toggle Theme" style="background:var(--gray-light); border:none; border-radius:50%; width:40px; height:40px; color:var(--text); cursor:pointer; display:flex; align-items:center; justify-content:center;">
        <i class="fa-solid fa-moon" id="themeIcon"></i>
      </button>
    </div>
  </nav>

  <div class="container">
    <a href="home.jsp" class="back-link"><i class="fa-solid fa-arrow-left"></i> Back to Inventory</a>
    
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
          } catch(Exception ex) { formattedPrice = "₹ " + rawPrice; }
    %>
    <div class="detail-card">
      <div class="detail-img">
        <img src="uploads/<%= esc(rs.getString("image")) %>" alt="<%= esc(rs.getString("brand")) %>"
             onerror="this.src='https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?auto=format&fit=crop&w=800';">
      </div>
      <div class="detail-info">
        <% if(isSold) { %>
          <div class="badge-sold"><i class="fa-solid fa-tag"></i> SOLD</div>
        <% } %>
        <div class="brand"><%= esc(rs.getString("brand")) %></div>
        <div class="model"><%= esc(rs.getString("model")) %></div>
        <div class="price"><%= esc(formattedPrice) %></div>
        
        <div class="meta-grid">
          <div class="meta-item"><i class="fa-solid fa-gas-pump"></i> <span><%= esc(rs.getString("fuel_type")) %></span></div>
          <div class="meta-item"><i class="fa-solid fa-shield-check"></i> <span>Certified</span></div>
          <div class="meta-item"><i class="fa-solid fa-calendar"></i> <span>2026 Edition</span></div>
          <div class="meta-item"><i class="fa-solid fa-road"></i> <span>0-PDI</span></div>
        </div>
        
        <p class="desc"><%= esc(rs.getString("description")) %></p>
        
        <div class="enquiry-section">
          <h3>Enquire About This Vehicle</h3>
          <form action="EnquiryServlet" method="post">
            <input type="hidden" name="car_id" value="<%= esc(carId) %>">
            <div class="fgroup">
              <label>Your Name</label>
              <input type="text" name="name" required placeholder="Full Name">
            </div>
            <div class="fgroup">
              <label>Email Address</label>
              <input type="email" name="email" required placeholder="name@example.com">
            </div>
            <div class="fgroup">
              <label>Additional Message</label>
              <textarea name="message" rows="3" placeholder="I'm interested in this car..."></textarea>
            </div>
            <button type="submit" class="btn-submit" <%= isSold ? "disabled" : "" %>>
              <%= isSold ? "Not Available" : "Book Enquiry" %>
            </button>
          </form>
        </div>
      </div>
    </div>
    <%
        } else {
          out.println("<div style='text-align:center; padding:100px;'><h3>Vehicle not found.</h3></div>");
        }
      } catch(Exception e) {
        out.println("<div style='text-align:center; padding:100px;'><h3>Error loading car details.</h3></div>");
      }
    %>
  </div>

  <script>
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('enquiry_success')) {
      Swal.fire({
        title: 'Enquiry Sent!',
        text: 'Our team will contact you shortly regarding this vehicle.',
        icon: 'success',
        confirmButtonColor: '#1a56db'
      });
    }

    function toggleTheme() {
      const html = document.documentElement;
      const currentTheme = html.getAttribute('data-theme');
      const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
      html.setAttribute('data-theme', newTheme);
      localStorage.setItem('theme', newTheme);
      updateThemeIcon();
    }

    function updateThemeIcon() {
      const themeIcon = document.getElementById('themeIcon');
      if(themeIcon) {
        if(document.documentElement.getAttribute('data-theme') === 'dark') {
          themeIcon.className = 'fa-solid fa-sun';
        } else {
          themeIcon.className = 'fa-solid fa-moon';
        }
      }
    }
    
    // Set initial icon on load
    document.addEventListener('DOMContentLoaded', updateThemeIcon);
  </script>
</body>
</html>
