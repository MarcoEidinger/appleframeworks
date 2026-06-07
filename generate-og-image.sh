#!/bin/bash

# Script to generate og-image.png from the HTML template
# This uses Chrome/Chromium headless mode to take a screenshot

echo "Generating og-image.png..."

# Check if we have Chrome or Chromium
if command -v /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome &> /dev/null; then
    CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
elif command -v chromium &> /dev/null; then
    CHROME="chromium"
else
    echo "Error: Chrome or Chromium not found. Please install Chrome."
    echo ""
    echo "Alternative: Open og-image-template.html in a browser and take a screenshot at 1200x630px"
    exit 1
fi

# Get the absolute path to the template
TEMPLATE_PATH="$(cd "$(dirname "$0")" && pwd)/og-image-template.html"
OUTPUT_PATH="$(cd "$(dirname "$0")" && pwd)/og-image.png"

# Take screenshot using Chrome headless
"$CHROME" --headless --screenshot="$OUTPUT_PATH" --window-size=1200,630 --default-background-color=0 "file://$TEMPLATE_PATH"

if [ -f "$OUTPUT_PATH" ]; then
    echo "✅ Success! og-image.png has been created."
    echo "   Location: $OUTPUT_PATH"
else
    echo "❌ Failed to generate image."
    echo ""
    echo "Manual method:"
    echo "1. Open og-image-template.html in your browser"
    echo "2. Set window size to 1200x630px"
    echo "3. Take a screenshot and save as og-image.png"
fi
