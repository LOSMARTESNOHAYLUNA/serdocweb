# Serdoc — Web Corporativa

Sitio web corporativo de **Serdoc Informática S.L.**, empresa especializada en soluciones RFID, gestión documental y Linked Open Data.

## Estructura

```
serdoc-web/
├── index.html                          ← Home
├── css/style.css                       ← Design system compartido
├── js/main.js                          ← Animaciones y FAQ
├── js/cookies.js                       ← Banner cookies RGPD
├── soluciones-rfid/                    ← Hub RFID
├── rfid-retail-tiendas/                ← Landing retail
├── rfid-logistica-almacenes/           ← Landing logística
├── rfid-lavanderias/                   ← Landing lavanderías
├── rfid-residencias/                   ← Landing residencias
├── rfid-hospitales/                    ← Landing hospitales
├── rfid-hosteleria/                    ← Landing hostelería
├── cajas-autocobro-rfid/               ← Landing cajas autocobro
├── sistemas-antihurto-rfid/            ← Landing antihurto
├── etiquetas-rfid/                     ← Landing etiquetas
├── dispositivos-rfid/                  ← Landing dispositivos
├── soluciones-rfid-bibliotecas/        ← Hub bibliotecas
├── autoprestamo-libros-rfid/           ← Landing autopréstamo
├── autolibro/                          ← Landing autolibro
├── rfid-bibliobus/                     ← Landing bibliobús
├── accede-reserva-espacios/            ← Landing ACCEDE
├── gestion-documental/                 ← Hub gestión documental
├── digitalizacion-documentos/          ← Landing digitalización
├── custodia-documental/                ← Landing custodia
├── bpo-externalizacion/                ← Landing BPO
├── linked-open-data/                   ← Landing LOD
├── sobre-nosotros/                     ← Página institucional
├── casos-de-exito/                     ← Casos de éxito
├── contacto/                           ← Formulario de contacto
├── preguntas-frecuentes/               ← FAQ (schema markup ready)
└── blog/                               ← Blog (plantilla)
```

## Stack técnico

- **HTML5 estático** — Sin framework, carga instantánea
- **CSS custom** — Design system con variables CSS, responsive, dark mode ready
- **JavaScript vanilla** — Scroll animations, FAQ accordion, cookie consent
- **Google Fonts** — Outfit (display) + Source Sans 3 (body)
- **Chart.js CDN** — Solo en dashboards

## Dependencias externas

- Google Fonts (`fonts.googleapis.com`)
- Imágenes actuales de `serdoc.es` (a sustituir por fotografías propias)

## Cookie Consent (RGPD)

El sistema de cookies cumple con RGPD:
- Banner con opciones equitativas: Aceptar / Rechazar / Configurar
- Panel de preferencias con 4 categorías granulares
- Botón flotante para reconfigurar en cualquier momento
- Integración con Google Analytics Consent Mode y Meta Pixel

## Despliegue

Sitio 100% estático. Compatible con:
- GitHub Pages
- Netlify
- Vercel
- Cualquier hosting con soporte HTML

## Créditos

Diseño y desarrollo: **Los Martes No Hay Luna** (LMNHL)  
Cliente: **Serdoc Informática S.L.**  
Fecha: Junio 2026
