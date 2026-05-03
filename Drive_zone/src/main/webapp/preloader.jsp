<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    Advanced Global Preloader Component
    Features:
    1. Production-only hostname detection
    2. Premium Animated Gradient Background
    3. Floating Car Logo Animation
    4. Shimmer & Glow Effects
    5. Blur-to-Clear Exit Transition
--%>
<style>
    :root {
        --pl-bg-1: #0f172a;
        --pl-bg-2: #1e293b;
        --pl-accent: #3b82f6;
        --pl-glow: rgba(59, 130, 246, 0.5);
        --pl-text: #f8fafc;
    }

    [data-theme="light"] {
        --pl-bg-1: #f8fafc;
        --pl-bg-2: #f1f5f9;
        --pl-accent: #1a56db;
        --pl-glow: rgba(26, 86, 219, 0.3);
        --pl-text: #1e293b;
    }

    /* Full screen overlay with animated gradient */
    .pl-overlay {
        position: fixed;
        inset: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(-45deg, var(--pl-bg-1), var(--pl-bg-2), var(--pl-bg-1));
        background-size: 400% 400%;
        animation: pl-gradient 15s ease infinite;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        z-index: 100000;
        transition: opacity 0.8s cubic-bezier(0.4, 0, 0.2, 1), 
                    transform 0.8s cubic-bezier(0.4, 0, 0.2, 1),
                    visibility 0.8s;
    }

    @keyframes pl-gradient {
        0% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
        100% { background-position: 0% 50%; }
    }

    .pl-overlay.pl-hidden {
        opacity: 0;
        transform: scale(1.1);
        visibility: hidden;
        pointer-events: none;
    }

    /* Content container */
    .pl-content {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 32px;
        position: relative;
    }

    /* Floating Logo Animation */
    .pl-logo-wrap {
        position: relative;
        width: 120px;
        height: 120px;
        display: flex;
        align-items: center;
        justify-content: center;
        animation: pl-float 3s ease-in-out infinite;
    }

    .pl-logo-icon {
        font-size: 4rem;
        color: var(--pl-accent);
        filter: drop-shadow(0 0 20px var(--pl-glow));
        position: relative;
        z-index: 2;
    }

    /* Glowing Rings */
    .pl-ring {
        position: absolute;
        inset: 0;
        border: 2px solid transparent;
        border-top-color: var(--pl-accent);
        border-radius: 50%;
        animation: pl-spin 2s linear infinite;
        opacity: 0.4;
    }

    .pl-ring-inner {
        position: absolute;
        inset: 15px;
        border: 2px solid transparent;
        border-bottom-color: var(--pl-accent);
        border-radius: 50%;
        animation: pl-spin 1.5s linear infinite reverse;
        opacity: 0.3;
    }

    /* Shimmer Effect */
    .pl-shimmer {
        position: absolute;
        inset: -20px;
        background: radial-gradient(circle, var(--pl-glow) 0%, transparent 70%);
        animation: pl-pulse 2s ease-in-out infinite;
        z-index: 1;
    }

    /* Loading Text */
    .pl-text {
        font-family: 'Inter', 'Poppins', sans-serif;
        font-size: 0.9rem;
        font-weight: 700;
        color: var(--pl-text);
        letter-spacing: 4px;
        text-transform: uppercase;
        display: flex;
        align-items: center;
        gap: 8px;
        opacity: 0.8;
    }

    .pl-dots {
        display: flex;
        gap: 4px;
    }

    .pl-dot {
        width: 4px;
        height: 4px;
        background: var(--pl-accent);
        border-radius: 50%;
        animation: pl-dots 1.4s infinite;
    }

    .pl-dot:nth-child(2) { animation-delay: 0.2s; }
    .pl-dot:nth-child(3) { animation-delay: 0.4s; }

    /* Keyframes */
    @keyframes pl-spin {
        to { transform: rotate(360deg); }
    }

    @keyframes pl-float {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-15px); }
    }

    @keyframes pl-pulse {
        0%, 100% { transform: scale(0.8); opacity: 0.2; }
        50% { transform: scale(1.2); opacity: 0.5; }
    }

    @keyframes pl-dots {
        0%, 80%, 100% { transform: scale(0.6); opacity: 0.3; }
        40% { transform: scale(1); opacity: 1; }
    }

    /* Blur-to-clear transition helper */
    .pl-blur-content {
        filter: blur(15px);
        transition: filter 1s ease;
    }
</style>

<div id="pl-root" class="pl-overlay">
    <div class="pl-content">
        <div class="pl-logo-wrap">
            <div class="pl-shimmer"></div>
            <div class="pl-ring"></div>
            <div class="pl-ring-inner"></div>
            <i class="fa-solid fa-car-side pl-logo-icon"></i>
        </div>
        <div class="pl-text">
            Loading Experience
            <div class="pl-dots">
                <div class="pl-dot"></div>
                <div class="pl-dot"></div>
                <div class="pl-dot"></div>
            </div>
        </div>
    </div>
</div>

<script>
(function() {
    const plRoot = document.getElementById('pl-root');
    
    // Environment Control
    const isProd = window.location.hostname !== "localhost" && 
                   window.location.hostname !== "127.0.0.1" && 
                   !window.location.hostname.startsWith("192.168.");

    if (!isProd) {
        plRoot.style.display = 'none';
        return;
    }

    // Lock Scroll
    document.documentElement.style.overflow = 'hidden';
    
    // Initial State: Apply blur to body children (except preloader)
    const blurElements = () => {
        Array.from(document.body.children).forEach(el => {
            if (el !== plRoot && el.tagName !== 'SCRIPT') {
                el.classList.add('pl-blur-content');
            }
        });
    };

    // Wait for full load
    window.addEventListener('load', function() {
        const minDisplayTime = 800; // Ensure premium feel
        const startTime = performance.now();

        const exitLoader = () => {
            // Remove blur
            Array.from(document.body.children).forEach(el => {
                if (el.classList.contains('pl-blur-content')) {
                    el.style.filter = 'none';
                }
            });

            // Hide preloader
            plRoot.classList.add('pl-hidden');
            document.documentElement.style.overflow = '';

            setTimeout(() => {
                plRoot.style.display = 'none';
            }, 800);
        };

        const elapsed = performance.now() - startTime;
        if (elapsed < minDisplayTime) {
            setTimeout(exitLoader, minDisplayTime - elapsed);
        } else {
            exitLoader();
        }
    });

    // Proactive blur before assets load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', blurElements);
    } else {
        blurElements();
    }

    // Safety force-hide after 10s
    setTimeout(() => {
        if (plRoot.style.display !== 'none') {
            plRoot.classList.add('pl-hidden');
            document.documentElement.style.overflow = '';
        }
    }, 10000);
})();
</script>
