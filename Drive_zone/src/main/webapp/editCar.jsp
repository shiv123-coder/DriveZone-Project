<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page session="true" %>

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

<%
    String adminUser = (String) session.getAttribute("user");
    if (adminUser == null || 
       (!"SSP".equalsIgnoreCase(adminUser) && !"admin".equalsIgnoreCase(adminUser))) {
        response.sendRedirect("LogoutServlet");
        return;
    }

    String idParam = request.getParameter("id");
    int carId = 0;

    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("admin.jsp");
        return;
    }

    try {
        carId = Integer.parseInt(idParam);
        if (carId <= 0) {
            response.sendRedirect("admin.jsp");
            return;
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("admin.jsp");
        return;
    }

    String brand = "";
    String model = "";
    String price = "";
    String fuel = "";
    String desc = "";
    boolean carFound = false;

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement("SELECT * FROM cars WHERE id = ?")) {

        ps.setInt(1, carId);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                brand = rs.getString("brand");
                model = rs.getString("model");
                price = rs.getString("price");
                fuel = rs.getString("fuel_type");
                desc = rs.getString("description");
                carFound = true;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (!carFound) {
        response.sendRedirect("admin.jsp");
        return;
    }

    if (brand == null) brand = "";
    if (model == null) model = "";
    if (price == null) price = "";
    if (fuel == null) fuel = "";
    if (desc == null) desc = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AutoLuxe - Edit Vehicle</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<script>
(function () {
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.documentElement.setAttribute('data-theme', savedTheme);
})();
</script>

<style>
  *, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }

  :root {
    --sky: #1a56db;
    --sky-dark: #1341b5;
    --navy: #f8fafc;
    --border: rgba(0,0,0,0.1);
    --muted: #64748b;
    --text: #0f172a;
    --card-bg: rgba(255,255,255,0.88);
    --input-bg: rgba(0,0,0,0.03);
    --input-bg-focus: rgba(0,0,0,0.05);
    --text-strong: #000;
  }

  [data-theme="dark"] {
    --sky: #0ea5e9;
    --sky-dark: #0284c7;
    --navy: #0f172a;
    --border: rgba(255,255,255,0.09);
    --muted: #94a3b8;
    --text: #f1f5f9;
    --card-bg: rgba(17,24,39,0.88);
    --input-bg: rgba(255,255,255,0.04);
    --input-bg-focus: rgba(255,255,255,0.07);
    --text-strong: #fff;
  }

  body {
    font-family:'Poppins',sans-serif;
    background:var(--navy);
    min-height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
    padding:40px 20px;
    position:relative;
    overflow:hidden;
  }

  body::before {
    content:'';
    position:fixed;
    inset:0;
    background:
      radial-gradient(ellipse 60% 50% at 80% 20%, rgba(14,165,233,0.15) 0%, transparent 55%),
      radial-gradient(ellipse 50% 60% at 20% 80%, rgba(2,132,199,0.1) 0%, transparent 55%);
    z-index:0;
  }

  .orb {
    position:fixed;
    border-radius:50%;
    filter:blur(90px);
    z-index:0;
    animation:drift 18s ease-in-out infinite alternate;
  }

  .orb-1 {
    width:400px;
    height:400px;
    background:rgba(14,165,233,0.2);
    top:-160px;
    right:-160px;
  }

  .orb-2 {
    width:350px;
    height:350px;
    background:rgba(2,132,199,0.15);
    bottom:-120px;
    left:-120px;
    animation-delay:-9s;
  }

  @keyframes drift {
    0%   { transform:translate(0,0) scale(1); }
    100% { transform:translate(30px,20px) scale(1.07); }
  }

  .theme-btn {
    position:fixed;
    top:20px;
    right:20px;
    z-index:100;
    width:46px;
    height:46px;
    border-radius:50%;
    border:1px solid var(--border);
    background:var(--card-bg);
    color:var(--text);
    display:flex;
    align-items:center;
    justify-content:center;
    cursor:pointer;
    box-shadow:0 6px 18px rgba(0,0,0,0.12);
  }

  .card {
    position:relative;
    z-index:10;
    width:100%;
    max-width:680px;
    background:var(--card-bg);
    border:1px solid var(--border);
    border-radius:26px;
    padding:44px 48px;
    backdrop-filter:blur(24px);
    box-shadow:0 40px 80px rgba(0,0,0,0.22), 0 0 0 1px rgba(255,255,255,0.04);
    animation:up 0.7s cubic-bezier(0.16,1,0.3,1);
  }

  @keyframes up {
    from { opacity:0; transform:translateY(28px) scale(0.97); }
    to   { opacity:1; transform:translateY(0) scale(1); }
  }

  .back-link {
    display:inline-flex;
    align-items:center;
    gap:7px;
    color:var(--muted);
    font-size:0.82rem;
    text-decoration:none;
    margin-bottom:28px;
    transition:color 0.2s;
  }

  .back-link:hover { color:var(--sky); }

  .card-head { margin-bottom:32px; }

  .card-head span {
    display:inline-block;
    background:rgba(14,165,233,0.12);
    border:1px solid rgba(14,165,233,0.25);
    color:var(--sky);
    border-radius:99px;
    font-size:0.72rem;
    font-weight:700;
    letter-spacing:1px;
    text-transform:uppercase;
    padding:4px 14px;
    margin-bottom:12px;
  }

  .card-head h1 {
    font-size:1.7rem;
    font-weight:700;
    color:var(--text-strong);
    margin-bottom:5px;
  }

  .card-head p {
    color:var(--muted);
    font-size:0.88rem;
  }

  .form-row {
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:18px;
  }

  .fgroup {
    display:flex;
    flex-direction:column;
    gap:7px;
  }

  .fgroup.full { grid-column:1/-1; }

  .fgroup label {
    font-size:0.72rem;
    font-weight:700;
    color:var(--muted);
    text-transform:uppercase;
    letter-spacing:0.5px;
  }

  .fgroup input,
  .fgroup select,
  .fgroup textarea {
    background:var(--input-bg);
    border:1px solid var(--border);
    border-radius:13px;
    padding:13px 16px;
    color:var(--text);
    font-family:'Poppins',sans-serif;
    font-size:0.9rem;
    outline:none;
    transition:all 0.3s;
    width:100%;
  }

  .fgroup input::placeholder,
  .fgroup textarea::placeholder {
    color:var(--muted);
  }

  .fgroup select option {
    background:var(--card-bg);
    color:var(--text);
  }

  .fgroup input:focus,
  .fgroup select:focus,
  .fgroup textarea:focus {
    border-color:var(--sky);
    background:var(--input-bg-focus);
    box-shadow:0 0 0 3px rgba(14,165,233,0.18);
  }

  .fgroup textarea {
    resize:vertical;
    min-height:110px;
  }

  .actions {
    display:flex;
    gap:14px;
    margin-top:28px;
  }

  .btn {
    flex:1;
    padding:14px;
    border-radius:13px;
    border:none;
    font-family:'Poppins',sans-serif;
    font-size:0.92rem;
    font-weight:700;
    cursor:pointer;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    gap:8px;
    text-decoration:none;
    transition:all 0.3s;
  }

  .btn-save {
    background:linear-gradient(135deg, var(--sky), var(--sky-dark));
    color:#fff;
    box-shadow:0 6px 20px rgba(14,165,233,0.35);
  }

  .btn-save:hover {
    transform:translateY(-2px);
    box-shadow:0 10px 28px rgba(14,165,233,0.5);
  }

  .btn-cancel {
    background:var(--input-bg);
    border:1px solid var(--border);
    color:var(--muted);
    flex:0.5;
  }

  .btn-cancel:hover {
    background:var(--input-bg-focus);
    color:var(--text);
  }

  @media (max-width:600px) {
    .card { padding:32px 22px; }
    .form-row { grid-template-columns:1fr; }
    .actions { flex-direction:column; }
  }
