<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:s="http://www.sitemaps.org/schemas/sitemap/0.9">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html lang="es">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <meta name="robots" content="noindex"/>
        <title>Sitemap XML &#8211; Serdoc</title>
        <style>
          :root { color-scheme: light dark; }
          * { box-sizing: border-box; }
          body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            margin: 0; padding: 0; color: #1a1a1a; background: #f6f7f9;
          }
          .wrap { max-width: 1080px; margin: 0 auto; padding: 32px 20px 64px; }
          header { border-bottom: 3px solid #0b5cad; padding-bottom: 18px; margin-bottom: 24px; }
          h1 { margin: 0 0 6px; font-size: 24px; color: #0b5cad; }
          .meta { color: #555; font-size: 14px; }
          .meta strong { color: #1a1a1a; }
          .note {
            background: #eaf2fb; border: 1px solid #cfe0f5; color: #234; font-size: 13px;
            padding: 12px 14px; border-radius: 8px; margin-bottom: 22px; line-height: 1.5;
          }
          table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,.08); }
          th, td { text-align: left; padding: 12px 14px; font-size: 14px; border-bottom: 1px solid #eee; }
          th { background: #0b5cad; color: #fff; font-weight: 600; font-size: 13px; letter-spacing: .02em; }
          tr:last-child td { border-bottom: 0; }
          tr:hover td { background: #f2f7fd; }
          td.url a { color: #0b5cad; text-decoration: none; word-break: break-all; }
          td.url a:hover { text-decoration: underline; }
          td.num { text-align: center; color: #888; width: 56px; }
          td.small { white-space: nowrap; color: #555; }
          @media (prefers-color-scheme: dark) {
            body { background: #14171c; color: #e6e6e6; }
            .meta { color: #aaa; } .meta strong { color: #fff; }
            .note { background: #17222e; border-color: #274056; color: #cbd6e2; }
            table { background: #1c2128; box-shadow: none; }
            th, td { border-bottom-color: #2a2f37; }
            tr:hover td { background: #232a33; }
            td.small { color: #aaa; }
          }
        </style>
      </head>
      <body>
        <div class="wrap">
          <header>
            <h1>Sitemap XML</h1>
            <p class="meta">
              Este sitemap contiene <strong><xsl:value-of select="count(s:urlset/s:url)"/></strong> URLs.
            </p>
          </header>
          <p class="note">
            Este es un archivo <strong>sitemap XML</strong> pensado para los buscadores (Google, Bing&#8230;).
            Los motores de b&#250;squeda lo leen autom&#225;ticamente; esta vista con tabla es solo para facilitar
            su lectura a personas.
          </p>
          <table>
            <thead>
              <tr>
                <th>#</th>
                <th>URL</th>
                <th>Frecuencia</th>
                <th>Prioridad</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="s:urlset/s:url">
                <tr>
                  <td class="num"><xsl:value-of select="position()"/></td>
                  <td class="url">
                    <a href="{s:loc}"><xsl:value-of select="s:loc"/></a>
                  </td>
                  <td class="small"><xsl:value-of select="s:changefreq"/></td>
                  <td class="small"><xsl:value-of select="s:priority"/></td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
