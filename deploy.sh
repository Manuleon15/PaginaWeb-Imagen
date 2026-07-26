#!/bin/bash
# ============================================================
# deploy.sh — Aplica la v2.1 final y la sube a GitHub
# Uso:  cd ~/Desktop/untitled && bash deploy.sh
# ============================================================
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Comprobaciones previas ---
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "❌ Este script debe ejecutarse DENTRO del repo (donde está .git)."
  echo "   cd ~/Desktop/untitled && bash deploy.sh"
  exit 1
fi

if [ ! -f "$REPO_DIR/_release/index.html" ]; then
  echo "❌ No encuentro la carpeta _release/. Descomprime el zip dentro del repo:"
  echo "   cd ~/Desktop/untitled && unzip -o ~/Downloads/imagen-madrid-release.zip"
  exit 1
fi

echo "▶ Copiando archivos de la v2.1 final..."
cp -f "$REPO_DIR/_release/index.html"        "$REPO_DIR/index.html"
cp -f "$REPO_DIR/_release/coloracion.html"   "$REPO_DIR/coloracion.html"
cp -f "$REPO_DIR/_release/peluqueria.html"   "$REPO_DIR/peluqueria.html"
cp -f "$REPO_DIR/_release/novias.html"       "$REPO_DIR/novias.html"
cp -f "$REPO_DIR/_release/stylebook.html"    "$REPO_DIR/stylebook.html"
cp -f "$REPO_DIR/_release/404.html"          "$REPO_DIR/404.html"
cp -f "$REPO_DIR/_release/css/style.css"     "$REPO_DIR/css/style.css"
cp -f "$REPO_DIR/_release/css/pages.css"     "$REPO_DIR/css/pages.css"
mkdir -p "$REPO_DIR/js" "$REPO_DIR/img/gallery"
cp -f "$REPO_DIR/_release/js/app.js"         "$REPO_DIR/js/app.js"
cp -f "$REPO_DIR/_release/img/"*.webp        "$REPO_DIR/img/" 2>/dev/null || true
cp -f "$REPO_DIR/_release/img/gallery/"*.webp "$REPO_DIR/img/gallery/" 2>/dev/null || true

# Borrar PNGs antiguos que ya no se usan
rm -f "$REPO_DIR/img/image_4.png" "$REPO_DIR/img/image_5.png" "$REPO_DIR/img/image_6.png" \
      "$REPO_DIR/img/image_7.png" "$REPO_DIR/img/image_8.png" "$REPO_DIR/img/image_9.png"

# Limpiar la carpeta _release
rm -rf "$REPO_DIR/_release"

echo "▶ Estado antes del commit:"
git status --short | head -40

echo ""
read -p "¿Continuar con commit y push a GitHub? (s/n): " CONFIRM
if [ "$CONFIRM" != "s" ] && [ "$CONFIRM" != "S" ]; then
  echo "⏸  Abortado. Los archivos están copiados pero sin commit."
  exit 0
fi

git add -A
git commit -m "feat(2.1): nueva clasificación servicios, sección productos, fotos reales WebP

- Servicios: Color / Corte y Peinado / Eventos con nuevas descripciones
- Páginas de servicio: layout 2 columnas con sub-servicios detallados
- Nueva sección 'Conoce nuestros productos' (Tahe, Mïmare, Schwarzkopf)
- Fotos reales del salón y trabajos en WebP (480w + 1200w)
- WhatsApp actualizado a +34 613 00 01 34
- Textos de hero, equipo y stylebook actualizados
- Frase de presupuesto personalizado en cada servicio"

echo "▶ Subiendo a GitHub..."
git push origin main

echo ""
echo "✅ Listo. La web está actualizada en GitHub."
echo "   Si tienes GitHub Pages activo, se verá en ~1 minuto."

