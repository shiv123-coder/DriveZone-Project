<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    Global Preloader Component
    Requirements:
    1. Only runs in production (non-localhost)
    2. Premium, smooth animation
    3. Hides when page is fully loaded
    4. Seamless exit transition
--%>
<style>
    :root {
        --preloader-bg: #0f172a;
        --preloader-accent: #3b82f6;
        --preloader-text: #f8fafc;
    }

    [data-theme="light"] {
        --preloader-bg: #ffffff;
        --preloader-accent: #1a56db;
        --preloader-text: #1e293b;
    }

    .preloader-overlay {
        position: fixed;
        inset: 0;
        width: 100%;
        height: 100%;
        background: var(--preloader-bg);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        z-index: 99999;
        transition: opacity 0.6s cubic-bezier(0.4, 0, 0.2, 1), visibility 0.6s;
        backdrop-filter: blur(10px);
    }

    .preloader-overlay.preloader-hidden {
        opacity: 0;
        visibility: hidden;
        pointer-events: none;
        transform: scale(1.05);
    }

    .preloader-content {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 24px;
        position: relative;
    }

    /* Premium Spinner Design */
    .preloader-visual {
        position: relative;
        width: 80px;
        height: 80px;
    }

    .preloader-ring {
        position: absolute;
        inset: 0;
        border: 4px solid rgba(59, 130, 246, 0.1);
        border-radius: 50%;
    }

    .preloader-ring-active {
        position: absolute;
        inset: 0;
        border: 4px solid transparent;
        border-top-color: var(--preloader-accent);
        border-radius: 50%;
        animation: preloader-spin 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
    }

    .preloader-orb {
        position: absolute;
        inset: 20px;
        background: linear-gradient(135deg, var(--preloader-accent), #60a5fa);
        border-radius: 50%;
        filter: blur(12px);
        opacity: 0.6;
        animation: preloader-pulse 2s ease-in-out infinite;
    }

    .preloader-text {
        font-family: 'Inter', 'Poppins', sans-serif;
        font-size: 1.1rem;
        font-weight: 600;
        color: var(--preloader-text);
        letter-spacing: 2px;
        text-transform: uppercase;
        display: flex;
        align-items: center;
        gap: 4px;
    }

    .preloader-dots span {
        animation: preloader-dots 1.5s infinite;
        display: inline-block;
    }

    .preloader-dots span:nth-child(2) { animation-delay: 0.2s; }
    .preloader-dots span:nth-child(3) { animation-delay: 0.4s; }

    @keyframes preloader-spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    @keyframes preloader-pulse {
        0%, 100% { transform: scale(0.8); opacity: 0.4; }
        50% { transform: scale(1.1); opacity: 0.7; }
    }

    @keyframes preloader-dots {
        0%, 20% { opacity: 0; transform: translateY(0); }
        50% { opacity: 1; transform: translateY(-3px); }
        80%, 100% { opacity: 0; transform: translateY(0); }
    }

    /* Disable scroll utility */
    .preloader-no-scroll {
        overflow: hidden !important;
    }
</style>

<div id="global-preloader" class="preloader-overlay">
    <div class="preloader-content">
        <div class="preloader-visual">
            <div class="preloader-ring"></div>
            <div class="preloader-ring-active"></div>
            <div class="preloader-orb"></div>
        </div>
        <div class="preloader-text">
            Loading
            <div class="preloader-dots">
                <span>.</span><span>.</span><span>.</span>
            </div>
        </div>
    </div>
</div>

<script>
(function() {
    const preloader = document.getElementById('global-preloader');
    
    // Environment Check: Disable for localhost/127.0.0.1
    const hostname = window.location.hostname;
    const isLocal = hostname === "localhost" || hostname === "127.0.0.1" || hostname.startsWith("192.168.");
    
    if (isLocal) {
        preloader.style.display = 'none';
        return;
    }

    // Set theme for preloader immediately
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.documentElement.setAttribute('data-theme', savedTheme);

    // Initial state: Disable scroll
    document.documentElement.classList.add('preloader-no-scroll');

    // Smart Exit: Wait for window load (all assets + components)
    window.addEventListener('load', function() {
        // Minimum visibility time to ensure the animation is seen and feels premium
        // but only if it's very fast. If it takes longer than 500ms, hide immediately.
        const startTime = performance.now();
        
        const hidePreloader = () => {
            preloader.classList.add('preloader-hidden');
            document.documentElement.classList.remove('preloader-no-scroll');
            
            // Clean up DOM after transition
            setTimeout(() => {
                preloader.style.display = 'none';
            }, 600);
        };

        const loadTime = performance.now() - startTime;
        if (loadTime < 500) {
            setTimeout(hidePreloader, 500 - loadTime);
        } else {
            hidePreloader();
        }
    });

    // Safety timeout: If load takes too long (e.g. 8s), force hide
    setTimeout(() => {
        if (!preloader.classList.contains('preloader-hidden')) {
            document.documentElement.classList.remove('preloader-no-scroll');
            preloader.classList.add('preloader-hidden');
        }
    }, 8000);
})();
</script>
