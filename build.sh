#!/bin/bash
# Build script for multi-language MkDocs site
# This script builds both English and Spanish versions and combines them

set -e

# Set library path for macOS
export DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib

echo "Building English site..."
cd en && uv run mkdocs build -d ../site/en
cd ..

echo "Building Spanish site..."
cd es && uv run mkdocs build -d ../site/es
cd ..

echo "Setting English as default (copying to root)..."
cp -r site/en/* site/

# Create a redirect index.html at root that goes to /en/
cat > site/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Redirecting...</title>
    <meta http-equiv="refresh" content="0; url=/en/">
    <link rel="canonical" href="https://joaquinurruti.com/en/">
</head>
<body>
    <p>Redirecting to <a href="/en/">English version</a>...</p>
</body>
</html>
EOF

echo "Build complete! Site is in ./site/"
echo "To test locally: cd site && python -m http.server"
