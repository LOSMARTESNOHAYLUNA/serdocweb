/* ============================================
   SERDOC — Cookie Consent (RGPD)
   ============================================ */

const CookieConsent = {
  banner: null,
  prefs: null,
  overlay: null,
  reopen: null,

  init() {
    this.banner = document.getElementById('cookieBanner');
    this.prefs = document.getElementById('cookiePrefs');
    this.overlay = document.getElementById('cookieOverlay');
    this.reopen = document.getElementById('cookieReopen');
    if (!this.banner) return;

    this.overlay.addEventListener('click', () => {
      if (this.prefs.classList.contains('active')) this.closePrefs();
    });
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && this.prefs.classList.contains('active')) this.closePrefs();
    });

    const stored = localStorage.getItem('serdoc_cookie_consent');
    if (stored) {
      const c = JSON.parse(stored);
      this.applyToggles(c);
      this.reopen.classList.add('visible');
      this.onUpdate(c);
    } else {
      setTimeout(() => this.showBanner(), 800);
    }
  },

  showBanner() {
    this.banner.classList.add('active');
    this.reopen.classList.remove('visible');
  },
  hideBanner() {
    this.banner.classList.remove('active');
  },
  showPrefs() {
    this.hideBanner();
    this.prefs.classList.add('active');
    this.overlay.classList.add('active');
  },
  closePrefs() {
    this.prefs.classList.remove('active');
    this.overlay.classList.remove('active');
    if (!localStorage.getItem('serdoc_cookie_consent')) {
      setTimeout(() => this.showBanner(), 200);
    } else {
      this.reopen.classList.add('visible');
    }
  },

  acceptAll() {
    const c = { functional: true, analytics: true, marketing: true, preferences: true, ts: new Date().toISOString() };
    this.save(c);
  },
  rejectAll() {
    const c = { functional: true, analytics: false, marketing: false, preferences: false, ts: new Date().toISOString() };
    this.applyToggles(c);
    this.save(c);
  },
  savePrefs() {
    const c = {
      functional: true,
      analytics: document.getElementById('toggleAnalytics')?.checked || false,
      marketing: document.getElementById('toggleMarketing')?.checked || false,
      preferences: document.getElementById('togglePreferences')?.checked || false,
      ts: new Date().toISOString()
    };
    this.save(c);
  },

  save(c) {
    localStorage.setItem('serdoc_cookie_consent', JSON.stringify(c));
    this.hideBanner();
    this.prefs.classList.remove('active');
    this.overlay.classList.remove('active');
    this.reopen.classList.add('visible');
    this.onUpdate(c);
  },

  applyToggles(c) {
    const a = document.getElementById('toggleAnalytics');
    const m = document.getElementById('toggleMarketing');
    const p = document.getElementById('togglePreferences');
    if (a) a.checked = c.analytics;
    if (m) m.checked = c.marketing;
    if (p) p.checked = c.preferences;
  },

  onUpdate(c) {
    if (typeof gtag === 'function') {
      gtag('consent', 'update', {
        analytics_storage: c.analytics ? 'granted' : 'denied',
        ad_storage: c.marketing ? 'granted' : 'denied',
        ad_personalization: c.marketing ? 'granted' : 'denied',
        ad_user_data: c.marketing ? 'granted' : 'denied',
      });
    }
    if (c.marketing && typeof fbq === 'function') fbq('consent', 'grant');
  },

  toggleDetail(btn) {
    const d = btn.nextElementSibling;
    d.classList.toggle('open');
    btn.classList.toggle('open');
    btn.firstChild.textContent = d.classList.contains('open') ? 'Ocultar cookies' : 'Ver cookies';
  }
};

document.addEventListener('DOMContentLoaded', () => CookieConsent.init());
