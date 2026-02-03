# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal portfolio website for an AI & GIS Engineer built with MkDocs Material. Static site generator that transforms Markdown content into a responsive website.

## Common Commands

```bash
# Install dependencies
pip install "mkdocs-material[imaging]"
# Or with uv:
uv sync

# Run development server (hot reload on http://localhost:8000)
mkdocs serve

# macOS may need this before mkdocs serve:
export DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib

# Build static site (outputs to site/)
mkdocs build

# Alternative: Docker setup
./start_server.sh
```

## Deployment

Automatic via GitHub Actions on push to `main`. The workflow builds and deploys to GitHub Pages using `mkdocs gh-deploy --force`. Custom domain configured via `docs/CNAME`.

## Architecture

- **docs/** - All source content as Markdown files
  - `index.md` - Homepage with hero, about, testimonials, FAQ sections
  - `portfolio/projects/` - Case study pages with technical documentation
  - `blog/posts/` - Blog articles (uses MkDocs blog plugin)
  - `stylesheets/` - Custom CSS (`extra.css` for theme, `hero.css` for landing layout)
  - `assets/` - Images and static files
- **mkdocs.yml** - Primary configuration: navigation, theme, plugins, extensions
- **pyproject.toml** - Python 3.11+ with single dependency: `mkdocs-material[imaging]`

## Key Configuration (mkdocs.yml)

- Theme: Material for MkDocs with custom colors (dark navy primary, blue/lime accent)
- Plugins: search, social (auto-generates social cards), blog
- Extensions: syntax highlighting, admonitions, emoji, collapsible details
- Navigation: tabs with sections for portfolio and blog

## Content Workflow

All content is Markdown with YAML frontmatter. Custom styling uses CSS classes defined in `docs/stylesheets/`. The social plugin auto-generates OpenGraph images for sharing.
