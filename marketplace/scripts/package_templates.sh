#!/bin/bash
# Package dbt templates for Gumroad distribution
# Run from the repo root: bash marketplace/scripts/package_templates.sh

set -e

DIST_DIR="./dist"
mkdir -p "$DIST_DIR"

TEMPLATES=(
    "saas-metrics:saas-metrics-dbt-template"
    "ecommerce-funnels:ecommerce-funnels-dbt-template"
    "fintech-analytics:fintech-analytics-dbt-template"
)

for entry in "${TEMPLATES[@]}"; do
    TEMPLATE_DIR="${entry%%:*}"
    OUTPUT_NAME="${entry##*:}"
    TEMPLATE_PATH="./templates/$TEMPLATE_DIR"

    echo "📦 Packaging $TEMPLATE_DIR..."

    if [ ! -d "$TEMPLATE_PATH" ]; then
        echo "  ⚠️  Template directory not found: $TEMPLATE_PATH"
        continue
    fi

    # Create clean temp directory
    TMP_DIR=$(mktemp -d)
    cp -r "$TEMPLATE_PATH" "$TMP_DIR/$OUTPUT_NAME"

    # Remove dev artifacts
    rm -rf "$TMP_DIR/$OUTPUT_NAME/target"
    rm -rf "$TMP_DIR/$OUTPUT_NAME/dbt_packages"
    find "$TMP_DIR/$OUTPUT_NAME" -name "*.pyc" -delete
    find "$TMP_DIR/$OUTPUT_NAME" -name "__pycache__" -delete

    # Create zip
    ZIP_PATH="$DIST_DIR/${OUTPUT_NAME}.zip"
    (cd "$TMP_DIR" && zip -r "$OLDPWD/$ZIP_PATH" "$OUTPUT_NAME" -x "*.DS_Store")

    # Cleanup
    rm -rf "$TMP_DIR"

    echo "  ✅ Created: $ZIP_PATH"
    echo "  📏 Size: $(du -sh "$ZIP_PATH" | cut -f1)"
done

echo ""
echo "✅ All templates packaged in $DIST_DIR/"
echo ""
echo "Next steps:"
echo "  1. Test each zip: unzip -t dist/*.zip"
echo "  2. Upload to Gumroad product assets"
echo "  3. Set pricing as per marketplace/gumroad/*-listing.md"
