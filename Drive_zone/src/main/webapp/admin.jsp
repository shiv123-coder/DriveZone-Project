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

    public String safe(String value, String fallback) {
        if (value == null || value.trim().isEmpty()) return fallback;
        return value;
    }
%>

<%
    String adminUser = (String) session.getAttribute("user");
    if (adminUser == null || 
       (!"SSP".equalsIgnoreCase(adminUser) && !"admin".equalsIgnoreCase(adminUser))) {
        response.sendRedirect("LogoutServlet");
        return;
    }

    int totalCars = 0;
    int totalEnquiries = 0;
    int pendingEnquiries = 0;
    int activeListings = 0;

    try (Connection conStat = DBConnection.getConnection();
         Statement stStat = conStat.createStatement()) {

        try (ResultSet rsStat = stStat.executeQuery("SELECT COUNT(*) FROM cars")) {
            if (rsStat.next()) {
                totalCars = rsStat.getInt(1);
                activeListings = totalCars;
            }
        }

        try (ResultSet rsStat = stStat.executeQuery("SELECT COUNT(*) FROM enquiries")) {
            if (rsStat.next()) {
                totalEnquiries = rsStat.getInt(1);
            }
        }

        try (ResultSet rsStat = stStat.executeQuery("SELECT COUNT(*) FROM enquiries WHERE status='Pending'")) {
            if (rsStat.next()) {
                pendingEnquiries = rsStat.getInt(1);
            }
        }

    } catch (Exception eStat) {
        eStat.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>DriveZone - Admin Dashboard</title>
<meta name="description" content="DriveZone admin panel to manage vehicle inventory.">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="icon" type="image/svg+xml" href="favicon.svg">

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
(function () {
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.documentElement.setAttribute('data-theme', savedTheme);
})();
</script>

<style>
  *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

  :root {
    --primary: #1a56db;
    --primary-dark: #1341b5;
    --primary-light: #ebf0ff;
    --sidebar-bg: #0d1117;
    --sidebar-border: rgba(255,255,255,0.06);
    --sidebar-active-bg: rgba(26,86,219,0.15);
    --sidebar-active-border: rgba(26,86,219,0.4);
    --main-bg: #f3f4f6;
    --card-bg: #ffffff;
    --border: #e5e7eb;
    --dark: #111827;
    --gray: #6b7280;
    --gray-light: #f9fafb;
    --muted: #9ca3af;
    --text: #111827;
    --success: #059669;
    --warning: #d97706;
    --danger: #dc2626;
  }

  [data-theme="dark"] {
    --primary: #3b82f6;
    --primary-dark: #60a5fa;
    --primary-light: rgba(59,130,246,0.15);
    --sidebar-bg: #030712;
    --main-bg: #111827;
    --card-bg: #1f2937;
    --border: #374151;
    --dark: #f9fafb;
    --gray: #9ca3af;
    --gray-light: #374151;
    --muted: #9ca3af;
    --text: #f3f4f6;
  }

  body {
    font-family: 'Inter', sans-serif;
    background: var(--main-bg);
    color: var(--text);
    display: flex;
    height: 100vh;
    overflow: hidden;
  }

  .sidebar {
    width: 260px;
    flex-shrink: 0;
    background: var(--sidebar-bg);
    border-right: 1px solid var(--sidebar-border);
    display: flex;
    flex-direction: column;
    padding: 24px 16px;
    position: relative;
    z-index: 10;
  }

  .sidebar-logo {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 36px;
    padding: 0 8px;
    text-decoration: none;
  }

  .logo-icon {
    width: 38px;
    height: 38px;
    background: linear-gradient(135deg, var(--primary), #3b82f6);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1rem;
    flex-shrink: 0;
  }

  .logo-text {
    font-size: 1.2rem;
    font-weight: 800;
    color: #fff;
    letter-spacing: -0.5px;
  }

  .logo-text span { color: #60a5fa; }

  .sidebar-section-label {
    font-size: 0.65rem;
    font-weight: 700;
    color: rgba(255,255,255,0.2);
    letter-spacing: 1.5px;
    text-transform: uppercase;
    padding: 0 12px;
    margin-bottom: 8px;
    margin-top: 24px;
  }

  .nav-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 11px 14px;
    border-radius: 10px;
    color: rgba(255,255,255,0.45);
    text-decoration: none;
    font-size: 0.875rem;
    font-weight: 500;
    transition: all 0.2s;
    margin-bottom: 2px;
    cursor: pointer;
    border: 1px solid transparent;
    background: transparent;
    width: 100%;
    text-align: left;
    font-family: 'Inter', sans-serif;
  }

  .nav-item:hover {
    background: rgba(255,255,255,0.05);
    color: rgba(255,255,255,0.8);
    border-color: rgba(255,255,255,0.06);
  }

  .nav-item.active {
    background: var(--sidebar-active-bg);
    color: #60a5fa;
    border-color: var(--sidebar-active-border);
  }

  .nav-item.active .nav-icon { color: #60a5fa; }

  .nav-icon {
    width: 18px;
    text-align: center;
    font-size: 0.9rem;
    flex-shrink: 0;
    color: rgba(255,255,255,0.3);
    transition: color 0.2s;
  }

  .nav-item:hover .nav-icon { color: rgba(255,255,255,0.7); }

  .nav-badge {
    margin-left: auto;
    background: rgba(26,86,219,0.25);
    color: #60a5fa;
    border-radius: 99px;
    font-size: 0.65rem;
    font-weight: 700;
    padding: 2px 8px;
    border: 1px solid rgba(96,165,250,0.2);
  }

  .sidebar-spacer { flex: 1; }

  .sidebar-user {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 14px;
    background: rgba(255,255,255,0.04);
    border-radius: 12px;
    border: 1px solid var(--sidebar-border);
    margin-bottom: 10px;
  }

  .user-avatar {
    width: 38px;
    height: 38px;
    background: linear-gradient(135deg, var(--primary), #3b82f6);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 0.85rem;
    font-weight: 700;
    flex-shrink: 0;
  }

  .user-info { overflow: hidden; }

  .user-name {
    font-size: 0.85rem;
    font-weight: 600;
    color: #fff;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .user-role {
    font-size: 0.72rem;
    color: rgba(255,255,255,0.35);
  }

  .logout-link {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 11px 14px;
    border-radius: 10px;
    background: rgba(220,38,38,0.08);
    border: 1px solid rgba(220,38,38,0.15);
    color: #f87171;
    text-decoration: none;
    font-size: 0.875rem;
    font-weight: 600;
    transition: all 0.2s;
    width: 100%;
  }

  .logout-link:hover {
    background: rgba(220,38,38,0.18);
    border-color: rgba(220,38,38,0.3);
  }

  .main {
    flex: 1;
    overflow-y: auto;
    display: flex;
    flex-direction: column;
  }

  .topbar {
    background: var(--card-bg);
    border-bottom: 1px solid var(--border);
    padding: 0 36px;
    height: 68px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-shrink: 0;
    position: sticky;
    top: 0;
    z-index: 100;
  }

  .topbar-left {
    display: flex;
    flex-direction: column;
  }

  .topbar-title {
    font-size: 1.15rem;
    font-weight: 700;
    color: var(--dark);
  }

  .topbar-sub {
    font-size: 0.78rem;
    color: var(--muted);
    margin-top: 2px;
  }

  .topbar-right {
    display: flex;
    align-items: center;
    gap: 12px;
  }

  .topbar-chip {
    display: flex;
    align-items: center;
    gap: 8px;
    background: var(--gray-light);
    border: 1px solid var(--border);
    border-radius: 10px;
    padding: 8px 16px;
    font-size: 0.82rem;
    color: var(--gray);
    font-weight: 500;
  }

  .topbar-chip i { color: var(--primary); }

  .topbar-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    background: linear-gradient(135deg, var(--primary), var(--primary-dark));
    color: #fff;
    border: none;
    border-radius: 10px;
    padding: 10px 20px;
    font-family: 'Inter', sans-serif;
    font-size: 0.85rem;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.2s;
    box-shadow: 0 4px 14px rgba(26,86,219,0.3);
  }

  .topbar-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 20px rgba(26,86,219,0.4);
  }

  .content {
    flex: 1;
    padding: 32px 36px;
  }

  .stats-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;
    margin-bottom: 28px;
  }

  .stat-card {
    background: var(--card-bg);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 22px;
    display: flex;
    align-items: center;
    gap: 16px;
    transition: all 0.25s;
    position: relative;
    overflow: hidden;
  }

  .stat-card::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 4px;
    height: 100%;
    border-radius: 4px 0 0 4px;
  }

  .stat-card.blue::after { background: var(--primary); }
  .stat-card.green::after { background: var(--success); }
  .stat-card.amber::after { background: var(--warning); }
  .stat-card.violet::after { background: #7c3aed; }

  .stat-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
  }

  .stat-icon {
    width: 52px;
    height: 52px;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.3rem;
    flex-shrink: 0;
  }

  .icon-blue   { background: #eff6ff; color: var(--primary); }
  .icon-green  { background: #ecfdf5; color: var(--success); }
  .icon-amber  { background: #fffbeb; color: var(--warning); }
  .icon-violet { background: #f5f3ff; color: #7c3aed; }

  .stat-info { flex: 1; }

  .stat-num {
    font-size: 1.75rem;
    font-weight: 800;
    color: var(--dark);
    line-height: 1;
    margin-bottom: 4px;
  }

  .stat-lbl {
    font-size: 0.78rem;
    color: var(--muted);
    font-weight: 500;
  }

  .stat-trend {
    display: flex;
    align-items: center;
    gap: 4px;
    font-size: 0.72rem;
    font-weight: 600;
    color: var(--success);
    background: #ecfdf5;
    border-radius: 99px;
    padding: 3px 8px;
    margin-left: auto;
    align-self: flex-start;
  }

  .panel {
    background: var(--card-bg);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 28px;
    margin-bottom: 24px;
  }

  .panel-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 24px;
    padding-bottom: 18px;
    border-bottom: 1px solid var(--border);
  }

  .panel-title-wrap {
    display: flex;
    align-items: center;
    gap: 10px;
  }

  .panel-title-icon {
    width: 36px;
    height: 36px;
    background: var(--primary-light);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--primary);
    font-size: 0.9rem;
  }

  .panel-title {
    font-size: 1rem;
    font-weight: 700;
    color: var(--dark);
  }

  .panel-subtitle {
    font-size: 0.78rem;
    color: var(--muted);
    font-weight: 400;
  }

  .form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
  }

  .fgroup {
    display: flex;
    flex-direction: column;
    gap: 7px;
  }

  .fgroup.full { grid-column: 1 / -1; }

  .fgroup label {
    font-size: 0.78rem;
    font-weight: 600;
    color: var(--gray);
    letter-spacing: 0.2px;
  }

  .fgroup input,
  .fgroup select,
  .fgroup textarea {
    background: var(--gray-light);
    border: 1.5px solid var(--border);
    border-radius: 10px;
    padding: 11px 14px;
    color: var(--text);
    font-family: 'Inter', sans-serif;
    font-size: 0.9rem;
    outline: none;
    transition: all 0.2s;
    width: 100%;
  }

  .fgroup input::placeholder,
  .fgroup textarea::placeholder { color: var(--muted); }

  .fgroup select option {
    background: #fff;
    color: #111827;
  }

  .fgroup input:focus,
  .fgroup select:focus,
  .fgroup textarea:focus {
    background: #fff;
    border-color: var(--primary);
    box-shadow: 0 0 0 3px rgba(26,86,219,0.1);
  }

  .fgroup textarea {
    resize: vertical;
    min-height: 100px;
  }

  .fgroup input[type="file"] {
    padding: 9px 14px;
    cursor: pointer;
    color: var(--gray);
  }

  .form-actions {
    margin-top: 24px;
    display: flex;
    gap: 12px;
    align-items: center;
  }

  .btn-publish {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    background: linear-gradient(135deg, var(--primary), var(--primary-dark));
    color: #fff;
    border: none;
    border-radius: 12px;
    padding: 13px 28px;
    font-family: 'Inter', sans-serif;
    font-size: 0.9rem;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.25s;
    box-shadow: 0 4px 16px rgba(26,86,219,0.35);
  }

  .btn-publish:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(26,86,219,0.45);
  }

  .btn-reset {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: transparent;
    border: 1.5px solid var(--border);
    border-radius: 12px;
    padding: 13px 22px;
    font-family: 'Inter', sans-serif;
    font-size: 0.9rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
    color: var(--gray);
  }

  .btn-reset:hover { background: var(--gray-light); }

  .table-toolbar {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;
  }

  .table-search {
    flex: 1;
    max-width: 320px;
    position: relative;
  }

  .table-search i {
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--muted);
    font-size: 0.85rem;
  }

  .table-search input {
    width: 100%;
    padding: 10px 14px 10px 38px;
    background: var(--gray-light);
    border: 1.5px solid var(--border);
    border-radius: 10px;
    font-family: 'Inter', sans-serif;
    font-size: 0.88rem;
    outline: none;
    color: var(--text);
    transition: all 0.2s;
  }

  .table-search input:focus {
    border-color: var(--primary);
    background: #fff;
    box-shadow: 0 0 0 3px rgba(26,86,219,0.1);
  }

  .table-search input::placeholder { color: var(--muted); }

  .table-wrap { overflow-x: auto; }

  table {
    width: 100%;
    border-collapse: collapse;
  }

  thead tr {
    background: var(--gray-light);
    border-radius: 10px;
  }

  th {
    padding: 12px 16px;
    text-align: left;
    color: var(--gray);
    font-size: 0.73rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.8px;
    white-space: nowrap;
    border-bottom: 1px solid var(--border);
  }

  th:first-child { border-radius: 10px 0 0 10px; }
  th:last-child { border-radius: 0 10px 10px 0; }

  td {
    padding: 14px 16px;
    font-size: 0.875rem;
    color: var(--gray);
    vertical-align: middle;
    border-bottom: 1px solid var(--border);
    transition: background 0.15s;
  }

  tbody tr:hover td { background: #f9fafb; }
  tbody tr:last-child td { border-bottom: none; }

  .table-thumb {
    width: 72px;
    height: 46px;
    object-fit: cover;
    border-radius: 8px;
    border: 1px solid var(--border);
  }

  .car-name {
    font-weight: 700;
    color: var(--dark);
  }

  .car-brand-badge {
    display: inline-block;
    font-size: 0.68rem;
    font-weight: 700;
    color: var(--primary);
    background: var(--primary-light);
    padding: 2px 8px;
    border-radius: 4px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 3px;
  }

  .price-text {
    font-weight: 700;
    color: var(--dark);
    font-size: 0.88rem;
  }

  .fuel-pill {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    padding: 5px 12px;
    border-radius: 99px;
    font-size: 0.72rem;
    font-weight: 700;
    white-space: nowrap;
  }

  .pill-petrol   { background: #fffbeb; color: #d97706; border: 1.5px solid #fde68a; }
  .pill-diesel   { background: #eef2ff; color: #4f46e5; border: 1.5px solid #c7d2fe; }
  .pill-electric { background: #ecfdf5; color: #059669; border: 1.5px solid #a7f3d0; }
  .pill-cng      { background: #eff6ff; color: #2563eb; border: 1.5px solid #bfdbfe; }
  .pill-default  { background: #f3f4f6; color: #6b7280; border: 1.5px solid #e5e7eb; }

  .desc-cell {
    color: var(--muted);
    max-width: 240px;
    font-size: 0.83rem;
  }

  .action-btn {
    width: 34px;
    height: 34px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 8px;
    border: 1.5px solid var(--border);
    background: var(--gray-light);
    cursor: pointer;
    transition: all 0.2s;
    font-size: 0.82rem;
  }

  .action-edit { color: var(--primary); }
  .action-edit:hover { background: var(--primary-light); border-color: rgba(26,86,219,0.3); }

  .action-del { color: var(--danger); }
  .action-del:hover { background: #fef2f2; border-color: rgba(220,38,38,0.3); }

  .empty-row td {
    text-align: center;
    padding: 60px;
  }

  .empty-state-inner {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
  }

  .empty-icon {
    width: 70px;
    height: 70px;
    background: var(--gray-light);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.8rem;
    color: #d1d5db;
  }

  .empty-text {
    font-size: 0.95rem;
    font-weight: 600;
    color: var(--dark);
  }

  .empty-sub {
    font-size: 0.82rem;
    color: var(--muted);
  }

  @media (max-width: 1200px) {
    .stats-grid { grid-template-columns: repeat(2,1fr); }
  }

  @media (max-width: 900px) {
    .sidebar { width: 64px; padding: 16px 10px; }
    .logo-text, .nav-item span, .logout-link span, .sidebar-section-label,
    .nav-badge, .user-info, .sidebar-user { display: none; }
    .sidebar-logo { justify-content: center; padding: 0; }
    .nav-item { justify-content: center; padding: 12px; }
    .form-row { grid-template-columns: 1fr; }
    .content { padding: 20px; }
    .topbar { padding: 0 20px; }
  }
</style>
</head>
<body>
<%@ include file="preloader.jsp" %>


<aside class="sidebar">
  <a href="#" class="sidebar-logo">
    <div class="logo-icon"><i class="fa-solid fa-car-side"></i></div>
    <div class="logo-text">Drive<span>Zone</span></div>
  </a>

  <div class="sidebar-section-label">Main Menu</div>

  <a href="#" class="nav-item active" onclick="return false;">
    <i class="fa-solid fa-gauge-high nav-icon"></i>
    <span>Dashboard</span>
  </a>

  <a href="#add-car" class="nav-item" onclick="document.getElementById('add-car').scrollIntoView({behavior:'smooth'});return false;">
    <i class="fa-solid fa-plus-circle nav-icon"></i>
    <span>Add Vehicle</span>
  </a>

  <a href="#list-cars" class="nav-item" onclick="document.getElementById('list-cars').scrollIntoView({behavior:'smooth'});return false;">
    <i class="fa-solid fa-list-ul nav-icon"></i>
    <span>Inventory</span>
    <span class="nav-badge">Live</span>
  </a>

  <a href="#list-enquiries" class="nav-item" onclick="document.getElementById('list-enquiries').scrollIntoView({behavior:'smooth'});return false;">
    <i class="fa-solid fa-envelope nav-icon"></i>
    <span>Enquiries</span>
  </a>

  <a href="home.jsp" class="nav-item">
    <i class="fa-solid fa-globe nav-icon"></i>
    <span>Public Site</span>
  </a>

  <div class="sidebar-spacer"></div>

  <div class="sidebar-user">
    <div class="user-avatar">AD</div>
    <div class="user-info">
      <div class="user-name"><%= esc(adminUser) %></div>
      <div class="user-role">Administrator</div>
    </div>
  </div>

  <a href="LogoutServlet" class="logout-link">
    <i class="fa-solid fa-right-from-bracket"></i>
    <span>Logout</span>
  </a>
</aside>

<div class="main">
  <div class="topbar">
    <div class="topbar-left">
      <div class="topbar-title">Admin Dashboard</div>
      <div class="topbar-sub">Manage your DriveZone vehicle inventory</div>
    </div>

    <div class="topbar-right">
      <div class="topbar-chip">
        <i class="fa-solid fa-circle" style="color:#22c55e;font-size:0.5rem;"></i>
        System Online
      </div>

      <div class="topbar-chip">
        <i class="fa-solid fa-user-shield"></i>
        Admin
      </div>

      <div class="topbar-chip" style="cursor:pointer;" onclick="toggleTheme()" title="Toggle Theme">
        <i class="fa-solid fa-moon" id="themeIcon"></i>
      </div>

      <button type="button" class="topbar-btn" onclick="document.getElementById('add-car').scrollIntoView({behavior:'smooth'})">
        <i class="fa-solid fa-plus"></i> Add Vehicle
      </button>
    </div>
  </div>

  <div class="content">

    <div class="stats-grid">
      <div class="stat-card blue">
        <div class="stat-icon icon-blue"><i class="fa-solid fa-car-side"></i></div>
        <div class="stat-info">
          <div class="stat-num"><%= totalCars %></div>
          <div class="stat-lbl">Total Vehicles</div>
        </div>
        <div class="stat-trend"><i class="fa-solid fa-arrow-trend-up"></i> Live</div>
      </div>

      <div class="stat-card green">
        <div class="stat-icon icon-green"><i class="fa-solid fa-tags"></i></div>
        <div class="stat-info">
          <div class="stat-num"><%= activeListings %></div>
          <div class="stat-lbl">Active Listings</div>
        </div>
      </div>

      <div class="stat-card violet">
        <div class="stat-icon icon-violet"><i class="fa-solid fa-envelope"></i></div>
        <div class="stat-info">
          <div class="stat-num"><%= totalEnquiries %></div>
          <div class="stat-lbl">Total Enquiries</div>
        </div>
      </div>

      <div class="stat-card amber">
        <div class="stat-icon icon-amber"><i class="fa-solid fa-clock-rotate-left"></i></div>
        <div class="stat-info">
          <div class="stat-num"><%= pendingEnquiries %></div>
          <div class="stat-lbl">Pending Enquiries</div>
        </div>
      </div>
    </div>

    <div class="panel" id="add-car">
      <div class="panel-header">
        <div class="panel-title-wrap">
          <div class="panel-title-icon"><i class="fa-solid fa-plus-circle"></i></div>
          <div>
            <div class="panel-title">Add New Vehicle</div>
            <div class="panel-subtitle">Fill in the details to publish a new vehicle to the inventory</div>
          </div>
        </div>
      </div>

      <form action="UploadServlet" method="post" enctype="multipart/form-data">
        <div class="form-row">
          <div class="fgroup">
            <label>Brand Name <span style="color:#ef4444;">*</span></label>
            <input type="text" name="brand" placeholder="e.g. Mercedes-Benz" required>
          </div>

          <div class="fgroup">
            <label>Model Name <span style="color:#ef4444;">*</span></label>
            <input type="text" name="model" placeholder="e.g. S-Class 2026" required>
          </div>

          <div class="fgroup">
            <label>Price (INR) <span style="color:#ef4444;">*</span></label>
            <input type="number" name="price" min="1" placeholder="e.g. 20000000" required>
          </div>

          <div class="fgroup">
            <label>Fuel Type <span style="color:#ef4444;">*</span></label>
            <select name="fuel_type" required>
              <option value="" disabled selected>Select fuel type</option>
              <option value="Petrol">Petrol</option>
              <option value="Diesel">Diesel</option>
              <option value="Electric">Electric</option>
              <option value="Hybrid">Hybrid</option>
              <option value="CNG">CNG</option>
            </select>
          </div>

          <div class="fgroup full">
            <label>Vehicle Description <span style="color:#ef4444;">*</span></label>
            <textarea name="description" placeholder="Key features, specifications, and highlights..." required></textarea>
          </div>

          <div class="fgroup full">
            <label>Cover Image (High-Resolution) <span style="color:#ef4444;">*</span></label>
            <input type="file" name="image" accept="image/*" required>
          </div>
        </div>

        <div class="form-actions">
          <button type="submit" class="btn-publish">
            <i class="fa-solid fa-upload"></i> Publish Vehicle
          </button>

          <button type="reset" class="btn-reset">
            <i class="fa-solid fa-rotate-left"></i> Reset
          </button>
        </div>
      </form>
    </div>

    <div class="panel" id="list-cars">
      <div class="panel-header">
        <div class="panel-title-wrap">
          <div class="panel-title-icon"><i class="fa-solid fa-table-list"></i></div>
          <div>
            <div class="panel-title">Live Inventory</div>
            <div class="panel-subtitle">All vehicles currently listed in the showroom</div>
          </div>
        </div>
      </div>

      <div class="table-toolbar">
        <div class="table-search">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" id="tableSearch" placeholder="Search vehicles..." oninput="filterTable()">
        </div>

        <div class="topbar-chip" style="margin-left:auto;">
          <i class="fa-solid fa-car-side"></i>
          <%= totalCars %> vehicles
        </div>
      </div>

      <div class="table-wrap">
        <table id="inventoryTable">
          <thead>
            <tr>
              <th>#</th>
              <th>Preview</th>
              <th>Vehicle</th>
              <th>Price</th>
              <th>Fuel</th>
              <th>Status</th>
              <th>Description</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
<%
    try (Connection con = DBConnection.getConnection();
         Statement st = con.createStatement();
         ResultSet rs = st.executeQuery("SELECT * FROM cars ORDER BY id DESC")) {

        boolean any = false;

        while (rs.next()) {
            any = true;

            int id = rs.getInt("id");
            String fuel = rs.getString("fuel_type");
            String fuelCls;
            if (fuel == null) {
                fuelCls = "pill-default";
            } else {
                switch (fuel.toLowerCase()) {
                    case "petrol":
                        fuelCls = "pill-petrol";
                        break;
                    case "diesel":
                        fuelCls = "pill-diesel";
                        break;
                    case "electric":
                        fuelCls = "pill-electric";
                        break;
                    case "cng":
                        fuelCls = "pill-cng";
                        break;
                    default:
                        fuelCls = "pill-default";
                }
            }

            String desc = rs.getString("description");
            if (desc != null && desc.length() > 60) {
                desc = desc.substring(0, 57) + "...";
            }

            String image = rs.getString("image");
            String img = "uploads/" + safe(image, "default.png");

            String brand = safe(rs.getString("brand"), "Unknown");
            String model = safe(rs.getString("model"), "Model");
            String price = safe(rs.getString("price"), "0");
            String status = rs.getString("status");
            if (status == null || status.trim().isEmpty()) status = "Available";
            boolean isSold = "Sold".equalsIgnoreCase(status);
%>
            <tr>
              <td style="color:var(--muted);font-size:0.78rem;font-weight:600;">#<%= id %></td>
              <td>
                <img src="<%= esc(img) %>" class="table-thumb" alt="Car" onerror="this.src='https://via.placeholder.com/72x46?text=N/A';">
              </td>
              <td>
                <div class="car-brand-badge"><%= esc(brand) %></div>
                <div class="car-name"><%= esc(brand) %> <%= esc(model) %></div>
              </td>
              <td><span class="price-text">&#8377; <%= esc(price) %></span></td>
              <td>
                <span class="fuel-pill <%= fuelCls %>">
                  <i class="fa-solid fa-gas-pump"></i> <%= esc(safe(fuel, "N/A")) %>
                </span>
              </td>
              <td>
                <span class="fuel-pill <%= isSold ? "pill-diesel" : "pill-electric" %>" style="text-transform:uppercase;">
                  <i class="fa-solid <%= isSold ? "fa-tag" : "fa-check-circle" %>"></i> <%= esc(status) %>
                </span>
              </td>
              <td class="desc-cell"><%= desc != null ? esc(desc) : "&mdash;" %></td>
              <td>
                <span class="action-btn action-edit" onclick="window.location.href='editCar.jsp?id=<%= id %>'" title="Edit Vehicle" style="cursor:pointer;">
                  <i class="fa-solid fa-pen-to-square"></i>
                </span>
                &nbsp;
                <% if (isSold) { %>
                  <span class="action-btn action-edit" onclick="window.location.href='UpdateStatusServlet?id=<%= id %>&status=Available'" title="Mark as Available" style="color:var(--success); border-color:#d1fae5; background:#ecfdf5;">
                    <i class="fa-solid fa-rotate"></i>
                  </span>
                <% } else { %>
                  <span class="action-btn action-edit" onclick="window.location.href='UpdateStatusServlet?id=<%= id %>&status=Sold'" title="Mark as Sold" style="color:var(--warning); border-color:#fef3c7; background:#fffbeb;">
                    <i class="fa-solid fa-tag"></i>
                  </span>
                <% } %>
                &nbsp;
                <span class="action-btn action-del" onclick="confirmDelete('<%= id %>')" title="Delete Vehicle" style="cursor:pointer;">
                  <i class="fa-solid fa-trash-can"></i>
                </span>
                <form id="deleteForm-<%= id %>" action="DeleteServlet" method="POST" style="display:none;">
                  <input type="hidden" name="id" value="<%= id %>">
                </form>
              </td>
            </tr>
<%
        }

        if (!any) {
%>
            <tr class="empty-row">
              <td colspan="8">
                <div class="empty-state-inner">
                  <div class="empty-icon"><i class="fa-solid fa-car-burst"></i></div>
                  <div class="empty-text">No vehicles in inventory yet</div>
                  <div class="empty-sub">Use the "Add Vehicle" form above to publish your first car.</div>
                </div>
              </td>
            </tr>
<%
        }

    } catch (Exception e) {
        e.printStackTrace();
%>
            <tr class="empty-row">
              <td colspan="8">
                <div class="empty-state-inner">
                  <div class="empty-icon" style="background:#fef2f2;color:#ef4444;"><i class="fa-solid fa-circle-exclamation"></i></div>
                  <div class="empty-text" style="color:#ef4444;">Database Connection Error</div>
                  <div class="empty-sub">Could not load inventory. Please check your connection.</div>
                </div>
              </td>
            </tr>
<%
    }
%>
          </tbody>
        </table>
      </div>
    </div>

    <div class="panel" id="list-enquiries">
      <div class="panel-header">
        <div class="panel-title-wrap">
          <div class="panel-title-icon" style="background:#f5f3ff; color:#7c3aed;"><i class="fa-solid fa-envelope-open-text"></i></div>
          <div>
            <div class="panel-title">Customer Enquiries</div>
            <div class="panel-subtitle">Messages from users interested in specific vehicles</div>
          </div>
        </div>
      </div>

      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Date</th>
              <th>Customer</th>
              <th>Vehicle</th>
              <th>Message</th>
              <th>Status</th>
              <th style="text-align:right;">Actions</th>
            </tr>
          </thead>
          <tbody>
<%
    try (Connection conEnq = DBConnection.getConnection();
         Statement stEnq = conEnq.createStatement();
         ResultSet rsEnq = stEnq.executeQuery("SELECT e.*, c.brand, c.model FROM enquiries e JOIN cars c ON e.car_id = c.id ORDER BY e.created_at DESC")) {

        boolean anyEnq = false;

        while (rsEnq.next()) {
            anyEnq = true;

            int enquiryId = rsEnq.getInt("id");
            String customerName = safe(rsEnq.getString("user_name"), "Unknown User");
            String customerEmail = safe(rsEnq.getString("user_email"), "No email");
            String carBrand = safe(rsEnq.getString("brand"), "Unknown");
            String carModel = safe(rsEnq.getString("model"), "Model");
            String message = safe(rsEnq.getString("message"), "No message");
            String s = rsEnq.getString("status");
            if (s == null || s.trim().isEmpty()) s = "Pending";

            String bg = "#fef2f2";
            String fg = "#ef4444";
            String bc = "#fecaca";
            String pillClass = "pill-diesel";

            if ("Closed".equalsIgnoreCase(s)) {
                bg = "#ecfdf5";
                fg = "#059669";
                bc = "#a7f3d0";
                pillClass = "pill-electric";
            } else if ("Contacted".equalsIgnoreCase(s)) {
                bg = "#fffbeb";
                fg = "#d97706";
                bc = "#fde68a";
                pillClass = "pill-petrol";
            }

            Timestamp createdAt = rsEnq.getTimestamp("created_at");
%>
            <tr>
              <td style="font-size:0.75rem; color:var(--muted);"><%= createdAt != null ? esc(createdAt.toString()) : "N/A" %></td>
              <td>
                <div style="font-weight:700; color:var(--dark);"><%= esc(customerName) %></div>
                <div style="font-size:0.75rem; color:var(--muted);"><%= esc(customerEmail) %></div>
              </td>
              <td>
                <div class="car-brand-badge"><%= esc(carBrand) %></div>
                <div style="font-size:0.85rem; font-weight:600;"><%= esc(carModel) %></div>
              </td>
              <td class="desc-cell" style="max-width:300px;"><%= esc(message) %></td>
              <td>
                <span class="fuel-pill <%= pillClass %>" style="background:<%= bg %>; color:<%= fg %>; border-color:<%= bc %>; font-size:0.65rem;">
                  <%= esc(s.toUpperCase()) %>
                </span>
              </td>
              <td style="text-align:right;">
                <form action="UpdateStatusServlet" method="POST" style="display:inline-block; margin-right: 5px;">
                  <input type="hidden" name="id" value="<%= enquiryId %>">
                  <select name="status" onchange="this.form.submit()" style="font-size:0.75rem; padding: 2px 4px; border-radius: 4px; border:1px solid var(--border); background: var(--card-bg); color: var(--text);">
                    <option value="" disabled selected>Change Status</option>
                    <option value="Pending">Pending</option>
                    <option value="Contacted">Contacted</option>
                    <option value="Closed">Closed</option>
                  </select>
                </form>
                <span class="action-btn action-del" onclick="confirmDeleteEnquiry('<%= enquiryId %>')" title="Delete Enquiry" style="cursor:pointer; width:28px; height:28px; font-size:0.75rem;">
                  <i class="fa-solid fa-trash-can"></i>
                </span>
                <form id="deleteEnquiryForm-<%= enquiryId %>" action="DeleteEnquiryServlet" method="POST" style="display:none;">
                  <input type="hidden" name="id" value="<%= enquiryId %>">
                </form>
              </td>
            </tr>
<%
        }

        if (!anyEnq) {
%>
            <tr class="empty-row">
              <td colspan="6">
                <div class="empty-state-inner">
                  <div class="empty-icon"><i class="fa-solid fa-inbox"></i></div>
                  <div class="empty-text">No enquiries yet</div>
                </div>
              </td>
            </tr>
<%
        }

    } catch (Exception e) {
        e.printStackTrace();
%>
            <tr class="empty-row">
              <td colspan="6">Error loading enquiries. Make sure the table exists.</td>
            </tr>
<%
    }
%>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</div>

<script>
function confirmDelete(id) {
    Swal.fire({
        title: 'Delete Vehicle?',
        text: 'This action will permanently remove the vehicle from inventory.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: '<i class="fa-solid fa-trash-can"></i>&nbsp; Delete',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#dc2626',
        cancelButtonColor: '#6b7280',
        background: '#fff',
        color: '#111827',
        backdrop: 'rgba(0,0,0,0.5)',
        reverseButtons: true,
        borderRadius: '16px'
    }).then(function(r) {
        if (r.isConfirmed) {
            document.getElementById('deleteForm-' + id).submit();
        }
    });
}

function confirmDeleteEnquiry(id) {
    Swal.fire({
        title: 'Delete Enquiry?',
        text: 'This will remove the customer message permanently.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Delete',
        confirmButtonColor: '#dc2626',
        cancelButtonColor: '#6b7280',
        background: '#fff',
        color: '#111827',
        borderRadius: '16px',
        reverseButtons: true
    }).then(function(r) {
        if (r.isConfirmed) {
            document.getElementById('deleteEnquiryForm-' + id).submit();
        }
    });
}

function filterTable() {
    const q = document.getElementById('tableSearch').value.toLowerCase();
    const rows = document.querySelectorAll('#inventoryTable tbody tr:not(.empty-row)');

    rows.forEach(function(row) {
        row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
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
    if (themeIcon) {
        if (document.documentElement.getAttribute('data-theme') === 'dark') {
            themeIcon.className = 'fa-solid fa-sun';
        } else {
            themeIcon.className = 'fa-solid fa-moon';
        }
    }
}

document.addEventListener('DOMContentLoaded', function() {
    updateThemeIcon();

    <% if (request.getParameter("success") != null) { %>
    Swal.fire({
        icon:'success',
        title:'Vehicle Published!',
        text:'The vehicle is now live in the showroom.',
        background:'#fff',
        color:'#111827',
        iconColor:'#1a56db',
        confirmButtonColor:'#1a56db',
        borderRadius:'16px'
    });
    <% } %>

    <% if (request.getParameter("updated") != null) { %>
    Swal.fire({
        icon:'success',
        title:'Updated!',
        text:'Vehicle details saved successfully.',
        background:'#fff',
        color:'#111827',
        iconColor:'#1a56db',
        confirmButtonColor:'#1a56db'
    });
    <% } %>

    <% if (request.getParameter("deleted") != null) { %>
    Swal.fire({
        icon:'success',
        title:'Removed!',
        text:'Vehicle removed from inventory.',
        background:'#fff',
        color:'#111827',
        iconColor:'#dc2626',
        confirmButtonColor:'#1a56db'
    });
    <% } %>

    <% if (request.getParameter("enq_deleted") != null) { %>
    Swal.fire({
        icon:'success',
        title:'Enquiry Deleted!',
        text:'Message removed from dashboard.',
        background:'#fff',
        color:'#111827',
        iconColor:'#dc2626',
        confirmButtonColor:'#1a56db'
    });
    <% } %>

    <% if (request.getParameter("error") != null) { %>
    Swal.fire({
        icon:'error',
        title:'Error!',
        text:'Could not publish vehicle. Check DB or image.',
        background:'#fff',
        color:'#111827',
        confirmButtonColor:'#dc2626'
    });
    <% } %>
});
</script>

</body>
</html>