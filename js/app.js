/* ==========================================================================
   Imagen Beauty & Hair — Animaciones y comportamiento UI
   Versión: 2.1
   ========================================================================== */

(function () {
  'use strict';

  // ─────────────────────────────────────────────────────────────────────────
  // 1) Header con sombra al hacer scroll
  // ─────────────────────────────────────────────────────────────────────────
  const header = document.querySelector('.site-header');
  if (header) {
    const onScroll = () => {
      if (window.scrollY > 8) {
        header.classList.add('is-scrolled');
      } else {
        header.classList.remove('is-scrolled');
      }
    };
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 2) Cursor custom (solo desktop con ratón)
  // ─────────────────────────────────────────────────────────────────────────
  if (window.matchMedia('(hover: hover) and (pointer: fine)').matches) {
    const cursor = document.createElement('div');
    cursor.className = 'custom-cursor';
    document.body.appendChild(cursor);

    document.addEventListener('mousemove', (e) => {
      cursor.style.left = e.clientX + 'px';
      cursor.style.top = e.clientY + 'px';
    });

    // Agrandar cursor al pasar sobre elementos interactivos
    document.querySelectorAll('a, button, .servicio-card, [role="button"]').forEach((el) => {
      el.addEventListener('mouseenter', () => cursor.classList.add('is-hover'));
      el.addEventListener('mouseleave', () => cursor.classList.remove('is-hover'));
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 3) Scroll reveal — fadeUp al entrar en viewport
  // ─────────────────────────────────────────────────────────────────────────
  const revealItems = document.querySelectorAll('[data-reveal]');
  if (revealItems.length && 'IntersectionObserver' in window) {
    const io = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            const delay = parseInt(entry.target.dataset.revealDelay || '0', 10);
            setTimeout(() => {
              entry.target.classList.add('is-visible');
            }, delay);
            io.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: '0px 0px -60px 0px' }
    );
    revealItems.forEach((item) => io.observe(item));
  } else {
    // Fallback: mostrar todo
    revealItems.forEach((item) => item.classList.add('is-visible'));
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 4) Hero — crossfade entre imágenes + indicadores (también táctil)
  // ─────────────────────────────────────────────────────────────────────────
  const heroImages = document.querySelectorAll('.hero-images img');
  const indicators = document.querySelectorAll('.hero-indicators button');
  const HERO_INTERVAL = 5000;

  if (heroImages.length > 1) {
    let current = 0;
    let timer = null;
    let startX = 0;
    let isDragging = false;

    const show = (idx) => {
      heroImages.forEach((img, i) => img.classList.toggle('is-active', i === idx));
      indicators.forEach((ind, i) => ind.classList.toggle('is-active', i === idx));
      current = idx;
    };

    const next = () => show((current + 1) % heroImages.length);
    const prev = () => show((current - 1 + heroImages.length) % heroImages.length);

    const startTimer = () => {
      stopTimer();
      timer = setInterval(next, HERO_INTERVAL);
    };
    const stopTimer = () => {
      if (timer) clearInterval(timer);
      timer = null;
    };

    indicators.forEach((ind, i) => {
      ind.addEventListener('click', () => {
        show(i);
        startTimer();
      });
    });

    // Swipe táctil
    const heroEl = document.querySelector('.hero');
    if (heroEl) {
      heroEl.addEventListener(
        'touchstart',
        (e) => {
          if (e.touches.length !== 1) return;
          startX = e.touches[0].clientX;
          isDragging = true;
          stopTimer();
        },
        { passive: true }
      );
      heroEl.addEventListener(
        'touchend',
        (e) => {
          if (!isDragging) return;
          isDragging = false;
          const endX = (e.changedTouches[0] || {}).clientX || startX;
          const diff = startX - endX;
          if (Math.abs(diff) > 50) {
            diff > 0 ? next() : prev();
          }
          startTimer();
        },
        { passive: true }
      );
    }

    show(0);
    startTimer();
  } else if (heroImages.length === 1) {
    heroImages[0].classList.add('is-active');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 5) Menú hamburguesa (móvil)
  // ─────────────────────────────────────────────────────────────────────────
  const hamburger = document.querySelector('.hamburger');
  const mobileMenu = document.querySelector('.mobile-menu');

  if (hamburger && mobileMenu) {
    const toggle = (open) => {
      hamburger.setAttribute('aria-expanded', open ? 'true' : 'false');
      mobileMenu.classList.toggle('is-open', open);
      document.body.style.overflow = open ? 'hidden' : '';
    };

    hamburger.addEventListener('click', () => {
      const isOpen = hamburger.getAttribute('aria-expanded') === 'true';
      toggle(!isOpen);
    });

    mobileMenu.querySelectorAll('a').forEach((link) => {
      link.addEventListener('click', () => toggle(false));
    });

    // Cerrar con Escape
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && hamburger.getAttribute('aria-expanded') === 'true') {
        toggle(false);
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 6) Sticky CTA bar — añadir clase al body para el spacer
  // ─────────────────────────────────────────────────────────────────────────
  if (window.matchMedia('(max-width: 768px)').matches) {
    document.body.classList.add('has-sticky-bar');

    const mq = window.matchMedia('(max-width: 768px)');
    mq.addEventListener('change', (e) => {
      document.body.classList.toggle('has-sticky-bar', e.matches);
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 7) Respeto por prefers-reduced-motion
  // ─────────────────────────────────────────────────────────────────────────
  const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (prefersReduced) {
    document.documentElement.style.setProperty('animation-duration', '0.01ms');
    document.documentElement.style.setProperty('transition-duration', '0.01ms');
    revealItems.forEach((item) => item.classList.add('is-visible'));
  }
})();