</style>
</head>
<body>

<button type="button" class="theme-btn" onclick="toggleTheme()" title="Toggle Theme">
  <i class="fa-solid fa-moon" id="themeIcon"></i>
</button>

<div class="orb orb-1"></div>
<div class="orb orb-2"></div>

<div class="card">
  <a href="admin.jsp" class="back-link">
    <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
  </a>

  <div class="card-head">
    <span><i class="fa-solid fa-pen-to-square"></i> Edit Mode</span>
    <h1>Update Vehicle Details</h1>
    <p>Modifying: <strong style="color:var(--text-strong);"><%= esc(brand) %> <%= esc(model) %></strong></p>
  </div>

  <form action="EditServlet" method="POST">
    <input type="hidden" name="id" value="<%= carId %>">

    <div class="form-row">
      <div class="fgroup">
        <label>Brand Name</label>
        <input type="text" name="brand" value="<%= esc(brand) %>" required>
      </div>

      <div class="fgroup">
        <label>Model Name</label>
        <input type="text" name="model" value="<%= esc(model) %>" required>
      </div>

      <div class="fgroup">
        <label>Price (INR)</label>
        <input type="number" min="1" name="price" value="<%= esc(price) %>" required>
      </div>

      <div class="fgroup">
        <label>Fuel Type</label>
        <select name="fuel_type" required>
          <option value="Petrol" <%= "Petrol".equalsIgnoreCase(fuel) ? "selected" : "" %>>Petrol</option>
          <option value="Diesel" <%= "Diesel".equalsIgnoreCase(fuel) ? "selected" : "" %>>Diesel</option>
          <option value="Electric" <%= "Electric".equalsIgnoreCase(fuel) ? "selected" : "" %>>Electric</option>
          <option value="Hybrid" <%= "Hybrid".equalsIgnoreCase(fuel) ? "selected" : "" %>>Hybrid</option>
          <option value="CNG" <%= "CNG".equalsIgnoreCase(fuel) ? "selected" : "" %>>CNG</option>
        </select>
      </div>

      <div class="fgroup full">
        <label>Vehicle Description</label>
        <textarea name="description" placeholder="Enter vehicle details, features, condition, and highlights..."><%= esc(desc) %></textarea>
      </div>
    </div>

    <div class="actions">
      <a href="admin.jsp" class="btn btn-cancel">
        <i class="fa-solid fa-xmark"></i> Cancel
      </a>

      <button type="submit" class="btn btn-save">
        <i class="fa-solid fa-cloud-arrow-up"></i> Save Changes
      </button>
    </div>
  </form>
</div>

<script>
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
    if (!themeIcon) return;

    if (document.documentElement.getAttribute('data-theme') === 'dark') {
        themeIcon.className = 'fa-solid fa-sun';
    } else {
        themeIcon.className = 'fa-solid fa-moon';
    }
}

document.addEventListener('DOMContentLoaded', updateThemeIcon);
</script>

</body>
</html>