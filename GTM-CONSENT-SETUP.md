# Configuración de Google Tag Manager con Consent Mode v2 (GDPR)

Guía paso a paso para configurar el contenedor **GTM-NFN2MVQ4** de forma que
todas las etiquetas respeten el consentimiento del usuario y cumplan el
**Consent Mode v2** de Google y la normativa europea (GDPR).

> **Contexto clave:** la web es **estática** (HTML/CSS/JS puro, sin WordPress ni
> plugins). El **propio banner de la página es el CMP**: ejecuta
> `gtag('consent','default',…)` (todo `denied`) **antes** de cargar GTM, y
> `gtag('consent','update',…)` cuando el usuario decide. Como `gtag()` y GTM
> comparten el mismo `window.dataLayer`, **GTM ya recibe el estado de
> consentimiento automáticamente**. Por eso en GTM **NO** se crea ninguna
> etiqueta que declare el `default` ni que haga el `update`, ni se instala una
> plantilla CMP: solo se **activa el Consent Mode y se le dice a cada etiqueta
> qué consentimiento exige**.

**Etiquetas activas en el contenedor:**

- GA4 — `G-ZXXNMZ7DNZ`
- Google Ads — `AW-16623828615` (Conversion Linker, remarketing, conversiones)
- Microsoft Clarity
- LinkedIn Insight Tag
- Seguimiento de clics: teléfono, email, WhatsApp
- Conversión de formulario

**Señales que envía el banner al `dataLayer`:**

```javascript
// Al cargar cada página (antes de GTM):
gtag('consent','default',{
  analytics_storage: 'denied',
  ad_storage: 'denied',
  ad_user_data: 'denied',
  ad_personalization: 'denied',
  functionality_storage: 'granted',
  personalization_storage: 'denied',
  wait_for_update: 500
});

// Cuando el usuario decide (aceptar / rechazar / guardar preferencias):
window.dataLayer.push({
  event: 'consent_update',
  analytics_consent: 'granted' | 'denied',
  marketing_consent: 'granted' | 'denied'
});
// (además, el propio save() ya llama a gtag('consent','update',…))
```

---

## Modelo recomendado: Consent Mode **Avanzado**

Las etiquetas se disparan en **todas las páginas** desde el inicio; el Consent
Mode las "redacta" (pings sin cookies) mientras el consentimiento está `denied`
y pasan a hits completos al aceptar. Da **modelado de conversiones** y es lo
más correcto para GDPR. Es el modo que asume esta guía.

---

## 0. Verificaciones previas (fuera de GTM — ya hechas en la web)

- [x] `gtag('consent','default',…)` carga **antes** del snippet de GTM en el `<head>` (por encima de `<!-- Google Tag Manager -->`).
- [x] `wait_for_update: 500` está presente (da 500 ms a restaurar el consentimiento guardado).
- [ ] **No** añadir en GTM ninguna etiqueta de "Consent Initialization" que redeclare el `default`: el default vive en la página.

---

## 1. Activar el Consent Overview en el contenedor

- [ ] GTM → **Administrador → Configuración del contenedor**.
- [ ] Marcar **"Habilitar la vista general de consentimiento"** (Enable consent overview).
- [ ] Guardar. En la lista de **Etiquetas** aparecerá el icono de **escudo** que muestra qué etiquetas tienen consentimiento configurado.

---

## 2. Crear variables y disparador de consentimiento

Necesarios para las etiquetas **no-Google** (Clarity, LinkedIn).

**Variables** (Variables → Definidas por el usuario → Nueva → *Variable de capa de datos*):

| Nombre variable | Nombre de variable de capa de datos | Versión |
|---|---|---|
| `dlv - analytics_consent` | `analytics_consent` | 2 |
| `dlv - marketing_consent` | `marketing_consent` | 2 |

**Disparador** (Activadores → Nuevo → *Evento personalizado*):

- [ ] Nombre: `CE - consent_update`
- [ ] Nombre del evento: `consent_update`
- [ ] Se activa en: **Todos los eventos personalizados**

---

## 3. Etiquetas de Google (GA4 y Ads) — consentimiento integrado

Estas etiquetas **ya conocen el Consent Mode de forma nativa** (built-in consent
checks). No hay que añadirles consentimiento manual. Solo verificar disparadores:

