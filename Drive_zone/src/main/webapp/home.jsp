<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="db.DBConnection" %>
<%@ page session="true" %>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (userName == null) {
        userName = "User";
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
<title>DriveZone - Find Your Perfect Car</title>
<meta name="description" content="Browse our premium collection of vehicles. Find your dream car with DriveZone.">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

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
    --accent: #f59e0b;
    --dark: #111827;
    --dark-2: #1f2937;
    --gray: #6b7280;
    --gray-light: #f3f4f6;
    --gray-mid: #e5e7eb;
    --text: #111827;
    --text-muted: #6b7280;
    --white: #ffffff;
    --card-bg: #ffffff;
    --card-shadow: 0 4px 24px rgba(0,0,0,0.08);
    --card-shadow-hover: 0 20px 50px rgba(0,0,0,0.14);
    --bg-color: #f9fafb;
    --nav-scrolled: rgba(255, 255, 255, 0.92);
  }

  [data-theme="dark"] {
    --primary: #3b82f6;
    --primary-dark: #60a5fa;
    --primary-light: rgba(59,130,246,0.15);
    --dark: #f9fafb;
    --dark-2: #111827;
    --gray: #9ca3af;
    --gray-light: #1f2937;
    --gray-mid: #374151;
    --text: #f3f4f6;
    --text-muted: #9ca3af;
    --white: #1f2937;
    --card-bg: #1f2937;
    --bg-color: #111827;
    --nav-scrolled: rgba(31, 41, 55, 0.92);
    --card-shadow: 0 4px 24px rgba(0,0,0,0.25);
    --card-shadow-hover: 0 20px 50px rgba(0,0,0,0.4);
  }

  html { scroll-behavior: smooth; }

  body {
    font-family: 'Inter', sans-serif;
    background: var(--bg-color);
    color: var(--text);
    overflow-x: hidden;
  }

  .navbar {
    position: fixed;
    top: 0; left: 0; right: 0;
    z-index: 1000;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 60px;
    height: 80px;
    background: transparent;
    border-bottom: 1px solid transparent;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  }

  .navbar.scrolled {
    background: var(--nav-scrolled);
    backdrop-filter: blur(12px);
    height: 72px;
    border-bottom: 1px solid var(--gray-mid);
    box-shadow: 0 4px 30px rgba(0,0,0,0.08);
  }

  .logo {
    font-size: 1.5rem;
    font-weight: 850;
    color: white;
    display: flex;
    align-items: center;
    gap: 12px;
    text-decoration: none;
    letter-spacing: -0.8px;
    transition: color 0.3s;
  }

  .navbar.scrolled .logo { color: var(--dark); }

  .logo-icon {
    width: 40px;
    height: 40px;
    background: linear-gradient(135deg, var(--primary), #3b82f6);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.1rem;
  }

  .logo span { color: var(--primary); }

  .nav-links {
    display: flex;
    align-items: center;
    gap: 36px;
    list-style: none;
  }

  .nav-links a {
    text-decoration: none;
    color: rgba(255,255,255,0.8);
    font-size: 0.9rem;
    font-weight: 500;
    transition: all 0.3s;
    position: relative;
  }

  .navbar.scrolled .nav-links a { color: var(--gray); }
  .nav-links a:hover { color: white; }
  .navbar.scrolled .nav-links a:hover { color: var(--primary); }

  .nav-links a.active { color: var(--primary); }

  .nav-links a.active::after {
    content: '';
    position: absolute;
    bottom: -4px; left: 0; right: 0;
    height: 2px;
    background: var(--primary);
    border-radius: 2px;
  }

  .nav-right {
    display: flex;
    align-items: center;
    gap: 14px;
  }

  .user-chip {
    display: flex;
    align-items: center;
    gap: 8px;
    background: var(--primary-light);
    color: var(--primary);
    padding: 7px 16px;
    border-radius: 99px;
    font-size: 0.85rem;
    font-weight: 600;
  }

  .btn-logout {
    display: flex;
    align-items: center;
    gap: 7px;
    padding: 9px 20px;
    border-radius: 10px;
    font-size: 0.85rem;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.2s;
    border: 1.5px solid #fecaca;
    background: #fff5f5;
    color: #ef4444;
  }

  .btn-logout:hover {
    background: #ef4444;
    color: #fff;
    border-color: #ef4444;
  }

  .modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.6);
    backdrop-filter: blur(4px);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 2000;
    padding: 20px;
  }

  .modal-overlay.active { display: flex; }

  .modal-card {
    background: var(--white);
    width: 100%;
    max-width: 800px;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
  }

  .modal-head {
    padding: 24px;
    border-bottom: 1px solid var(--gray-mid);
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .modal-title {
    font-weight: 800;
    font-size: 1.2rem;
    color: var(--dark);
  }

  .modal-close {
    cursor: pointer;
    color: var(--gray);
    font-size: 1.2rem;
    transition: color 0.2s;
  }

  .modal-close:hover { color: #ef4444; }

  .modal-body {
    padding: 24px;
    max-height: 60vh;
    overflow-y: auto;
  }

  .enq-list-item {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 16px;
    border: 1px solid var(--gray-mid);
    border-radius: 12px;
    margin-bottom: 12px;
  }

  .enq-car-img {
    width: 80px;
    height: 50px;
    border-radius: 6px;
    object-fit: cover;
  }

  .enq-info { flex: 1; }

  .enq-car-name {
    font-weight: 700;
    font-size: 0.9rem;
    color: var(--dark);
    margin-bottom: 2px;
  }

  .enq-msg {
    font-size: 0.78rem;
    color: var(--gray);
    display: -webkit-box;
    -webkit-line-clamp: 1;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }

  .enq-status {
    padding: 4px 10px;
    border-radius: 99px;
    font-size: 0.65rem;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  .st-pending {
    background: #fff7ed;
    color: #c2410c;
    border: 1px solid #ffedd5;
  }

  .st-verified {
    background: #f0fdf4;
    color: #15803d;
    border: 1px solid #dcfce7;
  }

  .btn-enquiry-status {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 9px 18px;
    border-radius: 10px;
    font-size: 0.85rem;
    font-weight: 700;
    text-decoration: none;
    transition: all 0.2s;
    border: 1.5px solid var(--primary);
    background: transparent;
    color: var(--primary);
    cursor: pointer;
    font-family: 'Inter', sans-serif;
  }

  .btn-enquiry-status:hover {
    background: var(--primary);
    color: #fff;
  }

  .hero {
    min-height: 100vh;
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    padding: 0 20px;
    overflow: hidden;
    background: radial-gradient(circle at center, #111827 0%, #030712 100%);
  }

  .hero::before {
    content: '';
    position: absolute;
    inset: 0;
    background-image: radial-gradient(circle, rgba(255,255,255,0.06) 1px, transparent 1px);
    background-size: 40px 40px;
    z-index: 0;
  }

  .hero-bg {
    position: absolute;
    inset: 0;
    background: url('uploads/hero.png') center 60% / cover no-repeat;
    opacity: 0.55;
    mix-blend-mode: luminosity;
    filter: brightness(0.8) contrast(1.1);
    animation: kenBurns 45s linear infinite alternate;
  }

  @keyframes kenBurns {
    from { transform: scale(1.05) translateX(0); }
    to   { transform: scale(1.12) translateX(-20px); }
  }

  .hero-orb {
    position: absolute;
    border-radius: 50%;
    filter: blur(100px);
    z-index: 0;
  }

  .orb-1 {
    width: 600px;
    height: 600px;
    background: rgba(55,65,81,0.25);
    top: -200px;
    right: -100px;
  }

  .orb-2 {
    width: 400px;
    height: 400px;
    background: rgba(31,41,55,0.2);
    bottom: -100px;
    left: -100px;
  }

  .hero-content {
    position: relative;
    z-index: 2;
    max-width: 860px;
  }

  .hero-badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.2);
    color: #93c5fd;
    padding: 7px 20px;
    border-radius: 99px;
    font-size: 0.82rem;
    font-weight: 600;
    letter-spacing: 0.5px;
    margin-bottom: 28px;
    animation: fadeUp 0.7s ease;
  }

  .hero-badge i { color: #fbbf24; }

  .hero h1 {
    font-size: 4.5rem;
    font-weight: 900;
    line-height: 1.08;
    letter-spacing: -3px;
    color: #fff;
    margin-bottom: 24px;
    animation: fadeUp 0.7s ease 0.1s both;
  }

  .hero h1 .highlight {
    background: linear-gradient(90deg, #93c5fd, #60a5fa);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }

  .hero p {
    font-size: 1.1rem;
    color: rgba(255,255,255,0.65);
    line-height: 1.75;
    max-width: 520px;
    margin: 0 auto 48px;
    font-weight: 400;
    animation: fadeUp 0.7s ease 0.2s both;
  }

  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(25px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  .hero-stats {
    display: flex;
    gap: 0;
    justify-content: center;
    margin-top: 60px;
    animation: fadeUp 0.7s ease 0.3s both;
  }

  .hero-stat {
    padding: 20px 36px;
    border-right: 1px solid rgba(255,255,255,0.1);
    text-align: center;
  }

  .hero-stat:last-child { border-right: none; }

  .hero-stat-num {
    font-size: 2rem;
    font-weight: 800;
    color: #fff;
    margin-bottom: 4px;
  }

  .hero-stat-num span { color: #60a5fa; }

  .hero-stat-label {
    font-size: 0.78rem;
    color: rgba(255,255,255,0.5);
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  .scroll-cue {
    position: absolute;
    bottom: 32px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 2;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 6px;
    color: rgba(255,255,255,0.35);
    font-size: 0.72rem;
    letter-spacing: 2px;
    text-transform: uppercase;
    animation: bob 2.5s ease-in-out infinite;
  }

  @keyframes bob {
    0%,100% { transform:translateX(-50%) translateY(0); }
    50% { transform:translateX(-50%) translateY(8px); }
  }

  .search-section {
    background: var(--white);
    padding: 0 60px;
    position: relative;
    z-index: 10;
  }

  .search-card {
    max-width: 1100px;
    margin: -36px auto 0;
    background: var(--card-bg);
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.12);
    padding: 28px 32px;
    border: 1px solid var(--gray-mid);
    display: flex;
    gap: 16px;
    align-items: flex-end;
    flex-wrap: wrap;
  }

  .search-group {
    display: flex;
    flex-direction: column;
    gap: 7px;
    flex: 1;
    min-width: 160px;
  }

  .search-group label {
    font-size: 0.75rem;
    font-weight: 700;
    color: var(--gray);
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  .search-group input,
  .search-group select {
    background: #f9fafb;
    border: 1.5px solid var(--gray-mid);
    border-radius: 10px;
    padding: 11px 14px;
    color: var(--text);
    font-family: 'Inter', sans-serif;
    font-size: 0.9rem;
    outline: none;
    transition: all 0.2s;
    width: 100%;
  }

  .search-group input:focus,
  .search-group select:focus {
    border-color: var(--primary);
    background: #fff;
    box-shadow: 0 0 0 3px rgba(26,86,219,0.1);
  }

  .search-group input::placeholder { color: #9ca3af; }

  .btn-search {
    display: flex;
    align-items: center;
    gap: 8px;
    background: linear-gradient(135deg, var(--primary), var(--primary-dark));
    color: #fff;
    border: none;
    border-radius: 12px;
    padding: 13px 28px;
    font-family: 'Inter', sans-serif;
    font-size: 0.95rem;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.25s;
    box-shadow: 0 6px 20px rgba(26,86,219,0.4);
    white-space: nowrap;
  }

  .btn-search:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 28px rgba(26,86,219,0.5);
  }

  .section {
    max-width: 1300px;
    margin: 80px auto 0;
    padding: 0 40px;
  }

  .section-head {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    margin-bottom: 40px;
  }

  .section-head-left .eyebrow {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: var(--primary-light);
    color: var(--primary);
    padding: 5px 14px;
    border-radius: 99px;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.5px;
    margin-bottom: 12px;
  }

  .section-head-left h2 {
    font-size: 2.2rem;
    font-weight: 800;
    letter-spacing: -1.5px;
    color: var(--dark);
    margin-bottom: 8px;
  }

  .section-head-left p {
    color: var(--text-muted);
    font-size: 0.92rem;
  }

  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
    gap: 24px;
    margin-bottom: 80px;
  }

  .card {
    background: var(--white);
    border: 1.5px solid var(--gray-mid);
    border-radius: 20px;
    overflow: hidden;
    display: flex;
    flex-direction: column;
    transition: all 0.35s cubic-bezier(0.23,1,0.32,1);
    box-shadow: var(--card-shadow);
    cursor: pointer;
    position: relative;
  }

  .card:hover {
    transform: translateY(-8px);
    border-color: rgba(26,86,219,0.3);
    box-shadow: var(--card-shadow-hover);
  }

  .card-img {
    width: 100%;
    height: 210px;
    overflow: hidden;
    position: relative;
    background: var(--gray-light);
  }

  .card-img img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s cubic-bezier(0.23,1,0.32,1);
  }

  .card:hover .card-img img { transform: scale(1.06); }

  .fuel-badge {
    position: absolute;
    top: 12px;
    left: 12px;
    padding: 5px 12px;
    border-radius: 99px;
    font-size: 0.72rem;
    font-weight: 700;
    letter-spacing: 0.3px;
    background: rgba(255,255,255,0.95);
    backdrop-filter: blur(8px);
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  }

  .fuel-petrol   { color: #d97706; border: 1px solid #fde68a; }
  .fuel-diesel   { color: #4f46e5; border: 1px solid #c7d2fe; }
  .fuel-electric { color: #059669; border: 1px solid #a7f3d0; }
  .fuel-hybrid   { color: #0284c7; border: 1px solid #bae6fd; }
  .fuel-default  { color: #6b7280; border: 1px solid #e5e7eb; }

  .fav-btn {
    position: absolute;
    top: 12px;
    right: 12px;
    width: 36px;
    height: 36px;
    background: rgba(255,255,255,0.9);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #9ca3af;
    border: 1px solid var(--gray-mid);
    cursor: pointer;
    font-size: 0.85rem;
    transition: all 0.3s;
    backdrop-filter: blur(8px);
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  }

  .fav-btn:hover {
    color: #ef4444;
    border-color: #fecaca;
    background: #fff5f5;
  }

  .card-badge-new {
    position: absolute;
    bottom: 12px;
    right: 12px;
    background: var(--primary);
    color: #fff;
    padding: 4px 10px;
    border-radius: 6px;
    font-size: 0.7rem;
    font-weight: 700;
    letter-spacing: 0.5px;
  }

  .card-body {
    padding: 22px;
    display: flex;
    flex-direction: column;
    flex: 1;
  }

  .card-brand {
    font-size: 0.75rem;
    font-weight: 700;
    color: var(--primary);
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-bottom: 4px;
  }

  .card-name {
    font-size: 1.15rem;
    font-weight: 700;
    color: var(--dark);
    margin-bottom: 4px;
    line-height: 1.3;
  }

  .card-price {
    font-size: 1.5rem;
    font-weight: 800;
    color: var(--dark);
    margin-bottom: 14px;
    letter-spacing: -0.5px;
  }

  .card-specs {
    display: flex;
    gap: 16px;
    margin-bottom: 18px;
    flex-wrap: wrap;
  }

  .spec-item {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 0.8rem;
    color: var(--text-muted);
    font-weight: 500;
  }

  .spec-item i {
    color: var(--primary);
    font-size: 0.75rem;
  }

  .card-desc {
    color: var(--text-muted);
    font-size: 0.82rem;
    line-height: 1.65;
    flex: 1;
    margin-bottom: 18px;
  }

  .card-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
    padding-top: 16px;
    border-top: 1px solid var(--gray-mid);
  }

  .card-cta {
    display: flex;
    align-items: center;
    gap: 6px;
    color: var(--primary);
    font-size: 0.85rem;
    font-weight: 700;
    text-decoration: none;
    transition: gap 0.2s;
  }

  .card:hover .card-cta { gap: 10px; }

  .btn-enquire {
    display: flex;
    align-items: center;
    gap: 6px;
    background: var(--primary-light);
    color: var(--primary);
    border: none;
    border-radius: 8px;
    padding: 8px 16px;
    font-size: 0.82rem;
    font-weight: 700;
    cursor: pointer;
    font-family: 'Inter', sans-serif;
    transition: all 0.2s;
  }

  .btn-enquire:hover {
    background: var(--primary);
    color: #fff;
  }

  .btn-enquire:disabled {
    opacity: 0.7;
    cursor: not-allowed;
  }

  .empty-state {
    grid-column: 1/-1;
    text-align: center;
    padding: 80px 20px;
    color: var(--text-muted);
  }

  .empty-state i {
    font-size: 3rem;
    margin-bottom: 18px;
    color: #d1d5db;
    display: block;
  }

  .empty-state h3 {
    font-size: 1.2rem;
    font-weight: 700;
    color: var(--dark);
    margin-bottom: 8px;
  }

  .features-section {
    background: var(--dark);
    padding: 100px 40px;
    margin: 80px 0 0;
  }

  .features-inner {
    max-width: 1200px;
    margin: 0 auto;
  }

  .features-header {
    text-align: center;
    margin-bottom: 60px;
  }

  .features-header .eyebrow {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: rgba(26,86,219,0.15);
    color: #93c5fd;
    padding: 6px 16px;
    border-radius: 99px;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.5px;
    margin-bottom: 16px;
    border: 1px solid rgba(147,197,253,0.2);
  }

  .features-header h2 {
    font-size: 2.2rem;
    font-weight: 800;
    color: #fff;
    letter-spacing: -1px;
    margin-bottom: 12px;
  }

  .features-header p {
    color: rgba(255,255,255,0.5);
    font-size: 0.95rem;
  }

  .features-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 24px;
  }

  .feature-card {
    background: rgba(255,255,255,0.04);
    border: 1px solid rgba(255,255,255,0.08);
    border-radius: 20px;
    padding: 36px 28px;
    transition: all 0.3s;
  }

  .feature-card:hover {
    background: rgba(26,86,219,0.08);
    border-color: rgba(26,86,219,0.3);
    transform: translateY(-4px);
  }

  .feature-icon {
    width: 56px;
    height: 56px;
    background: rgba(26,86,219,0.15);
    border-radius: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #60a5fa;
    font-size: 1.4rem;
    margin-bottom: 22px;
    border: 1px solid rgba(96,165,250,0.2);
  }

  .feature-card h3 {
    font-size: 1.05rem;
    font-weight: 700;
    color: #fff;
    margin-bottom: 10px;
  }

  .feature-card p {
    font-size: 0.87rem;
    color: rgba(255,255,255,0.5);
    line-height: 1.7;
  }

  .footer {
    background: var(--dark-2);
    padding: 60px 60px 32px;
  }

  .footer-inner {
    max-width: 1200px;
    margin: 0 auto;
  }

  .footer-top {
    display: grid;
    grid-template-columns: 1.5fr 1fr 1fr 1fr;
    gap: 48px;
    margin-bottom: 48px;
    padding-bottom: 48px;
    border-bottom: 1px solid rgba(255,255,255,0.06);
  }

  .footer-brand .logo {
    margin-bottom: 16px;
    display: inline-flex;
  }

  .footer-desc {
    font-size: 0.875rem;
    color: rgba(255,255,255,0.4);
    line-height: 1.75;
    margin-bottom: 24px;
  }

  .footer-col h4 {
    font-size: 0.85rem;
    font-weight: 700;
    color: rgba(255,255,255,0.7);
    text-transform: uppercase;
    letter-spacing: 0.8px;
    margin-bottom: 20px;
  }

  .footer-col ul {
    list-style: none;
  }

  .footer-col ul li {
    margin-bottom: 12px;
  }

  .footer-col ul li a {
    text-decoration: none;
    color: rgba(255,255,255,0.4);
    font-size: 0.875rem;
    transition: color 0.2s;
  }

  .footer-col ul li a:hover { color: #fff; }

  .footer-bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    font-size: 0.82rem;
    color: rgba(255,255,255,0.3);
    flex-wrap: wrap;
  }

  .footer-bottom span { color: #60a5fa; }

  @media (max-width: 900px) {
    .navbar { padding: 0 20px; }
    .nav-links { display: none; }
    .hero h1 { font-size: 2.8rem; letter-spacing: -2px; }
    .section { padding: 0 20px; }
    .grid { grid-template-columns: 1fr; }
    .search-card { flex-direction: column; }
    .search-section { padding: 0 20px; }
    .footer-top { grid-template-columns: 1fr 1fr; }
    .features-grid { grid-template-columns: 1fr; }
    .hero-stats { flex-direction: column; gap: 0; }
  }
</style>
</head>
<body>

<nav class="navbar" id="navbar">
  <a class="logo" href="#home">
    <div class="logo-icon"><i class="fa-solid fa-car-side"></i></div>
    Drive<span>Zone</span>
  </a>

  <ul class="nav-links">
    <li><a href="#home" class="active">Home</a></li>
    <li><a href="#inventory">Inventory</a></li>
    <li><a href="#features">Why Us</a></li>
  </ul>

  <div class="nav-right">
    <div class="user-chip">
      <i class="fa-solid fa-circle-user"></i>
      <%= userName %>
    </div>

    <button type="button" class="btn-enquiry-status" onclick="openEnquiryModal()">
      <i class="fa-solid fa-clipboard-list"></i> My Enquiries
    </button>

    <button type="button" class="btn-enquiry-status" onclick="toggleTheme()" title="Toggle Theme" style="padding: 9px 12px;">
      <i class="fa-solid fa-moon" id="themeIcon"></i>
    </button>

    <a href="LogoutServlet" class="btn-logout">
      <i class="fa-solid fa-right-from-bracket"></i> Logout
    </a>
  </div>
</nav>

<section class="hero" id="home">
  <div class="hero-bg"></div>
  <div class="hero-orb orb-1"></div>
  <div class="hero-orb orb-2"></div>

  <div class="hero-content">
    <div class="hero-badge" style="background:rgba(16,185,129,0.1); border-color:rgba(16,185,129,0.3); color:#10b981;">
      <i class="fa-solid fa-circle-check"></i> &nbsp; Available Now - Ready for Immediate Delivery
    </div>

    <h1>Find Your Perfect <br><span class="highlight">Dream Car</span></h1>
    <p>Browse our hand-curated fleet of ultra-premium vehicles. <br>Every car, a masterpiece of engineering and performance.</p>

    <div style="margin-top:36px; display:flex; gap:16px; justify-content:center;">
      <a href="#inventory" class="btn-search" style="padding:14px 32px; font-size:1rem; text-decoration:none;">
        <i class="fa-solid fa-car"></i> View Available Stock
      </a>
    </div>

    <div class="hero-stats">
      <div class="hero-stat">
        <div class="hero-stat-num">4,675</div>
        <div class="hero-stat-label">Vehicles Available</div>
      </div>
      <div class="hero-stat">
        <div class="hero-stat-num">50<span>+</span></div>
        <div class="hero-stat-label">Premium Brands</div>
      </div>
      <div class="hero-stat">
        <div class="hero-stat-num">100<span>%</span></div>
        <div class="hero-stat-label">Verified Stock</div>
      </div>
      <div class="hero-stat">
        <div class="hero-stat-num">5<span>&#9733;</span></div>
        <div class="hero-stat-label">Client Rating</div>
      </div>
    </div>
  </div>

  <div class="scroll-cue">
    <i class="fa-solid fa-chevron-down"></i>
    Explore
  </div>
</section>

<div class="search-section" style="margin-top:-60px; position:relative; z-index:20; padding:0 60px;">
  <div class="search-card">
    <div class="search-group" style="flex:2;">
      <label><i class="fa-solid fa-magnifying-glass"></i> Keyword</label>
      <input type="text" id="carSearch" placeholder="Brand or model...">
    </div>

    <div class="search-group" style="flex:1;">
      <label><i class="fa-solid fa-gas-pump"></i> Fuel Type</label>
      <select id="fuelFilter">
        <option value="">All</option>
        <option value="petrol">Petrol</option>
        <option value="diesel">Diesel</option>
        <option value="electric">Electric</option>
        <option value="hybrid">Hybrid</option>
      </select>
    </div>

    <div class="search-group" style="flex:1;">
      <label><i class="fa-solid fa-indian-rupee-sign"></i> Max Price</label>
      <input type="number" id="priceFilter" placeholder="No limit">
    </div>

    <div class="search-group" style="flex:1;">
      <label><i class="fa-solid fa-sort"></i> Sort By</label>
      <select id="sortFilter">
        <option value="default">Default</option>
        <option value="low">Price: Low to High</option>
        <option value="high">Price: High to Low</option>
      </select>
    </div>

    <div class="search-group" style="align-self:flex-end;">
      <button type="button" class="btn-search" onclick="filterCards()">
        Apply <i class="fa-solid fa-sliders"></i>
      </button>
    </div>
  </div>
</div>

<div class="section" id="inventory">
  <div class="section-head">
    <div class="section-head-left">
      <div class="eyebrow"><i class="fa-solid fa-layer-group"></i> &nbsp;LIVE INVENTORY</div>
      <h2>Explore Our Collection</h2>
      <p>Handpicked vehicles available right now - quality guaranteed.</p>
    </div>
  </div>

  <div class="grid" id="cardGrid">
<%
    try (Connection con = DBConnection.getConnection();
         Statement st = con.createStatement();
         ResultSet rs = st.executeQuery("SELECT * FROM cars ORDER BY id DESC")) {

        boolean hasCars = false;
        int cardIndex = 0;

        while (rs.next()) {
            hasCars = true;
            cardIndex++;

            int carId = rs.getInt("id");

            String image = rs.getString("image");
            String imagePath = "uploads/" + ((image != null && !image.trim().isEmpty()) ? image : "default.png");

            String fuel = rs.getString("fuel_type");
            String fuelLower = (fuel != null) ? fuel.toLowerCase() : "";
            String fuelClass;

            switch (fuelLower) {
                case "petrol":
                    fuelClass = "fuel-petrol";
                    break;
                case "diesel":
                    fuelClass = "fuel-diesel";
                    break;
                case "electric":
                    fuelClass = "fuel-electric";
                    break;
                case "hybrid":
                    fuelClass = "fuel-hybrid";
                    break;
                default:
                    fuelClass = "fuel-default";
            }

            String desc = rs.getString("description");
            if (desc != null && desc.length() > 100) {
                desc = desc.substring(0, 97) + "...";
            }

            String rawPrice = rs.getString("price");
            String priceDigits = "0";
            if (rawPrice != null) {
                priceDigits = rawPrice.replaceAll("[^0-9]", "");
                if (priceDigits.isEmpty()) {
                    priceDigits = "0";
                }
            }

            long priceValue = 0L;
            try {
                priceValue = Long.parseLong(priceDigits);
            } catch (Exception ignored) {
                priceValue = 0L;
            }

            String formattedPrice;
            try {
                NumberFormat nf = NumberFormat.getCurrencyInstance(Locale.forLanguageTag("en-IN"));
                formattedPrice = nf.format(priceValue);
            } catch (Exception ex) {
                formattedPrice = "₹ " + priceValue;
            }

            String brand = rs.getString("brand");
            if (brand == null) brand = "Unknown";

            String model = rs.getString("model");
            if (model == null) model = "Model";

            String status = "";
            try {
                status = rs.getString("status");
            } catch (Exception ignored) {}

            boolean isSold = "Sold".equalsIgnoreCase(status);
            boolean isNew = cardIndex <= 3;
%>
    <div class="card"
         data-fuel="<%= esc(fuelLower) %>"
         data-brand="<%= esc(brand.toLowerCase()) %>"
         data-model="<%= esc(model.toLowerCase()) %>"
         data-price="<%= priceValue %>"
         onclick="goToDetails(<%= carId %>)">

      <div class="card-img">
        <span class="fuel-badge <%= esc(fuelClass) %>">
          <i class="fa-solid fa-gas-pump"></i> <%= (fuel != null && !fuel.trim().isEmpty()) ? esc(fuel) : "N/A" %>
        </span>

        <div class="fav-btn">
          <i class="fa-regular fa-heart"></i>
        </div>

        <img src="<%= esc(imagePath) %>"
             alt="<%= esc(brand) %>"
             onerror="this.src='https://via.placeholder.com/600x400?text=No+Image+Available';"
             loading="lazy">

        <% if (isSold) { %>
          <div style="position:absolute; inset:0; background:rgba(0,0,0,0.4); display:flex; align-items:center; justify-content:center; backdrop-filter:blur(2px);">
            <div style="background:#ef4444; color:#fff; padding:6px 16px; border-radius:8px; font-weight:800; font-size:0.8rem; letter-spacing:1px; transform:rotate(-5deg); box-shadow:0 4px 12px rgba(0,0,0,0.2);">SOLD</div>
          </div>
        <% } else if (isNew) { %>
          <div class="card-badge-new">NEW</div>
        <% } %>
      </div>

      <div class="card-body">
        <div class="card-brand"><%= esc(brand.toUpperCase()) %></div>
        <div class="card-name"><%= esc(brand) %> <%= esc(model) %></div>
        <div class="card-price"><%= esc(formattedPrice) %></div>

        <div class="card-specs">
          <div class="spec-item"><i class="fa-solid fa-gas-pump"></i> <%= (fuel != null && !fuel.trim().isEmpty()) ? esc(fuel) : "N/A" %></div>
          <div class="spec-item"><i class="fa-solid fa-shield-halved"></i> Verified</div>
          <div class="spec-item"><i class="fa-solid fa-star"></i> Premium</div>
        </div>

        <p class="card-desc"><%= (desc != null && !desc.trim().isEmpty()) ? esc(desc) : "A premium vehicle from our exclusive collection." %></p>

        <div class="card-footer">
          <a href="carDetails.jsp?id=<%= carId %>" class="card-cta" onclick="event.stopPropagation();">
            View Details <i class="fa-solid fa-arrow-right"></i>
          </a>

          <button type="button"
                  class="btn-enquire"
                  <%= isSold ? "disabled" : "" %>
                  onclick="event.stopPropagation(); goToDetails(<%= carId %>);">
            <i class="fa-solid fa-phone"></i> <%= isSold ? "Sold Out" : "Enquire" %>
          </button>
        </div>
      </div>
    </div>
<%
        }

        if (!hasCars) {
%>
    <div class="empty-state">
      <i class="fa-solid fa-car-burst"></i>
      <h3>No vehicles in inventory yet.</h3>
      <p>Admin can add new vehicles from the dashboard.</p>
    </div>
<%
        }
    } catch (Exception e) {
%>
    <div class="empty-state" style="color:#ef4444;">
      <i class="fa-solid fa-circle-exclamation"></i>
      <h3>Database Error</h3>
      <p>Could not load inventory. Please check your database connection.</p>
    </div>
<%
    }
%>
  </div>
</div>

<section class="features-section" id="features">
  <div class="features-inner">
    <div class="features-header">
      <div class="eyebrow"><i class="fa-solid fa-trophy"></i> &nbsp;WHY CHOOSE US</div>
      <h2>The DriveZone Advantage</h2>
      <p>We go beyond just selling cars - we deliver an unparalleled ownership experience.</p>
    </div>

    <div class="features-grid">
      <div class="feature-card">
        <div class="feature-icon"><i class="fa-solid fa-shield-halved"></i></div>
        <h3>100% Verified Stock</h3>
        <p>Every vehicle in our inventory goes through a rigorous 150-point quality inspection before listing.</p>
      </div>

      <div class="feature-card">
        <div class="feature-icon"><i class="fa-solid fa-handshake"></i></div>
        <h3>No-Hassle Financing</h3>
        <p>Get pre-approved in minutes with competitive rates from our network of premium finance partners.</p>
      </div>

      <div class="feature-card">
        <div class="feature-icon"><i class="fa-solid fa-truck-fast"></i></div>
        <h3>Home Delivery</h3>
        <p>Your dream car delivered to your doorstep. We handle all paperwork and logistics seamlessly.</p>
      </div>

      <div class="feature-card">
        <div class="feature-icon"><i class="fa-solid fa-rotate-left"></i></div>
        <h3>7-Day Return Policy</h3>
        <p>Not satisfied? Return within 7 days, no questions asked. We stand behind every vehicle we sell.</p>
      </div>

      <div class="feature-card">
        <div class="feature-icon"><i class="fa-solid fa-headset"></i></div>
        <h3>24/7 Expert Support</h3>
        <p>Our team of automotive experts is available round the clock to assist you at every step.</p>
      </div>

      <div class="feature-card">
        <div class="feature-icon"><i class="fa-solid fa-award"></i></div>
        <h3>Award-Winning Service</h3>
        <p>Recognized as the #1 premium car dealership for 5 consecutive years by AutoExcellence awards.</p>
      </div>
    </div>
  </div>
</section>

<footer class="footer">
  <div class="footer-inner">
    <div class="footer-top">
      <div class="footer-brand">
        <a class="logo" href="#home">
          <div class="logo-icon"><i class="fa-solid fa-car-side"></i></div>
          Drive<span>Zone</span>
        </a>
        <p class="footer-desc">Your premier destination for ultra-premium vehicles. We connect passionate drivers with the car of their dreams.</p>
      </div>

      <div class="footer-col">
        <h4>Quick Links</h4>
        <ul>
          <li><a href="#home">Home</a></li>
          <li><a href="#inventory">Inventory</a></li>
          <li><a href="#features">Why Us</a></li>
        </ul>
      </div>

      <div class="footer-col">
        <h4>Fuel Types</h4>
        <ul>
          <li><a href="#">Petrol Cars</a></li>
          <li><a href="#">Diesel Cars</a></li>
          <li><a href="#">Electric Cars</a></li>
          <li><a href="#">Hybrid Cars</a></li>
        </ul>
      </div>

      <div class="footer-col">
        <h4>Contact</h4>
        <ul>
          <li><a href="#"><i class="fa-solid fa-phone"></i> &nbsp;+91 98765 43210</a></li>
          <li><a href="#"><i class="fa-solid fa-envelope"></i> &nbsp;hello@drivezone.in</a></li>
          <li><a href="#"><i class="fa-solid fa-location-dot"></i> &nbsp;Mumbai, India</a></li>
        </ul>
      </div>
    </div>

    <div class="footer-bottom">
      <span style="color:rgba(255,255,255,0.3);">&copy; 2026 <span>DriveZone</span> - Premium Showroom. All rights reserved.</span>
      <span>Crafted with <i class="fa-solid fa-heart" style="color:#ef4444;"></i> for car enthusiasts.</span>
    </div>
  </div>
</footer>

<div class="modal-overlay" id="enquiryModal">
  <div class="modal-card">
    <div class="modal-head">
      <h3 class="modal-title">My Enquiry Status</h3>
      <i class="fa-solid fa-circle-xmark modal-close" onclick="closeEnquiryModal()"></i>
    </div>

    <div class="modal-body">
<%
		String userEmail = (String) session.getAttribute("userEmail");

		try (Connection conEnq = DBConnection.getConnection();
    		 PreparedStatement psEnq = conEnq.prepareStatement(
         		"SELECT e.*, c.brand, c.model, c.image " +
         		"FROM enquiries e " +
         		"JOIN cars c ON e.car_id = c.id " +
         		"WHERE e.user_email = ? " +
         		"ORDER BY e.created_at DESC")) {

    	psEnq.setString(1, userEmail);

        try (ResultSet rsEnq = psEnq.executeQuery()) {
            boolean anyEnq = false;

            while (rsEnq.next()) {
                anyEnq = true;

                String enqStatus = rsEnq.getString("status");
                String enqStCls = "st-pending";
                if ("Verified".equalsIgnoreCase(enqStatus) || "Approved".equalsIgnoreCase(enqStatus)) {
                    enqStCls = "st-verified";
                }

                String enqImage = rsEnq.getString("image");
                if (enqImage == null || enqImage.trim().isEmpty()) {
                    enqImage = "default.png";
                }

                String enqBrand = rsEnq.getString("brand");
                if (enqBrand == null) enqBrand = "Unknown";

                String enqModel = rsEnq.getString("model");
                if (enqModel == null) enqModel = "Model";

                String enqMessage = rsEnq.getString("message");
                if (enqMessage == null || enqMessage.trim().isEmpty()) {
                    enqMessage = "No message provided.";
                }
%>
      <div class="enq-list-item">
        <img src="uploads/<%= esc(enqImage) %>" class="enq-car-img" alt="Car" onerror="this.src='https://via.placeholder.com/80x50?text=N/A';">
        <div class="enq-info">
          <div class="enq-car-name"><%= esc(enqBrand) %> <%= esc(enqModel) %></div>
          <div class="enq-msg"><%= esc(enqMessage) %></div>
        </div>
        <div class="enq-status <%= esc(enqStCls) %>"><%= (enqStatus != null && !enqStatus.trim().isEmpty()) ? esc(enqStatus) : "Pending" %></div>
      </div>
<%
            }

            if (!anyEnq) {
%>
      <div style="text-align:center; padding:40px; color:var(--gray);">
        <i class="fa-solid fa-inbox" style="font-size:3rem; margin-bottom:16px; opacity:0.2;"></i>
        <p>No enquiries found for your account.</p>
      </div>
<%
            }
        }
    } catch (Exception e) {
%>
      <p style="color:#ef4444;">Error loading enquiries.</p>
<%
    }
%>
    </div>
  </div>
</div>

<script>
function goToDetails(id) {
    window.location.href = 'carDetails.jsp?id=' + id;
}

function openEnquiryModal() {
    const modal = document.getElementById('enquiryModal');
    if (modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }
}

function closeEnquiryModal() {
    const modal = document.getElementById('enquiryModal');
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = '';
    }
}

window.addEventListener('click', function(event) {
    const modal = document.getElementById('enquiryModal');
    if (modal && event.target === modal) {
        closeEnquiryModal();
    }
});

window.addEventListener('scroll', function() {
    const navbar = document.getElementById('navbar');
    if (navbar) {
        navbar.classList.toggle('scrolled', window.scrollY > 50);
    }
});

function filterCards() {
    const searchInput = document.getElementById('carSearch');
    const fuelFilter = document.getElementById('fuelFilter');
    const priceFilter = document.getElementById('priceFilter');
    const sortFilter = document.getElementById('sortFilter');
    const grid = document.getElementById('cardGrid');

    if (!searchInput || !fuelFilter || !priceFilter || !sortFilter || !grid) return;

    const q = searchInput.value.toLowerCase().trim();
    const f = fuelFilter.value.toLowerCase();
    const maxPStr = priceFilter.value.trim();
    const maxP = maxPStr ? parseFloat(maxPStr) : Infinity;
    const sortVal = sortFilter.value;

    const cards = Array.from(grid.querySelectorAll('.card'));

    cards.forEach(function(card) {
        const cardBrand = card.dataset.brand || '';
        const cardModel = card.dataset.model || '';
        const cardFuel = card.dataset.fuel || '';
        const cardPrice = parseFloat(card.dataset.price || '0');

        const matchQ = !q || cardBrand.includes(q) || cardModel.includes(q);
        const matchF = !f || cardFuel === f;
        const matchP = cardPrice <= maxP;

        card.style.display = (matchQ && matchF && matchP) ? 'flex' : 'none';
    });

    if (sortVal !== 'default') {
        const visibleCards = cards.filter(function(card) {
            return card.style.display !== 'none';
        });

        visibleCards.sort(function(a, b) {
            const pA = parseFloat(a.dataset.price || '0');
            const pB = parseFloat(b.dataset.price || '0');
            return sortVal === 'low' ? pA - pB : pB - pA;
        });

        visibleCards.forEach(function(card) {
            grid.appendChild(card);
        });
    }
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
    if (!themeIcon) return;

    if (document.documentElement.getAttribute('data-theme') === 'dark') {
        themeIcon.className = 'fa-solid fa-sun';
    } else {
        themeIcon.className = 'fa-solid fa-moon';
    }
}

document.addEventListener('DOMContentLoaded', function() {
    updateThemeIcon();

    const searchInput = document.getElementById('carSearch');
    if (searchInput) {
        searchInput.addEventListener('input', filterCards);
    }

    document.querySelectorAll('.fav-btn').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            const ico = btn.querySelector('i');
            if (!ico) return;

            const isRegular = ico.className.includes('fa-regular');
            ico.className = isRegular ? 'fa-solid fa-heart' : 'fa-regular fa-heart';
            btn.style.color = isRegular ? '#ef4444' : '#9ca3af';
        });
    });
});
</script>

</body>
</html>