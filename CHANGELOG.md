# Changelog

Todos los cambios notables de este proyecto.

## [2.0.0] — 2026-XX-XX

### ✨ Nuevas funcionalidades
- SEO local completo: Schema.org `HairSalon` con coordenadas, horarios y dirección
- Open Graph + Twitter Cards en todas las páginas
- `<link rel="canonical">` en cada página
- `sitemap.xml` con prioridades y `robots.txt` con `Sitemap:`
- `site.webmanifest` completo (lang, scope, theme-color)
- CI/CD con GitHub Actions: lint + deploy automático a Netlify
- Configuración de Netlify con cabeceras de seguridad (HSTS, Permissions-Policy)
- Skip-link para accesibilidad WCAG AA

### 🐛 Problemas corregidos
- **Crítico**: Webpack no copiaba las 4 páginas secundarias al build → sitio estático puro
- **Crítico**: CSS duplicado en 5 archivos HTML → extraído a `css/style.css` + `css/pages.css`
- **Crítico**: `js/app.js` vacío + `js/coloracion.html` mal ubicado → carpeta `js/` eliminada
- **Importante**: Footer inconsistente → unificado en todas las páginas
- **Importante**: `404.html` en inglés → pasado a español con el mismo look & feel
- **Importante**: 3 colores de acento distintos → unificados a la paleta dorada
- **Importante**: `@import` de Google Fonts bloqueante → movido a `<link>` con `preconnect`
- **Importante**: Imágenes sin `loading="lazy"` ni dimensiones → todas con alt + width + height + lazy
- **Menor**: `.idea/`, `.DS_Store`, "codigo ni tan mal" commiteados → `.gitignore` robusto
- **Menor**: `package.json` con campos vacíos → `name`, `description`, `author` reales
- **Menor**: Sin `README.md` → documentación completa
- **Menor**: Sin scripts de validación → `scripts/validate.sh` + `scripts/convert-to-webp.sh`

### 🗑️ Eliminado
- Webpack (`webpack.common.js`, `webpack.config.{dev,prod}.js`)
- `js/app.js`, `js/coloracion.html`, `js/vendor/`
- Archivo `"codigo ni tan mal"`
- `.idea/`

## [1.0.0] — 2024-XX-XX
- Versión inicial con Webpack.

