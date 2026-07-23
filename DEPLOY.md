# Guía de despliegue en Netlify

## 1. Crear el sitio en Netlify

1. Ve a <https://app.netlify.com> y crea una cuenta (o inicia sesión).
2. Pulsa **"Add new site" → "Deploy manually"**.
3. Netlify te asignará un dominio temporal `random-name-12345.netlify.app`.

## 2. Obtener las credenciales para GitHub Actions

### 2.1 Obtener el SITE_ID

1. En Netlify, entra en tu sitio.
2. **Site configuration → Site details**.
3. Copia el valor de **"Site ID"** (un UUID tipo `a1b2c3d4-...`).

### 2.2 Crear un Personal Access Token

1. Ve a <https://app.netlify.com/user/applications#personal-access-tokens>
2. Pulsa **"New access token"**.
3. Nombre: `imagen-madrid-github-actions`. Expiry: el que prefieras.
4. Pulsa **"Generate token"** y cópialo (no se vuelve a mostrar).

## 3. Configurar los secretos en GitHub

En tu repo: `Settings → Secrets and variables → Actions` y crea:

| Nombre | Valor |
|--------|-------|
| `NETLIFY_SITE_ID` | El UUID del paso 2.1 |
| `NETLIFY_AUTH_TOKEN` | El token del paso 2.2 |

## 4. Conectar el dominio personalizado

1. Netlify → **Domain settings → Add a domain** → escribe `imagenmadrid.es`.
2. Configura los nameservers o registros DNS en tu proveedor de dominio.
3. Activa **HTTPS → Force HTTPS** una vez verificado el dominio.

## 5. Verificar el primer despliegue

1. `git push origin main`
2. Ve a **Actions** en tu repo — verás el workflow ejecutándose.
3. **lint** debe pasar ✅, luego **deploy** sube a Netlify.

## Troubleshooting

| Problema | Solución |
|----------|----------|
| `401 Unauthorized` | Regenera `NETLIFY_AUTH_TOKEN` |
| Deploy sube pero no aparece | Verifica que el `NETLIFY_SITE_ID` coincide |
| Falla `lint` con "Falta canonical" | Pull y vuelve a pushear |

