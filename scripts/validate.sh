#!/usr/bin/env bash
# ============================================================================
# validate.sh
# Comprueba que el sitio está listo para subir antes del commit.
# IMPORTANTE: ejecuta desde la raíz del repo (cd ~/PaginaWeb-Imagen).
# ============================================================================
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
PASS=0; FAIL=0

ok()   { echo -e "  ${GREEN}✓${NC} $1"; PASS=$((PASS+1)); }
fail() { echo -e "  ${RED}✗${NC} $1"; FAIL=$((FAIL+1)); }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }
section() { echo -e "\n${YELLOW}▶ $1${NC}"; }

# ─── Comprobación previa ───
if [ ! -f "package.json" ]; then
  echo -e "${RED}❌ No estás en la raíz del repo.${NC}"
  echo "   cd ~/PaginaWeb-Imagen"
  echo "   bash scripts/validate.sh"
  exit 2
fi

section "1. Estructura del repo"
# Buscamos tanto archivos normales como dotfiles (.gitignore, .env.example, .github/*)
ROOT_FILES=$(ls -A | sort | grep -vE '^\.git$|node_modules$|dist$|\.cache$')
MISSING=()
for f in index.html coloracion.html peluqueria.html novias.html stylebook.html 404.html \
         css/style.css css/pages.css robots.txt sitemap.xml site.webmanifest \
         netlify.toml README.md .gitignore .github/workflows/deploy.yml .env.example; do
  if [ -f "$f" ]; then ok "Existe $f"; else fail "Falta $f"; fi
done

section "2. Cada HTML cumple requisitos SEO"
for f in *.html; do
  [ "$f" = "404.html" ] && continue
  has_canonical=$(grep -c 'rel="canonical"' "$f" || true)
  has_og=$(grep -c 'property="og:title"' "$f" || true)
  has_lang=$(grep -c 'lang="es"' "$f" || true)
  has_viewport=$(grep -c 'name="viewport"' "$f" || true)
  has_css=$(grep -c 'css/style.css' "$f" || true)

  [ "$has_canonical" -ge 1 ] && ok "$f tiene canonical" || fail "$f sin canonical"
  [ "$has_og" -ge 1 ] && ok "$f tiene OG title" || fail "$f sin OG"
  [ "$has_lang" -ge 1 ] && ok "$f tiene lang=es" || fail "$f sin lang"
  [ "$has_viewport" -ge 1 ] && ok "$f tiene viewport" || fail "$f sin viewport"
  [ "$has_css" -ge 1 ] && ok "$f enlaza style.css" || fail "$f sin CSS"
done

section "3. index.html tiene JSON-LD Schema.org"
if grep -q 'application/ld+json' index.html; then
  ok "JSON-LD presente"
  if grep -q '"@type": "HairSalon"' index.html; then
    ok "Tipo HairSalon correcto"
  else
    fail "Tipo no es HairSalon"
  fi
else
  fail "Falta JSON-LD"
fi

section "4. sitemap.xml es XML válido"
if python3 -c "import xml.etree.ElementTree as ET; ET.parse('sitemap.xml'); print('ok')" 2>/dev/null; then
  ok "sitemap.xml parsea correctamente"
else
  fail "sitemap.xml no es XML válido"
fi

section "5. Imágenes tienen alt + loading"
img_no_alt=$(python3 - <<'PY' 2>/dev/null || echo 0
import re, pathlib
total = 0
for f in pathlib.Path('.').glob('*.html'):
    if f.name == '404.html': continue
    txt = f.read_text()
    for m in re.finditer(r'<img\s[^>]*>', txt):
        if 'alt=' not in m.group():
            total += 1
print(total)
PY
)
[ "$img_no_alt" = "0" ] && ok "Todas las <img> tienen alt" || fail "$img_no_alt imágenes sin alt"

img_no_loading=$(python3 - <<'PY' 2>/dev/null || echo 0
import re, pathlib
total = 0
for f in pathlib.Path('.').glob('*.html'):
    if f.name == '404.html': continue
    txt = f.read_text()
    for m in re.finditer(r'<img\s[^>]*>', txt):
        if 'loading=' not in m.group():
            total += 1
print(total)
PY
)
[ "$img_no_loading" = "0" ] && ok "Todas las <img> tienen loading" || warn "$img_no_loading imágenes sin loading"

section "6. Consistencia de datos del negocio"
if grep -q "José de Cadalso 86" index.html; then
  ok "Dirección coherente en index"
else
  fail "Dirección no encontrada en index"
fi

section "7. Sin restos de Webpack / IDE / archivos antiguos"
for f in webpack.common.js webpack.config.dev.js webpack.config.prod.js .idea .DS_Store; do
  if [ -e "$f" ]; then
    fail "Aún existe $f en disco"
  elif git ls-files --error-unmatch "$f" >/dev/null 2>&1; then
    warn "$f sigue trackeado en Git — ejecuta: git rm -f $(printf '%q' "$f")"
  else
    ok "Sin $f"
  fi
done

if [ -e "codigo ni tan mal" ]; then
  fail "Aún existe 'codigo ni tan mal' en disco"
elif git ls-files --error-unmatch "codigo ni tan mal" >/dev/null 2>&1; then
  warn "'codigo ni tan mal' sigue trackeado en Git — ejecuta: git rm 'codigo ni tan mal'"
else
  ok "Sin archivo 'codigo ni tan mal'"
fi

section "8. package.json válido"
if python3 -c "import json; json.load(open('package.json'))" 2>/dev/null; then
  ok "JSON parsea"
else
  fail "JSON inválido"
fi

echo ""
echo -e "════════════════════════════════════════"
echo -e "  ${GREEN}Pasados:   $PASS${NC}"
if [ "$FAIL" -gt 0 ]; then
  echo -e "  ${RED}Fallados:  $FAIL${NC}"
  exit 1
else
  echo -e "  ${GREEN}Fallados:  0${NC}"
fi
echo -e "════════════════════════════════════════"


