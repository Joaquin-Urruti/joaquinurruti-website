# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

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

# Docker-based development (alternative)
./start_server.sh              # Builds image if needed, serves on :8000
docker build -t mkdocs-site .  # Build Docker image manually
```

## Environment Variables

Google Analytics and other secrets are managed via environment variables to keep them out of version control.

- **Local development**: Create a `.env` file at the project root (already in `.gitignore`):
  ```
  GOOGLE_ANALYTICS_KEY=<your-ga-tracking-id>
  ```
- **CI/CD**: Set `GOOGLE_ANALYTICS_KEY` as a GitHub repository secret.
- **Docker**: The `start_server.sh` script passes `.env` to the container via `--env-file`.
- **MkDocs config**: Uses `!ENV [GOOGLE_ANALYTICS_KEY, '']` in `mkdocs.yml` (built-in MkDocs YAML tag). Analytics are silently disabled if the variable is unset.

## Deployment

Automatic via GitHub Actions on push to `main`. The workflow:
1. Builds English site to `site/en/`
2. Builds Spanish site to `site/es/`
3. Copies English as default to `site/` root
4. Creates redirect from root to `/en/`
5. Deploys to GitHub Pages with CNAME

**Note**: CI installs `mkdocs-material` (without `[imaging]`), so social card image generation is not available in CI. Locally, `uv sync` or `pip install "mkdocs-material[imaging]"` includes imaging support.

## Architecture

```
joaquinurruti-website/
├── en/                              # English project
│   ├── mkdocs.yml                   # English config (language: en)
│   └── docs/
│       ├── index.md                 # Homepage
│       ├── CNAME                    # GitHub Pages custom domain
│       ├── assets/ -> ../../shared/assets/    # Symlink to shared assets
│       ├── portfolio/
│       │   ├── index.md
│       │   └── projects/
│       │       ├── project-1.md
│       │       └── project-2.md
│       ├── blog/
│       │   ├── index.md
│       │   ├── .authors.yml
│       │   └── posts/
│       └── stylesheets/ -> ../../shared/stylesheets/  # Symlink to shared stylesheets
├── es/                              # Spanish project (mirrors en/ structure)
│   ├── mkdocs.yml                   # Spanish config (language: es)
│   └── docs/
├── shared/                          # Shared assets and stylesheets
│   ├── assets/                      # Images, logos, favicons
│   │   ├── logo_ju.svg
│   │   ├── favicon_ju.png
│   │   ├── landing_image.jpg
│   │   └── project-1/              # Project-specific images
│   └── stylesheets/                 # Shared CSS files
│       ├── extra.css                # Theme colors, buttons, cards, FAQ
│       └── hero.css                 # Homepage hero section & layout
├── .env                             # Local env vars (gitignored)
├── build.sh                         # Build script for both languages
├── start_server.sh                  # Docker-based dev server
├── Dockerfile                       # Container for mkdocs-material[imaging]
├── pyproject.toml                   # Python deps (uv)
├── requirements.txt                 # Python deps (pip)
└── .github/workflows/ci.yml        # CI/CD pipeline
```

## Multi-Language Setup

The site uses **separate MkDocs projects per language** instead of the i18n plugin (which is incompatible with the blog plugin). Each project:

- Has its own `mkdocs.yml` with `theme.language` set appropriately
- Contains `extra.alternate` for the language selector linking to `/en/` and `/es/`
- Has independent blog functionality
- Shares assets and stylesheets via **symlinks** to `/shared/`

### Adding New Content

1. **English content**: Add/edit files in `en/docs/`
2. **Spanish content**: Add/edit files in `es/docs/`
3. Update navigation in both `en/mkdocs.yml` and `es/mkdocs.yml`
4. **If adding images**: Place them in `shared/assets/` - they'll be available to both languages automatically
5. **If adding CSS**: Place them in `shared/stylesheets/` - they'll be available to both languages automatically

### Adding a New Language

1. Copy `en/` directory to new language code (e.g., `pt/`)
2. Update `mkdocs.yml`: set `theme.language`, `site_url`, translate nav
3. Add the new language to `extra.alternate` in ALL language configs
4. Update `build.sh` and `.github/workflows/ci.yml`

## Key Configuration

Each `mkdocs.yml` includes:
- **Theme**: Material for MkDocs with custom colors (dark navy `#1A1B41` primary, blue/lime accent)
- **Fonts**: Raleway (text), Roboto Mono (code)
- **Plugins**: search, social (auto-generates social cards), blog (with categories)
- **Extensions**: syntax highlighting, admonitions, emoji, collapsible details, key bindings
- **Navigation**: tabs -- "Home", "Case Studies" (en) / "Casos de Estudio" (es), "Blog"
- **Language selector**: `extra.alternate` links between `/en/` and `/es/`
- **Analytics**: Google Analytics via `!ENV [GOOGLE_ANALYTICS_KEY]` (see Environment Variables)
- **Social links**: GitHub, LinkedIn, YouTube, website (in footer)
- **Copyright**: Footer with author credit and year

## Content Workflow

All content is Markdown with YAML frontmatter. Custom styling uses CSS classes defined in `docs/stylesheets/`. The social plugin auto-generates OpenGraph images for sharing.
