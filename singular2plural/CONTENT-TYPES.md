# Hugo Blox Content Types

This document outlines the standardized content types used in Hugo Blox.

## Standard Content Types

Hugo Blox uses standardized, intuitive content types that match user expectations for URL patterns and organizational structure.

| Content Type | Directory | URL Path | Description |
|-------------|-----------|----------|-------------|
| `blog` | `/content/blog/` | `/blog/` | Blog posts |
| `projects` | `/content/projects/` | `/projects/` | Portfolio/project items |
| `publications` | `/content/publications/` | `/publications/` | Academic papers, books, etc. |
| `events` | `/content/events/` | `/events/` | Talks, conferences, workshops |
| `courses` | `/content/courses/` | `/courses/` | Educational courses and tutorials |
| `authors` | `/content/authors/` | `/authors/` | Author profiles |
| `docs` | `/content/docs/` | `/docs/` | Documentation pages |

## URL Structure

Content types follow these URL structure best practices:

1. **Plural for collections**: Most content sections use plural names (e.g., `/projects/`, `/publications/`)
2. **Exception for blog**: The `blog` section uses the singular form as this is the universal convention

## Taxonomy Structure

Taxonomies are consistently pluralized:

```yaml
taxonomies:
  author: authors
  tag: tags
  publication_type: publication_types
```

## Content Front Matter

Content should include appropriate `type` in front matter to ensure proper template selection, otherwise Hugo will attempt to infer content type from the folder name:

```yaml
---
title: "Example Post"
type: blog
date: 2023-01-01
---
```

## Legacy Compatibility

For backward compatibility with old content using singular section names (e.g., `/publication/` instead of `/publications/`), you can add redirects in your `netlify.toml` or similar configuration:

```toml
[[redirects]]
  from = "/publication/*"
  to = "/publications/:splat"
  status = 301
  force = true

[[redirects]]
  from = "/project/*"
  to = "/projects/:splat"
  status = 301
  force = true
```
