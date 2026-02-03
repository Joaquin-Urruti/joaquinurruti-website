# Portfolio Website with MkDocs Material

This repository provides a template for creating a professional freelance portfolio website using MkDocs Material. Originally designed for technical documentation, MkDocs Material has evolved into a [powerful framework](https://squidfunk.github.io/mkdocs-material/blog/2024/08/19/how-were-transforming-material-for-mkdocs/) that's perfect for portfolios, blogs, and personal websites - all manageable through simple Markdown and YAML files.

## Why MkDocs Material?

- **Quick Setup**: Get your site running in minutes
- **Markdown-Based**: Write content in simple Markdown
- **Code-Friendly**: Built-in syntax highlighting and code blocks
- **Responsive Design**: Looks great on all devices
- **No Frontend Skills Needed**: Professional design out of the box
- **SEO Optimized**: Built-in SEO features
- **Search Functionality**: Full-text search included
- **Social Cards**: Auto-generated preview cards for social media sharing
- **Dark Mode**: Automatic dark/light theme switching

As you go through this setup, please find all the most up to date information in the [official documentation here](https://squidfunk.github.io/mkdocs-material/getting-started/).

## Quick Start


### Option 1: Local Installation (Recommended for Mac Users)

1. **Clone this repository**
   ```bash
   git clone https://github.com/data-freelancer-mastermind/mkdocs-website-template.git
   cd mkdocs-website-template
   ```

2. **Install MkDocs Material**
   ```bash
   pip install "mkdocs-material[imaging]"
   
   # For MacOS, install required dependencies
   brew install cairo freetype libffi libjpeg libpng zlib pngquant
   ```

3. **Preview your site**
   ```bash
    # For MacOS M1/M2 users
    export DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib
    mkdocs serve
   ```
   Visit `http://localhost:8000` to see your site.

> **Note on Operating Systems**: 
> - This setup has been thoroughly tested on MacOS (Intel and Apple Silicon)
> - Windows setup instructions are still being updated
> - If you encounter any issues on Windows:
>   1. First, check the [official MkDocs Material documentation](https://squidfunk.github.io/mkdocs-material/getting-started/)
>   2. Try to resolve the issue using their troubleshooting guides
>   3. If the problem persists, please message Dave on Circle for assistance
>   4. Your feedback will help improve the documentation for other Windows users!


### Option 2: Using Docker (Recommended for Windows, Mac and Linux)

Docker provides a consistent environment across all operating systems, making it an excellent choice for development. This method works reliably on Windows, MacOS, and Linux.

-> Special thanks to our community member, Nisar, for contributing the Docker implementation! 🐳

1. **Download & Install Docker Desktop**
https://docs.docker.com/get-started/get-docker/

2. **Clone this repository**
   ```bash
   git clone https://github.com/data-freelancer-mastermind/mkdocs-website-template.git
   cd mkdocs-website-template
   ```

3. **Start the server**
   ```bash
   chmod +x start_server.sh
   ./start_server.sh
   ```
   Visit `http://localhost:8000` to see your site.

## Customizing Your Portfolio

### 1. Basic Configuration

Edit `en/mkdocs.yml` and `es/mkdocs.yml` to customize your site:

- Site name and metadata
- Navigation structure (translate nav items in each language)
- Color scheme and fonts
- Custom CSS settings in `docs/stylesheets/extra.css`
- Social links
- Extensions and plugins
- Language selector via `extra.alternate`

### 2. Content Structure (Multi-Language)

This site uses **separate MkDocs projects per language** to support both English and Spanish with full blog functionality.

```bash
en/                          # English project
├── mkdocs.yml               # English configuration
└── docs/
    ├── index.md             # Homepage
    ├── portfolio/           # Case studies
    │   ├── index.md
    │   └── projects/
    ├── blog/                # Blog posts
    │   ├── index.md
    │   ├── .authors.yml
    │   └── posts/
    ├── stylesheets/         # Custom CSS
    └── assets/              # Images and files

es/                          # Spanish project (same structure)
├── mkdocs.yml               # Spanish configuration
└── docs/
```

### 3. Building the Site

```bash
# Build both languages (outputs to site/)
./build.sh

# Or serve individually for development
cd en && mkdocs serve   # English at localhost:8000
cd es && mkdocs serve   # Spanish at localhost:8000
```

The `build.sh` script:
1. Builds English to `site/en/`
2. Builds Spanish to `site/es/`
3. Creates a root redirect to `/en/`

## Deployment

I recommend publishing your site with GitHub Pages. If you want to keep your repo private, you need a GitHub Pro subscription. Public repos can be deployed with a free GitHub account.

1. Push your repository to GitHub
2. Follow the instructions here: [Publishing your site](https://squidfunk.github.io/mkdocs-material/publishing-your-site/)
3. Set up the GitHub actions for your project
4. Test the deployment by pushing changes

### Custom Domain

1. Add a `CNAME` file in `en/docs/` and `es/docs/` with your domain (or configure in CI workflow)
2. Go to `repository/settings/pages` and check the domain settings
3. Follow the [instructions here](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site) to configure your domain and DNS settings
4. Also enable HTTPS on this page

> **Note**: The GitHub Actions workflow (`ci.yml`) is configured to set the CNAME during deployment.

## Useful Resources

- [Official MkDocs Material Documentation](https://squidfunk.github.io/mkdocs-material/getting-started/)
- [Icons and Emojis Reference](https://squidfunk.github.io/mkdocs-material/reference/icons-emojis/)
- [Blog Setup Guide](https://squidfunk.github.io/mkdocs-material/blog/)
- [Social Cards Configuration](https://squidfunk.github.io/mkdocs-material/plugins/requirements/image-processing/)
