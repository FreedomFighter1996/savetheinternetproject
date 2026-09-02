#!/usr/bin/env bash
#
# Regenerates preview.html (and preview.artifact.html) from the live site files.
#
# Each page has its stylesheet and script inlined, is base64 encoded, and is
# embedded in the preview shell so the whole thing works as a single file with
# no server. Run this after any change to the site or the preview will be stale.
#
#   sh tools/build-preview.sh
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PAGES="index pitch daily contribute about"
CSS="assets/css/style.css"
JS="assets/js/main.js"
SHELL_FILE="tools/preview-shell.html"

for f in "$CSS" "$JS" "$SHELL_FILE"; do
  [ -f "$f" ] || { echo "missing: $f" >&2; exit 1; }
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Replace the external <link> and <script> with their file contents.
inline_page() {
  awk -v cssfile="$CSS" -v jsfile="$JS" '
    index($0, "<link rel=\"stylesheet\" href=\"assets/css/style.css\">") {
      print "<style>"
      while ((getline line < cssfile) > 0) print line
      close(cssfile)
      print "</style>"
      next
    }
    index($0, "<script src=\"assets/js/main.js\">") {
      print "<script>"
      while ((getline line < jsfile) > 0) print line
      close(jsfile)
      print "</scr" "ipt>"
      next
    }
    { print }
  ' "$1"
}

{
  echo "var PAGES = {"
  for page in $PAGES; do
    src="${page}.html"
    [ -f "$src" ] || { echo "missing: $src" >&2; exit 1; }
    printf '  "%s": "%s",\n' "$page" "$(inline_page "$src" | base64 -w 0)"
  done
  echo "};"
} > "$TMP/pages.js"

# Drop the encoded pages into the shell at the marker.
awk -v datafile="$TMP/pages.js" '
  index($0, "/*__PAGES__*/") {
    while ((getline line < datafile) > 0) print line
    close(datafile)
    next
  }
  { print }
' "$SHELL_FILE" > "$TMP/fragment.html"

# Body-only version, for publishing as an Artifact.
cp "$TMP/fragment.html" preview.artifact.html

# Standalone version, for opening from disk.
{
  echo '<!DOCTYPE html>'
  echo '<html lang="en">'
  echo '<head>'
  echo '<meta charset="utf-8">'
  echo '<meta name="viewport" content="width=device-width, initial-scale=1">'
  echo '</head>'
  echo '<body style="margin:0">'
  cat "$TMP/fragment.html"
  echo '</body>'
  echo '</html>'
} > preview.html

echo "built preview.html          ($(wc -c < preview.html) bytes)"
echo "built preview.artifact.html ($(wc -c < preview.artifact.html) bytes)"
