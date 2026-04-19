<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>

<%
String alertIcon = null;
String alertTitle = null;
String alertText = null;
String redirectPage = null;

String emailOrUsername = request.getParameter("email");
String password = request.getParameter("password");

if ("POST".equalsIgnoreCase(request.getMethod())) {
    if (emailOrUsername != null) emailOrUsername = emailOrUsername.trim();
    if (password != null) password = password.trim();

    if (emailOrUsername == null || emailOrUsername.isEmpty() || password == null || password.isEmpty()) {
        alertIcon = "error";
        alertTitle = "Missing Details";
        alertText = "Please enter email or username and password.";
    } else if ("SSP".equals(emailOrUsername) && "123456".equals(password)) {
        session.setAttribute("user", "SSP");
        session.setAttribute("role", "admin");
        alertIcon = "success";
        alertTitle = "Welcome Admin!";
        alertText = "Login successful.";
        redirectPage = "admin.jsp";
    } else {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            if (con == null) {
                alertIcon = "error";
                alertTitle = "Database Error";
                alertText = "Unable to connect to database.";
            } else {
                ps = con.prepareStatement(
                    "SELECT id, username, email FROM users WHERE (email = ? OR username = ?) AND password = ?"
                );
                ps.setString(1, emailOrUsername);
                ps.setString(2, emailOrUsername);
                ps.setString(3, password);

                rs = ps.executeQuery();

                if (rs.next()) {
                    session.setAttribute("user", rs.getString("username"));
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("userEmail", rs.getString("email"));
                    session.setAttribute("role", "user");

                    alertIcon = "success";
                    alertTitle = "Welcome Back!";
                    alertText = "Login successful.";
                    redirectPage = "home.jsp";
                } else {
                    alertIcon = "error";
                    alertTitle = "Access Denied";
                    alertText = "Invalid email/username or password.";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            alertIcon = "error";
            alertTitle = "Server Error";
            alertText = "Something went wrong. Please try again.";
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AutoLuxe - Sign In</title>
<meta name="description" content="Sign in to your AutoLuxe account to explore our premium vehicle collection.">

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
(function () {
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.documentElement.setAttribute('data-theme', savedTheme);
})();
</script>

<style>
    *, *::before, *::after {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

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
    }

    body {
        font-family: 'Poppins', sans-serif;
        background: var(--navy);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow-x: hidden;
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

    .orb-1 {
        width: 450px;
        height: 450px;
        background: rgba(14,165,233,0.2);
        top: -180px;
        right: -180px;
    }

    .orb-2 {
        width: 380px;
        height: 380px;
        background: rgba(2,132,199,0.18);
        bottom: -130px;
        left: -130px;
    }

    @keyframes drift {
        0%   { transform: translate(0,0) scale(1); }
        100% { transform: translate(30px,25px) scale(1.07); }
    }

    .theme-btn {
        position: absolute;
        top: 20px;
        right: 20px;
        z-index: 100;
        background: var(--card-bg);
        border: 1px solid var(--border);
        border-radius: 50%;
        width: 44px;
        height: 44px;
        color: var(--text);
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }

    .wrapper {
        position: relative;
        z-index: 10;
        display: flex;
        width: 960px;
        max-width: 100%;
        background: var(--card-bg);
        border-radius: 24px;
        overflow: hidden;
        box-shadow: 0 20px 60px rgba(0,0,0,0.20);
        backdrop-filter: blur(18px);
    }

    .hero-panel {
        width: 45%;
        background: url('https://images.unsplash.com/photo-1617788138017-80ad40651399?q=80&w=1400&auto=format&fit=crop') center/cover no-repeat;
        position: relative;
        display: flex;
        flex-direction: column;
        justify-content: flex-end;
        padding: 50px 40px;
        min-height: 550px;
    }

    .hero-panel::before {
        content: '';
        position: absolute;
        inset: 0;
        background: linear-gradient(160deg, rgba(14,165,233,0.45) 0%, rgba(15,23,42,0.95) 80%);
    }

    .brand {
        z-index: 2;
        color: #fff;
        font-size: 1.15rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: auto;
    }

    .brand i { color: #38bdf8; }

    .hero-content {
        position: relative;
        z-index: 2;
    }

    .hero-content h1 {
        font-size: 2.6rem;
        font-weight: 800;
        line-height: 1.1;
        color: #fff;
        margin-bottom: 16px;
        letter-spacing: -1px;
    }

    .hero-content h1 span {
        color: #38bdf8;
        display: block;
    }

    .hero-content p {
        color: #cbd5e1;
        font-size: 0.95rem;
        font-weight: 300;
    }

    .form-panel {
        width: 55%;
        padding: 55px 50px;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    .head {
        margin-bottom: 32px;
    }

    .head h2 {
        font-size: 1.75rem;
        font-weight: 700;
        color: var(--text);
        margin-bottom: 6px;
    }

    .head p {
        color: var(--muted);
        font-size: 0.88rem;
    }

    .field {
        position: relative;
        margin-bottom: 20px;
    }

    .field .icon {
        position: absolute;
        left: 18px;
        top: 50%;
        transform: translateY(-50%);
        color: var(--muted);
        font-size: 0.88rem;
        pointer-events: none;
        z-index: 1;
    }

    .field .eye-toggle {
        position: absolute;
        right: 18px;
        top: 50%;
        transform: translateY(-50%);
        color: var(--muted);
        cursor: pointer;
    }

    .field input {
        width: 100%;
        padding: 14px 46px 14px 46px;
        background: var(--input-bg);
        border: 1px solid var(--border);
        border-radius: 14px;
        color: var(--text);
        font-family: 'Poppins', sans-serif;
        font-size: 0.93rem;
        outline: none;
        transition: all 0.3s;
    }

    .field input::placeholder {
        color: var(--muted);
    }

    .field input:focus {
        background: var(--input-bg-focus);
        border-color: var(--sky);
        box-shadow: 0 0 0 3px rgba(14,165,233,0.2);
    }

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

    .btn-submit:hover {
        transform: translateY(-2px);
        box-shadow: 0 14px 30px rgba(14,165,233,0.45);
    }

    .form-footer {
        text-align: center;
        margin-top: 20px;
        color: var(--muted);
        font-size: 0.88rem;
    }

    .form-footer a {
        color: var(--sky);
        text-decoration: none;
        font-weight: 600;
    }

    .trust-strip {
        display: flex;
        justify-content: center;
        gap: 20px;
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid var(--border);
        flex-wrap: wrap;
    }

    .trust-item {
        font-size: 0.72rem;
        color: var(--muted);
        display: flex;
        align-items: center;
        gap: 6px;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .trust-item i {
        color: var(--sky);
    }

    @media (max-width: 900px) {
        .wrapper {
            flex-direction: column;
        }

        .hero-panel,
        .form-panel {
            width: 100%;
        }

        .hero-panel {
            min-height: 280px;
        }

        .form-panel {
            padding: 40px 28px;
        }
    }
</style>
</head>
<body>

<button type="button" onclick="toggleTheme()" title="Toggle Theme" class="theme-btn">
    <i class="fa-solid fa-moon" id="themeIcon"></i>
</button>

<div class="orb orb-1"></div>
<div class="orb orb-2"></div>

<div class="wrapper">
    <div class="hero-panel">
        <div class="brand">
            <i class="fa-solid fa-car-side"></i> AutoLuxe
        </div>
        <div class="hero-content">
            <h1>Welcome back <span>to Elite.</span></h1>
            <p>Sign in to your premium account and continue your automotive journey.</p>
        </div>
    </div>

    <div class="form-panel">
        <div class="head">
            <h2>Welcome back &#128075;</h2>
            <p>Enter your credentials to access your showroom.</p>
        </div>

        <form method="post" action="login.jsp" id="loginForm" autocomplete="off">
            <div class="field">
                <input type="text" name="email" id="email" placeholder="Email or Username" required>
                <i class="fa-regular fa-envelope icon"></i>
            </div>

            <div class="field">
                <input type="password" name="password" id="password" placeholder="Password" required autocomplete="current-password">
                <i class="fa-solid fa-lock icon"></i>
                <span class="eye-toggle" onclick="togglePassword()">
                    <i class="fa-regular fa-eye" id="eyeIcon"></i>
                </span>
            </div>

            <button type="submit" class="btn-submit">
                Sign In to AutoLuxe <i class="fa-solid fa-right-to-bracket"></i>
            </button>
        </form>

        <div class="form-footer">
            <p>New to AutoLuxe? <a href="register.jsp">Create a free account</a></p>
        </div>

        <div class="trust-strip">
            <div class="trust-item"><i class="fa-solid fa-shield-halved"></i> Secure</div>
            <div class="trust-item"><i class="fa-solid fa-lock"></i> Encrypted</div>
            <div class="trust-item"><i class="fa-solid fa-circle-check"></i> Verified</div>
        </div>
    </div>
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

function togglePassword() {
    const passwordField = document.getElementById('password');
    const eyeIcon = document.getElementById('eyeIcon');

    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        eyeIcon.className = 'fa-regular fa-eye-slash';
    } else {
        passwordField.type = 'password';
        eyeIcon.className = 'fa-regular fa-eye';
    }
}

document.addEventListener('DOMContentLoaded', updateThemeIcon);
</script>

<% if (alertIcon != null) { %>
<script>
Swal.fire({
    icon: '<%= alertIcon %>',
    title: '<%= alertTitle %>',
    text: '<%= alertText %>',
    background: '#0f172a',
    color: '#f1f5f9',
    confirmButtonColor: '#0ea5e9',
    showConfirmButton: <%= "success".equals(alertIcon) ? "false" : "true" %>,
    timer: <%= "success".equals(alertIcon) ? "1500" : "null" %>
}).then(() => {
    <% if (redirectPage != null) { %>
    window.location = '<%= redirectPage %>';
    <% } %>
});
</script>
<% } %>

</body>
</html>