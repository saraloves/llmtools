#!/usr/bin/env sh
# Undo helper: revert header logo changes made by the site-logo patch.
# Usage: ./undo-logo.sh    (will create .bak.undo-logo backups)

set -e

FILES="index.html best-openclaw-skills.html llm-how-to-guide.html openclaw-vs-chatgpt.html openclaw-whatsapp-setup.html top-10-llms-2024.html underrated-llms.html assets-preview.html"

echo "Creating backups and reverting HTML changes..."
for f in $FILES; do
  if [ -f "$f" ]; then
    cp "$f" "$f.bak.undo-logo" 2>/dev/null || true
    perl -0777 -pe 's/class="site-logo"/style="height: 40px;"/g' -i "$f"
    echo "Reverted $f (backup: $f.bak.undo-logo)"
  fi
done

echo "Restoring CSS block in style.css (backup: style.css.bak.undo-logo)..."
cp style.css style.css.bak.undo-logo

# Replace the class-based block we added with the original attribute-based rules.
perl -0777 -pe '
s/\/\* Header logo — centered, responsive \*\/.*?\nheader p \{/\/\* Ensure logo.svg appears larger in the header across all pages *\/\nheader h1 a img[src$="logo.svg"] {\n    height: 64px !important;\n    width: auto !important;\n}\n\n\/\* Slightly smaller logo on narrow screens *\/\n@media (max-width: 768px) {\n    header h1 a img[src$="logo.svg"] {\n        height: 48px !important;\n    }\n}\n\nheader p {/s' -i style.css

echo "Done. If anything looks off, restore from the .bak.undo-logo files created next to each file."
