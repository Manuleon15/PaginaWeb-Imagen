# Imagen Beauty & Hair — Sitio web

Sitio web oficial de **Peluquería Imagen Madrid**, salón de belleza en el barrio de Latina (Madrid). Fundado en 2003 por Chon Muñoz, con más de 20 años de experiencia especializados en recogidos de novia y coloración.

📍 Calle José de Cadalso 86, Latina, Madrid 28044
📞 91 705 06 26

## ✨ Características

- **100% estático**: HTML + CSS sin frameworks ni build step.
- **SEO local optimizado**: Schema.org `HairSalon` + Open Graph + sitemap.xml.
- **Performance**: preconnect a CDNs externos, cero JavaScript de terceros.
- **Accesibilidad WCAG AA**: skip-link, `aria-label` en CTAs, contraste dorado/negro sobre blanco.
- **Mobile-first**: diseño responsive desde 480px hasta desktop.

## 📂 Estructura

```
.
├── index.html              # Portada
├── coloracion.html         # Servicio: coloración
├── peluqueria.html         # Servicio: corte y peinado
├── novias.html             # Servicio: novias y eventos
├── stylebook.html          # Galería de trabajos
├── 404.html                # Página de error (en español)
│
├── css/
│   ├── style.css           # Estilos compartidos
│   └── pages.css           # Estilos específicos por página
│
├── img/                    # Imágenes WebP optimizadas
│   ├── hero.webp
│   └── gallery/            # Imágenes del Style Book
│
├── scripts/
│   ├── validate.sh         # 53 checks automáticos
│   └── convert-to-webp.sh  # PNG → WebP
│
├── icon.png / favicon.ico
├── robots.txt / sitemap.xml / site.webmanifest
│
├── netlify.toml            # Configuración de despliegue
└── .github/workflows/      # CI/CD
```

## 🚀 Desarrollo local

No hay build step. Para previsualizar:

```bash
python3 -m http.server 8000
# o
npx serve .
```

Abre <http://localhost:8000>.

## ✏️ Editar contenido

### Cambiar datos del negocio

Buscar en todos los HTML:

| Dato | Valor actual |
|------|--------------|
| Nombre | `Imagen Beauty & Hair` |
| Teléfono | `91 705 06 26` / `+34917050626` |
| Dirección | `Calle José de Cadalso 86` |
| Latitud/Longitud | `40.374163` / `-3.7745771` |

El JSON-LD está solo en `index.html`.

### Cambiar el color de acento

En `css/style.css`, dentro de `:root`:

```css
:root {
  --color-acento: #b38b5d;        /* Cambia esto */
  --color-acento-hover: #92704a;
}
```

## 📦 Despliegue

Lee `DEPLOY.md` para desplegar en Netlify con CI/CD de GitHub Actions.

## 📄 Licencia

MIT para el código. El contenido textual y la marca son propiedad del salón.