| Etiqueta | Disparador correcto | Consentimiento (automático) |
|---|---|---|
| **GA4 – Configuración** (`G-ZXXNMZ7DNZ`) | Inicialización - Todas las páginas | `analytics_storage` |
| **GA4 – eventos** (tel., email, WhatsApp, formulario) | sus disparadores de clic/formulario actuales | `analytics_storage` |
| **Google Ads – Conversion Linker** | **All Pages** (imprescindible) | `ad_storage` |
| **Google Ads – Remarketing** (`AW-16623828615`) | All Pages | `ad_storage`, `ad_user_data`, `ad_personalization` |
| **Google Ads – Conversión formulario** | disparador de envío de formulario | `ad_storage`, `ad_user_data` |

- [ ] En cada una: **Configuración avanzada → Configuración de consentimiento** en **"No se han establecido consentimientos adicionales"** (las comprobaciones ya son integradas). Opcionalmente marcar los "additional required consent" para que el escudo salga verde.
- [ ] Confirmar que existe la etiqueta **Conversion Linker** disparada en **All Pages** (necesaria para Consent Mode + gclid).

> Con Consent Mode avanzado, dispararlas en **All Pages** es lo correcto: si el
> usuario rechaza, Google envía pings sin cookies (modelado); si acepta, empiezan
> los hits completos. No hace falta re-disparar GA4 con `consent_update`.

---

## 4. Etiquetas NO-Google (Clarity y LinkedIn) — bloqueo manual

Estas **no** entienden el Consent Mode: hay que bloquearlas y liberarlas al aceptar.

Para **Microsoft Clarity** y **LinkedIn Insight Tag**:

- [ ] **Configuración avanzada → Configuración de consentimiento → "Se requiere consentimiento adicional para que se active la etiqueta"**:
  - **Clarity** → `analytics_storage` (es analítica)
  - **LinkedIn Insight** → `ad_storage` (es marketing)
- [ ] **Disparadores** — añadir **los dos**:
  - `All Pages` (visitante recurrente con consentimiento guardado)
  - `CE - consent_update` (visitante nuevo que acepta en el momento)

El doble disparador garantiza que: si acepta → se dispara; si rechaza → el
bloqueo por `analytics_storage` / `ad_storage` la mantiene apagada.

> **Alternativa más estricta:** usar como disparador **solo** `CE - consent_update`
> con condición `dlv - analytics_consent` (o `dlv - marketing_consent`) **es igual
> a** `granted`. Así nunca cargan en la carga inicial, solo tras aceptación explícita.

---

## 5. Orden de ejecución del trabajo

1. [ ] Activar Consent Overview (paso 1).
2. [ ] Crear las 2 variables DLV + disparador `CE - consent_update` (paso 2).
3. [ ] Revisar/ajustar disparadores de las etiquetas Google (paso 3) — normalmente sin cambios.
4. [ ] Añadir consentimiento adicional + doble disparador a Clarity y LinkedIn (paso 4).
5. [ ] Probar en Vista previa (paso 6).
6. [ ] Publicar (paso 7).

---

## 6. Probar en Vista previa (Tag Assistant)

- [ ] GTM → **Vista previa** → abrir la web. Revisar la pestaña **"Consent"** de cada evento:
  - **Al cargar (sin decidir):** `analytics_storage` y `ad_storage` en **Denied**; GA4/Ads disparadas pero **redactadas**; Clarity y LinkedIn **no disparadas**.
  - **Aceptar todas:** aparece el evento `consent_update`, el estado pasa a **Granted**, y Clarity y LinkedIn **se disparan**.
  - **Recargar** con consentimiento guardado: debe restaurarse `granted` (por el `gtag('consent','update')` del `init()`).
  - **Rechazar:** todo sigue `denied`; Clarity/LinkedIn no cargan; GA4/Ads solo pings sin cookies.
- [ ] Probar clics de teléfono/email/WhatsApp y envío de formulario: la conversión de Ads y el evento GA4 deben respetar el consentimiento.

---

## 7. Publicar

- [ ] GTM → **Enviar** → nombrar la versión (ej. *"Consent Mode v2 – gating de etiquetas"*) → **Publicar**.

---

## Resumen de qué crear / modificar / verificar

- **Crear:** 2 variables DLV (`analytics_consent`, `marketing_consent`) + 1 disparador `CE - consent_update`.
- **Modificar:** Clarity y LinkedIn → consentimiento adicional (`analytics_storage` / `ad_storage`) + doble disparador.
- **Verificar (sin cambios de fondo):** GA4 y Google Ads (Conversion Linker, remarketing, conversiones) → built-in consent, disparo en All Pages / sus clics.
- **NO crear:** ninguna etiqueta de consent default/update en GTM (ya lo hace la página).
