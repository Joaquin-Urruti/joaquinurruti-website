# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal portfolio website for an AI & GIS Engineer built with MkDocs Material. Static site generator that transforms Markdown content into a responsive website. **Multi-language support** (English and Spanish) using separate MkDocs projects per language.

## Common Commands

```bash
# Install dependencies
pip install "mkdocs-material[imaging]"
# Or with uv:
uv sync

# macOS may need this before serving/building:
export DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib

# Build both language sites (outputs to site/)
./build.sh

# Serve individual language for development (hot reload on http://localhost:8000)
cd en && uv run mkdocs serve   # English
cd es && uv run mkdocs serve   # Spanish

# Test the combined site locally
./build.sh && cd site && python -m http.server
```

## Deployment

Automatic via GitHub Actions on push to `main`. The workflow:
1. Builds English site to `site/en/`
2. Builds Spanish site to `site/es/`
3. Copies English as default to `site/` root
4. Creates redirect from root to `/en/`
5. Deploys to GitHub Pages with CNAME

## Architecture

```
joaquinurruti-website/
├── en/                          # English project
│   ├── mkdocs.yml               # English config (language: en)
│   └── docs/
│       ├── index.md             # Homepage
│       ├── portfolio/
│       │   ├── index.md
│       │   └── projects/
│       │       ├── project-1.md
│       │       └── project-2.md
│       ├── blog/
│       │   ├── index.md
│       │   ├── .authors.yml
│       │   └── posts/
│       └── stylesheets/
│           ├── extra.css
│           └── hero.css
├── es/                          # Spanish project (same structure)
│   ├── mkdocs.yml               # Spanish config (language: es)
│   └── docs/
├── build.sh                     # Build script for both projects
└── .github/workflows/ci.yml     # CI/CD pipeline
```

## Multi-Language Setup

The site uses **separate MkDocs projects per language** instead of the i18n plugin (which is incompatible with the blog plugin). Each project:

- Has its own `mkdocs.yml` with `theme.language` set appropriately
- Contains `extra.alternate` for the language selector linking to `/en/` and `/es/`
- Has independent blog functionality
- Shares the same styling (CSS files are duplicated in each project)

### Adding New Content

1. **English content**: Add/edit files in `en/docs/`
2. **Spanish content**: Add/edit files in `es/docs/`
3. Update navigation in both `en/mkdocs.yml` and `es/mkdocs.yml`

### Adding a New Language

1. Copy `en/` directory to new language code (e.g., `pt/`)
2. Update `mkdocs.yml`: set `theme.language`, `site_url`, translate nav
3. Add the new language to `extra.alternate` in ALL language configs
4. Update `build.sh` and `.github/workflows/ci.yml`

## Key Configuration

Each `mkdocs.yml` includes:
- Theme: Material for MkDocs with custom colors (dark navy primary, blue/lime accent)
- Plugins: search, social (auto-generates social cards), blog
- Extensions: syntax highlighting, admonitions, emoji, collapsible details
- Navigation: tabs with sections for portfolio and blog
- `extra.alternate`: Language selector links

## Content Workflow

All content is Markdown with YAML frontmatter. Custom styling uses CSS classes defined in `docs/stylesheets/`. The social plugin auto-generates OpenGraph images for sharing.
