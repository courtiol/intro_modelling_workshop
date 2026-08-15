#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="figures/article_selection"
OUT_DIR="figures/article_selection/normalized"
TARGET_W=800
TARGET_H=300
BG="white"   # use "none" for transparent padding (requires PNG output)

mkdir -p "$OUT_DIR"

for f in "$SRC_DIR"/article_*; do
  fname=$(basename "$f")
  magick "$f" \
    -resize "${TARGET_W}x${TARGET_H}" \
    -background "$BG" \
    -gravity center \
    -extent "${TARGET_W}x${TARGET_H}" \
    "$OUT_DIR/$fname"
done

echo "Normalized $(ls "$OUT_DIR" | wc -l) images into $OUT_DIR"
