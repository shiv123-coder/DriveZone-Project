<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AutoLuxe — Create Account</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
  const savedTheme = localStorage.getItem('theme') || 'light';
  document.documentElement.setAttribute('data-theme', savedTheme);
</script>

<style>
  *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

  :root {
    --sky: #1a56db;
    --sky-dark: #1341b5;
    --navy: #f8fafc;
    --border: rgba(0,0,0,0.1);
    --muted: #64748b;
    --text: #0f172a;
    --card-bg: rgba(255,255,255,0.85);
    --input-bg: rgba(0,0,0,0.03);
    --input-bg-focus: rgba(0,0,0,0.05);
    --text-strong: #000;
  }

  [data-theme="dark"] {
    --sky: #0ea5e9;
    --sky-dark: #0284c7;
    --navy: #0f172a;
    --border: rgba(255,255,255,0.1);
    --muted: #94a3b8;
    --text: #f1f5f9;
    --card-bg: rgba(15,23,42,0.75);
    --input-bg: rgba(255,255,255,0.04);
    --input-bg-focus: rgba(255,255,255,0.07);
    --text-strong: #fff;
  }

  body {
    font-family: 'Poppins', sans-serif;
    background: var(--navy);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    position: relative;
    padding: 20px;
  }

  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background:
      radial-gradient(ellipse 70% 60% at 90% 10%, rgba(14,165,233,0.18) 0%, transparent 60%),
      radial-gradient(ellipse 60% 70% at 10% 90%, rgba(56,189,248,0.12) 0%, transparent 60%);
    z-index: 0;
  }

  .orb {
    position: fixed;
    border-radius: 50%;
    filter: blur(90px);
    z-index: 0;
    animation: drift 18s ease-in-out infinite alternate;
  }
  .orb-1 { width:450px; height:450px; background: rgba(14,165,233,0.2); top:-180px; right:-180px; }
  .orb-2 { width:380px; height:380px; background: rgba(2,132,199,0.18); bottom:-130px; left:-130px; animation-delay:-9s; }

  @keyframes drift {
    0%   { transform: translate(0,0) scale(1); }
    100% { transform: translate(30px,25px) scale(1.07); }
  }

  .wrapper {
    position: relative;
    z-index: 10;
    display: flex;
    width: 960px;
    background: var(--card-bg);
    border-radius: 24px;
    overflow: hidden;
    box-shadow: 0 20px 60px rgba(0,0,0,0.18);
  }

  .hero-panel {
    width: 45%;
    background: url('https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=1400&auto=format&fit=crop') center/cover no-repeat;
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    padding: 50px 40px;
    min-height: 600px;
  }

  .hero-panel::before {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(160deg, rgba(14,165,233,0.45) 0%, rgba(15,23,42,0.95) 80%);
  }

  .brand {
    position: absolute;
    top: 40px;
    left: 40px;
    z-index: 2;
    color: #fff;
    font-size: 1.15rem;
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 8px;
    letter-spacing: 1px;
  }

  .brand i { color: var(--sky); }

  .hero-content { position: relative; z-index: 2; }

  .hero-content h1 {
    font-size: 2.6rem;
    font-weight: 800;
    line-height: 1.1;
    color: #fff;
    margin-bottom: 16px;
    letter-spacing: -1px;
  }

  .hero-content h1 span { color: var(--sky); display: block; }

  .hero-content p {
    color: #cbd5e1;
    font-size: 0.9rem;
    line-height: 1.7;
    font-weight: 300;
  }

  .perks { margin-top: 24px; display: flex; flex-direction: column; gap: 10px; }

  .perk {
    display: flex;
    align-items: center;
    gap: 10px;
    color: #94a3b8;
    font-size: 0.85rem;
  }

  .perk i { color: var(--sky); width: 16px; }

  .form-panel {
    width: 55%;
    padding: 55px 50px;
    display: flex;
    flex-direction: column;
    justify-content: center;
  }

  .form-panel .head { margin-bottom: 32px; }
  .form-panel .head h2 { font-size: 1.75rem; font-weight: 700; color: var(--text); margin-bottom: 6px; }
  .form-panel .head p  { color: var(--muted); font-size: 0.88rem; }

  .field { position: relative; margin-bottom: 20px; }

  .field .icon {
    position: absolute;
    left: 18px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--muted);
    font-size: 0.88rem;
    transition: color 0.3s;
    pointer-events: none;
    z-index: 1;
  }

  .field input {
    width: 100%;
    padding: 14px 44px 14px 46px;
    background: var(--input-bg);
    border: 1px solid var(--border);
    border-radius: 14px;
    color: var(--text);
    font-family: 'Poppins', sans-serif;
    font-size: 0.93rem;
    outline: none;
    transition: all 0.3s;
  }

  .field input::placeholder { color: var(--muted); }

  .field input:focus {
    background: var(--input-bg-focus);
    border-color: var(--sky);
    box-shadow: 0 0 0 3px rgba(14,165,233,0.2);
  }

  .field input:focus ~ .icon { color: var(--sky); }

  .eye-toggle {
    position: absolute;
    right: 18px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--muted);
    cursor: pointer;
    font-size: 0.88rem;
    transition: color 0.2s;
  }

  .eye-toggle:hover { color: var(--sky); }

  .strength-wrap { margin-top: 8px; display: flex; gap: 5px; padding-left: 4px; }
  .strength-bar { flex: 1; height: 3px; border-radius: 99px; background: rgba(255,255,255,0.1); transition: background 0.4s; }
  .strength-label { font-size: 0.75rem; color: var(--muted); margin-top: 4px; padding-left: 4px; transition: color 0.3s; }

  .btn-submit {
    width: 100%;
    padding: 15px;
    margin-top: 6px;
    background: linear-gradient(135deg, var(--sky) 0%, var(--sky-dark) 100%);
    color: #fff;
    border: none;
    border-radius: 14px;
    font-family: 'Poppins', sans-serif;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    transition: all 0.3s;
    box-shadow: 0 8px 24px rgba(14,165,233,0.35);
  }

  .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 14px 30px rgba(14,165,233,0.45); }
  .btn-submit:active { transform: translateY(0); }

  .form-footer { text-align: center; margin-top: 20px; color: var(--muted); font-size: 0.88rem; }
  .form-footer a { color: var(--sky); text-decoration: none; font-weight: 600; }
  .form-footer a:hover { color: #38bdf8; }

  @media (max-width: 900px) {
    .wrapper { flex-direction: column; width: 95%; }
    .hero-panel { width: 100%; min-height: 220px; }
    .form-panel { width: 100%; padding: 40px 28px; }
    .hero-content h1 { font-size: 1.8rem; }
  }
</style>
</head>
<body>

<button onclick="toggleTheme()" title="Toggle Theme"
  style="position:absolute; top:20px; right:20px; z-index:100; background:var(--card-bg); border:1px solid var(--border); border-radius:50%; width:44px; height:44px; color:var(--text); cursor:pointer; display:flex; align-items:center; justify-content:center; box-shadow:0 4px 12px rgba(0,0,0,0.1);">
  <i class="fa-solid fa-moon" id="themeIcon"></i>
</button>

<div class="orb orb-1"></div>
<div class="orb orb-2"></div>

<div class="wrapper">
  <div class="hero-panel">
    <div class="brand"><i class="fa-solid fa-car-side"></i> AutoLuxe</div>
    <div class="hero-content">
      <h1>Join the <span>Elite.</span></h1>
      <p>Create your account and step into a world of premium automotive excellence.</p>
      <div class="perks">
        <div class="perk"><i class="fa-solid fa-check-circle"></i> Access exclusive premium listings</div>
        <div class="perk"><i class="fa-solid fa-check-circle"></i> Real-time inventory management</div>
        <div class="perk"><i class="fa-solid fa-check-circle"></i> Secure & professional dashboard</div>
      </div>
    </div>
  </div>

  <div class="form-panel">
    <div class="head">
      <h2>Create Account &#x2728;</h2>
      <p>Fill in your details below to get started.</p>
    </div>

    <form method="post" id="regForm" autocomplete="off">
      <div class="field">
        <input type="text" name="username" placeholder="Full name" required autocomplete="off">
        <i class="fa-regular fa-user icon"></i>
      </div>

      <div class="field">
        <input type="email" name="email" placeholder="Email address" required autocomplete="off">
        <i class="fa-regular fa-envelope icon"></i>
      </div>

      <div class="field">
        <input type="password" name="password" id="password" placeholder="Create a password" required oninput="checkStrength(this.value)" autocomplete="new-password">
        <i class="fa-solid fa-lock icon"></i>
        <span class="eye-toggle" onclick="togglePwd()"><i class="fa-regular fa-eye" id="eyeIcon"></i></span>
      </div>

      <div class="strength-wrap">
        <div class="strength-bar" id="b1"></div>
        <div class="strength-bar" id="b2"></div>
        <div class="strength-bar" id="b3"></div>
        <div class="strength-bar" id="b4"></div>
      </div>
      <p class="strength-label" id="strengthLabel">Password strength</p>

      <button type="submit" class="btn-submit" style="margin-top:20px;">
        Create Account <i class="fa-solid fa-user-plus"></i>
      </button>
    </form>

    <div class="form-footer">
      <p>Already a member? <a href="login.jsp">Sign in here</a></p>
    </div>
  </div>
</div>

<script>
function togglePwd() {
  const p = document.getElementById('password');
  const ico = document.getElementById('eyeIcon');
  if (p.type === 'password') {
    p.type = 'text';
    ico.className = 'fa-regular fa-eye-slash';
  } else {
    p.type = 'password';
    ico.className = 'fa-regular fa-eye';
  }
}

function checkStrength(v) {
  const bars = [
    document.getElementById('b1'),
    document.getElementById('b2'),
    document.getElementById('b3'),
    document.getElementById('b4')
  ];
  const label = document.getElementById('strengthLabel');
  let score = 0;

  if (v.length >= 6) score++;
  if (v.length >= 10) score++;
  if (/[A-Z]/.test(v) && /[0-9]/.test(v)) score++;
  if (/[^a-zA-Z0-9]/.test(v)) score++;

  const colors = ['#ef4444', '#f97316', '#eab308', '#22c55e'];
  const labels = ['Weak', 'Fair', 'Good', 'Strong'];

  bars.forEach((b, i) => {
    b.style.background = i < score ? colors[score - 1] : 'rgba(255,255,255,0.1)';
  });

  label.style.color = score > 0 ? colors[score - 1] : '#94a3b8';
  label.textContent = score > 0 ? labels[score - 1] + ' password' : 'Password strength';
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

document.addEventListener('DOMContentLoaded', updateThemeIcon);
</script>

<%
String username = request.getParameter("username");
String email = request.getParameter("email");
String password = request.getParameter("password");

if ("POST".equalsIgnoreCase(request.getMethod())) {

    if (username != null) username = username.trim();
    if (email != null) email = email.trim();
    if (password != null) password = password.trim();

    if (username == null || username.isEmpty() ||
        email == null || email.isEmpty() ||
        password == null || password.isEmpty()) {
%>
<script>
Swal.fire({
  icon: 'warning',
  title: 'Missing Fields',
  text: 'Please fill all fields.',
  background: '#0f172a',
  color: '#f1f5f9',
  confirmButtonColor: '#0ea5e9'
});
</script>
<%
    } else {
        Connection con = null;
        PreparedStatement check = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            if (con == null) {
%>
<script>
Swal.fire({
  icon: 'error',
  title: 'Database Error',
  text: 'Database connection failed.',
  background: '#0f172a',
  color: '#f1f5f9',
  confirmButtonColor: '#0ea5e9'
});
</script>
<%
            } else {
                check = con.prepareStatement("SELECT id FROM users WHERE email = ?");
                check.setString(1, email);
                rs = check.executeQuery();

                if (rs.next()) {
%>
<script>
Swal.fire({
  icon: 'error',
  title: 'Already Registered',
  text: 'This email is already in use.',
  background: '#0f172a',
  color: '#f1f5f9',
  confirmButtonColor: '#0ea5e9'
});
</script>
<%
                } else {
                    ps = con.prepareStatement("INSERT INTO users (username, email, password) VALUES (?, ?, ?)");
                    ps.setString(1, username);
                    ps.setString(2, email);
                    ps.setString(3, password);

                    int result = ps.executeUpdate();

                    if (result > 0) {
%>
<script>
Swal.fire({
  icon: 'success',
  title: 'Account Created!',
  text: 'You can now sign in to AutoLuxe.',
  background: '#0f172a',
  color: '#f1f5f9',
  confirmButtonColor: '#0ea5e9'
}).then(() => {
  window.location = 'login.jsp';
});
</script>
<%
                    } else {
%>
<script>
Swal.fire({
  icon: 'error',
  title: 'Registration Failed',
  text: 'Unable to create account. Please try again.',
  background: '#0f172a',
  color: '#f1f5f9',
  confirmButtonColor: '#0ea5e9'
});
</script>
<%
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
%>
<script>
Swal.fire({
  icon: 'error',
  title: 'Server Error',
  text: 'Something went wrong. Check server logs.',
  background: '#0f172a',
  color: '#f1f5f9',
  confirmButtonColor: '#0ea5e9'
});
</script>
<%
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (check != null) check.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
%>

</body>
</html>