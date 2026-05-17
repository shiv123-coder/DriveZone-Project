<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    PREMIUM PRODUCTION PRELOADER
    - Production-only execution
    - Dark Glassmorphic Design
    - SVG Noise/Grain Texture
    - Rotating Gradient Rings & Pulsing Energy Core
    - Smart Loading Logic with Promise Tracking
--%>
<style>
    :root {
        --pl-bg: #030712;
        --pl-accent: #3b82f6;
        --pl-accent-glow: rgba(59, 130, 246, 0.5);
        --pl-energy: #60a5fa;
        --pl-text: rgba(255, 255, 255, 0.7);
    }

    /* Core Overlay */
    #pl-root {
        position: fixed;
        inset: 0;
        width: 100%;
        height: 100%;
        background: var(--pl-bg);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        z-index: 999999;
        overflow: hidden;
        transition: opacity 0.6s cubic-bezier(0.4, 0, 0.2, 1),
                    transform 0.6s cubic-bezier(0.4, 0, 0.2, 1),
                    visibility 0.6s;
    }

    /* Radial Glow Background */
    .pl-glow {
        position: absolute;
        width: 150%;
        height: 150%;
        background: radial-gradient(circle at center, rgba(37, 99, 235, 0.15) 0%, transparent 50%);
        animation: pl-glow-pulse 8s ease-in-out infinite alternate;
        pointer-events: none;
    }

    /* Grain Texture Overlay */
    .pl-noise {
        position: absolute;
        inset: 0;
        width: 100%;
        height: 100%;
        opacity: 0.04;
        pointer-events: none;
        background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)'/%3E%3C/svg%3E");
    }

    /* Center Container */
    .pl-visual {
        position: relative;
        width: 180px;
        height: 180px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 40px;
        animation: pl-float 4s ease-in-out infinite;
    }

    /* Rotating Gradient Rings */
    .pl-ring-outer {
        position: absolute;
        inset: 0;
        border-radius: 50%;
        padding: 2px;
        background: linear-gradient(0deg, transparent 30%, var(--pl-accent) 100%);
        -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
        mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
        -webkit-mask-composite: xor;
        mask-composite: exclude;
        animation: pl-spin 2s cubic-bezier(0.45, 0, 0.55, 1) infinite;
    }

    .pl-ring-mid {
        position: absolute;
        inset: 15px;
        border-radius: 50%;
        padding: 2px;
        background: linear-gradient(180deg, transparent 30%, var(--pl-energy) 100%);
        -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
        mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
        -webkit-mask-composite: xor;
        mask-composite: exclude;
        animation: pl-spin 3s cubic-bezier(0.45, 0, 0.55, 1) infinite reverse;
        opacity: 0.6;
    }

    /* Energy Core */
    .pl-core {
        position: relative;
        width: 60px;
        height: 60px;
        background: var(--pl-energy);
        border-radius: 50%;
        filter: blur(1px);
        box-shadow: 0 0 30px var(--pl-accent-glow), 0 0 60px var(--pl-accent-glow);
        animation: pl-core-pulse 2s ease-in-out infinite;
    }

    .pl-core::after {
        content: '';
        position: absolute;
        inset: -10px;
        border-radius: 50%;
        border: 1px solid rgba(96, 165, 250, 0.3);
        animation: pl-ripple 2s ease-out infinite;
    }

    /* Particle Specks */
    .pl-particle {
        position: absolute;
        background: #fff;
        border-radius: 50%;
        opacity: 0.3;
        pointer-events: none;
    }

    /* Loading Text */
    .pl-status {
        font-family: 'Inter', system-ui, -apple-system, sans-serif;
        color: var(--pl-text);
        font-size: 13px;
        font-weight: 500;
        letter-spacing: 0.15em;
        text-transform: uppercase;
        display: flex;
        align-items: center;
        gap: 4px;
        animation: pl-fade-in 0.8s ease-out;
    }

    .pl-dots span {
        animation: pl-dots 1.4s infinite both;
    }
    .pl-dots span:nth-child(2) { animation-delay: 0.2s; }
    .pl-dots span:nth-child(3) { animation-delay: 0.4s; }

    /* Hidden State (Exit Animation) */
    .pl-hidden {
        opacity: 0 !important;
        transform: scale(0.96) !important;
        visibility: hidden !important;
        pointer-events: none !important;
    }

    /* Blur helper for body content */
    .pl-content-blur {
        filter: blur(12px);
        transition: filter 0.8s cubic-bezier(0.4, 0, 0.2, 1);
    }

    /* Animations */
    @keyframes pl-spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }

    @keyframes pl-glow-pulse {
        from { transform: scale(1) translate(-10%, -10%); opacity: 0.5; }
        to { transform: scale(1.1) translate(0, 0); opacity: 0.8; }
    }

    @keyframes pl-float {
        0%, 100% { transform: translateY(0) rotate(0deg); }
        50% { transform: translateY(-10px) rotate(2deg); }
    }

    @keyframes pl-core-pulse {
        0%, 100% { transform: scale(1); filter: blur(1px) brightness(1); }
        50% { transform: scale(1.1); filter: blur(2px) brightness(1.3); }
    }

    @keyframes pl-ripple {
        from { transform: scale(1); opacity: 1; }
        to { transform: scale(2); opacity: 0; }
    }

    @keyframes pl-dots {
        0%, 80%, 100% { opacity: 0.2; transform: translateY(0); }
        40% { opacity: 1; transform: translateY(-2px); }
    }

    @keyframes pl-fade-in {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>

<div id="pl-root">
    <div class="pl-glow"></div>
    <div class="pl-noise"></div>
    
    <!-- Floating Particles (Generated by JS) -->
    <div id="pl-particles"></div>

    <div class="pl-visual">
        <div class="pl-ring-outer"></div>
        <div class="pl-ring-mid"></div>
        <div class="pl-core"></div>
    </div>

    <div class="pl-status">
        Loading experience
        <div class="pl-dots">
            <span>.</span><span>.</span><span>.</span>
        </div>
    </div>
</div>

<script>
window.Preloader = (function() {
    const root = document.getElementById('pl-root');
    const particlesContainer = document.getElementById('pl-particles');
    const minDisplayTime = 400; // Premium feel threshold
    const startTime = performance.now();
    let trackedPromises = [];

    // 1. Environment Check (Production Only)
    const isDev = window.location.hostname === 'localhost' || 
                  window.location.hostname === '127.0.0.1' || 
                  window.location.hostname.startsWith('192.168.');

    if (isDev) {
        root.style.display = 'none';
        return { track: () => {} };
    }

    // 2. Initialize Visuals
    function initParticles() {
        for (let i = 0; i < 15; i++) {
            const p = document.createElement('div');
            p.className = 'pl-particle';
            const size = Math.random() * 3 + 1;
            p.style.width = size + 'px';
            p.style.height = size + 'px';
            p.style.left = Math.random() * 100 + '%';
            p.style.top = Math.random() * 100 + '%';
            p.style.animation = 'pl-fade-in ' + (Math.random() * 3 + 2) + 's infinite alternate';
            particlesContainer.appendChild(p);
        }
    }

    // 3. UX Management
    function lockScroll() {
        document.documentElement.style.overflow = 'hidden';
        document.body.style.pointerEvents = 'none';
    }

    function unlockScroll() {
        document.documentElement.style.overflow = '';
        document.body.style.pointerEvents = '';
    }

    function applyBlur() {
        Array.from(document.body.children).forEach(el => {
            if (el !== root && el.tagName !== 'SCRIPT' && el.tagName !== 'LINK') {
                el.classList.add('pl-content-blur');
            }
        });
    }

    function removeBlur() {
        Array.from(document.body.children).forEach(el => {
            el.classList.remove('pl-content-blur');
        });
    }

    // 4. Smart Loading Logic
    const exit = () => {
        const elapsed = performance.now() - startTime;
        const delay = Math.max(0, minDisplayTime - elapsed);

        setTimeout(() => {
            removeBlur();
            root.classList.add('pl-hidden');
            unlockScroll();

            // Cleanup DOM after animation
            setTimeout(() => {
                root.style.display = 'none';
            }, 600);
        }, delay);
    };

    // Public API
    const api = {
        track: (promise) => {
            if (promise && typeof promise.then === 'function') {
                trackedPromises.push(promise);
            }
        }
    };

    // Execution
    lockScroll();
    initParticles();
    
    // Auto-blur content once DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', applyBlur);
    } else {
        applyBlur();
    }

    // Wait for Window Load + Tracked Promises
    window.addEventListener('load', () => {
        if (trackedPromises.length === 0) {
            exit();
        } else {
            Promise.allSettled(trackedPromises).then(exit);
        }
    });

    // Safety force-hide (10s limit)
    setTimeout(() => {
        if (root.style.display !== 'none') {
            exit();
        }
    }, 10000);

    return api;
})();
</script>
