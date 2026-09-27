#!/usr/bin/env bash
# ==============================================================================
# skill-mcp-ahrefs validator
# Validates skill structure, line count limits, and zero orphan references.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_FILE="$SCRIPT_DIR/SKILL.md"

echo "=== Validating Ahrefs SEO Intelligence Skill ==="

# 1. Check SKILL.md existence
if [[ ! -f "$SKILL_FILE" ]]; then
  echo "❌ Error: SKILL.md not found at $SKILL_FILE"
  exit 1
fi
echo "✓ SKILL.md exists."

# 2. Check Line Count (<500 lines)
LINE_COUNT=$(wc -l < "$SKILL_FILE")
if [[ "$LINE_COUNT" -gt 500 ]]; then
  echo "❌ Error: SKILL.md exceeds 500 lines ($LINE_COUNT lines)."
  exit 1
fi
echo "✓ SKILL.md line count: $LINE_COUNT lines (<500 lines limit)."

# 3. Check YAML frontmatter
if ! grep -q "^---" "$SKILL_FILE"; then
  echo "❌ Error: SKILL.md missing opening frontmatter delimiter."
  exit 1
fi
if ! grep -q "^name: ahrefs-seo-intelligence" "$SKILL_FILE"; then
  echo "❌ Error: SKILL.md missing or invalid 'name' property."
  exit 1
fi
if ! grep -q "^description:" "$SKILL_FILE"; then
  echo "❌ Error: SKILL.md missing 'description' property."
  exit 1
fi
echo "✓ YAML frontmatter valid."

# 4. Check for Orphan References
echo "Checking for orphan references..."
ORPHANS=0
while IFS= read -r ref_file; do
  base_name="$(basename "$ref_file")"
  if ! grep -q "$base_name" "$SKILL_FILE"; then
    echo "❌ Orphan reference detected: $ref_file"
    ORPHANS=$((ORPHANS + 1))
  fi
done < <(find "$SCRIPT_DIR/references" -name '*.md' -type f)

if [[ "$ORPHANS" -gt 0 ]]; then
  echo "❌ Validation failed: $ORPHANS orphan reference(s) found."
  exit 1
fi

TOTAL_REFS=$(find "$SCRIPT_DIR/references" -name '*.md' -type f | wc -l)
echo "✓ Zero orphan references. All $TOTAL_REFS reference files are indexed and routed."
echo "=== All Quality Gates Passed Successfully! ==="
