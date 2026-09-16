# Checklist de migración a hosting real (serdoc.es)

Guía para migrar el demo (actualmente en **Vercel** → `serdocweb.vercel.app`) al
hosting definitivo (**Cloudflare + Plesk/PHP**) sirviéndolo en el dominio
**`serdoc.es`**, reemplazando al WordPress actual.

> Contexto: hoy `serdoc.es` es un WordPress con Rank Math. El demo es un sitio
> **estático** (HTML/CSS/JS). Al migrar, WordPress deja de usarse.

---

## 0. Antes de empezar (backup)

- [ ] Hacer **copia de seguridad completa** del WordPress actual (archivos + base de datos) por si hay que revertir.
- [ ] Anotar la configuración DNS actual en Cloudflare (registros A/AAAA/CNAME).
- [ ] Tener a mano el acceso al panel (Plesk) y a Cloudflare.

---

## 1. Dominio canónico: **sin www**

El sitio canónico es **`https://serdoc.es`** (sin www). `www.serdoc.es` debe
**redirigir (301)** a `serdoc.es`.

- [ ] Configurar redirección 301 de `www.serdoc.es` → `serdoc.es` (ya existe hoy; mantenerla).
- [ ] Forzar **HTTPS** (redirección 301 de http → https).
- [ ] Verificar que los sitemaps usan `https://serdoc.es/` (ya está así en el repo).

---

## 2. Subir los archivos estáticos

- [ ] Publicar TODO el contenido del repo en la raíz del dominio (`httpdocs` / `public_html` en Plesk).
- [ ] Confirmar que `index.html` de la raíz carga como home.
- [ ] Comprobar que las URLs "bonitas" con carpeta funcionan (cada página es una carpeta con `index.html`, p. ej. `/rfid-madrid/`). En Apache/Nginx esto suele funcionar solo; si no, configurar `DirectoryIndex index.html`.

---

## 3. Quitar TODO rastro de WordPress / Rank Math

Esto es lo más importante para que los sitemaps nuevos funcionen.

- [ ] Desactivar/eliminar WordPress y sus plugins (Rank Math incluido).
- [ ] **Eliminar redirecciones antiguas de sitemap.** Hoy `serdoc.es/sitemap.xml` hace 301 a `sitemap_index.xml` (lo genera Rank Math). Esa regla debe desaparecer.
- [ ] Revisar `.htaccess` (Apache) o reglas de Nginx y borrar cualquier `RewriteRule` de WordPress/Rank Math que afecte a `sitemap*.xml`.
- [ ] Las URLs viejas de Rank Math (`/sitemap_index.xml`, `/post-sitemap.xml`, `/page-sitemap.xml`) dejarán de existir. Opcional: redirigir `sitemap_index.xml` → `/sitemap.xml` con un 301 para no perder lo que Google ya tenía indexado.

---

## 4. Content-Type del `sitemap.xsl` (para que se vea la tabla)

El `vercel.json` del repo **solo funciona en Vercel**. En el hosting nuevo hay que
configurar que `sitemap.xsl` se sirva como **`text/xsl`** (si no, el navegador
muestra XML crudo).

**Apache** (`.htaccess`):
```apache
<Files "sitemap.xsl">
  ForceType "text/xsl; charset=utf-8"
</Files>
AddType text/xsl .xsl
```

**Nginx**:
```nginx
location = /sitemap.xsl {
  types { } default_type "text/xsl; charset=utf-8";
}
```

- [ ] Aplicar la regla según el servidor.
- [ ] Verificar: `curl -sI https://serdoc.es/sitemap.xsl` debe devolver `content-type: text/xsl`.

---

## 5. Verificación post-migración

Ejecutar y comprobar que devuelven **200** (no 301 ni 404):

```
curl -sI https://serdoc.es/
curl -sI https://serdoc.es/sitemap.xml
curl -sI https://serdoc.es/sitemap-pages.xml
curl -sI https://serdoc.es/sitemap-posts.xml
curl -sI https://serdoc.es/sitemap.xsl
curl -sI https://serdoc.es/robots.txt
```

- [ ] Abrir `https://serdoc.es/sitemap.xml` en el navegador → se ve el **índice como tabla** con 2 enlaces.
- [ ] Hacer clic en cada uno → abre su tabla de URLs (41 páginas / 31 posts), **sin 404**.
- [ ] Comprobar 4-5 páginas al azar del sitemap → cargan bien.
- [ ] `robots.txt` apunta a `https://serdoc.es/sitemap.xml`.
- [ ] Validar que ninguna URL del sitemap redirige (todas 200 directas).

---

## 6. SEO tras la migración

- [ ] En **Google Search Console**, enviar el nuevo sitemap: `https://serdoc.es/sitemap.xml`.
- [ ] (Opcional) Eliminar el sitemap viejo `sitemap_index.xml` de Search Console.
- [ ] Revisar en Search Console que no aparezcan errores de rastreo los días siguientes.
- [ ] Comprobar que las páginas conservan sus URLs (mismos slugs) para no perder posicionamiento. Si alguna URL cambia, poner 301 de la vieja a la nueva.
- [ ] Revisar caché de Cloudflare: hacer **purge** tras la migración para que no sirva versiones viejas.

---

## Estructura de sitemaps (referencia)

- `sitemap.xml` → índice (`<sitemapindex>`), enlaza a los dos de abajo
- `sitemap-pages.xml` → 41 páginas del sitio
- `sitemap-posts.xml` → 31 artículos del blog
- `sitemap.xsl` → hoja de estilo que muestra ambos como tabla
- Dominio en todas las URLs: `https://serdoc.es/` (sin www)
