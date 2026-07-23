#!/usr/bin/env bash
# Convierte las imágenes del repo (PNG/JPG) a WebP optimizado.
# Necesita: cwebp (brew install webp / sudo apt install webp)
# Ejecutar desde la raíz del repo.
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

if ! command -v cwebp >/dev/null 2>&1; then
  echo -e "${RED}❌ cwebp no instalado.${NC}"
  echo "   macOS:  brew install webp"
  echo "   Linux:  sudo apt install webp"
  exit 1
fi

if [ ! -f "package.json" ]; then
  echo -e "${RED}❌ No estás en la raíz del repo.${NC}"
  exit 2
fi

IMG_DIR="img"
GALLERY_DIR="img/gallery"
mkdir -p "$GALLERY_DIR"

processed=0
saved=0

convert() {
  local input="$1"
  local output="$2"
  local width="$3"
  local src_size dst_size
  src_size=$(stat -c%s "$input" 2>/dev/null || stat -f%z "$input")
  cwebp -quiet -q 80 -resize "$width" "$input" -o "$output"
  dst_size=$(stat -c%s "$output" 2>/dev/null || stat -f%z "$output")
  if [ "$dst_size" -lt "$src_size" ]; then
    saved=$((saved + (src_size - dst_size)))
  fi
  processed=$((processed + 1))
  echo -e "  ${GREEN}✓${NC} $(basename "$input") → $(basename "$output") (${width}px)"
}

echo -e "${YELLOW}Convirtiendo hero...${NC}"
for f in "$IMG_DIR"/image_4.*; do
  [ -f "$f" ] || continue
  convert "$f" "$IMG_DIR/hero.webp" 1920
done

echo -e "${YELLOW}Convirtiendo galería...${NC}"
for n in 5 6 7 8 9; do
  for f in "$IMG_DIR"/image_${n}.*; do
    [ -f "$f" ] || continue
    convert "$f" "$GALLERY_DIR/image_${n}.webp" 1200
  done
done

echo ""
echo -e "${GREEN}✓ $processed imágenes convertidas${NC}"
echo -e "${GREEN}✓ ~$saved bytes ahorrados${NC}"

