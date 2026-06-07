# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a static website that displays a comprehensive, filterable table of all public Apple frameworks with their platform availability information (iOS, macOS, watchOS, tvOS, visionOS, macCatalyst, iPadOS). The site is deployed to GitHub Pages at https://marcoeidinger.github.io/appleframeworks.

## Architecture

**Single-file application**: The entire website is contained in `index.html` (~3600 lines), which includes:
- HTML markup with embedded framework data (284 table rows of framework entries)
- Inline JavaScript at the bottom for filtering logic and TableFilter configuration
- Inline CSS for styling overrides
- External dependencies loaded from `node_modules/` (Bulma CSS, TableFilter JS)

**Core dependencies**:
- `tablefilter` (v0.7.2): Provides the interactive table filtering UI and logic
- `bulma` (v0.9.4): CSS framework for styling

**Data structure**: Each framework is a table row with:
- Framework name (linked to Apple's developer documentation)
- Minimum version numbers for each platform (or empty if unsupported)
- Beta frameworks are prefixed with "Beta - " in their name

## Key Functionality

**Filtering system** (lines 3515-3555):
- `filter()` function maps dropdown selections to TableFilter API calls
- Uses TableFilter operators like `[nonempty]`, `[empty]`, and `>= N` to filter by platform
- Custom filter presets: "all", "beta", "ios", "ios13+", "ios-not-watch", "mac", "mac-not-ios", "watchos", "tvos", "visionOS"
- TableFilter instance (`tf`) initialized with config at lines 3557-3577

**TableFilter configuration** (lines 3557-3574):
- `base_path` points to CDN for TableFilter assets
- `sticky_headers: true` keeps headers visible while scrolling
- `auto_filter` with 500ms delay for responsive text-box filtering
- `rows_counter` and `status_bar` enabled for user feedback

## Development Commands

**Install dependencies**:
```bash
npm ci
```

**Deploy to GitHub Pages**:
```bash
npm run deploy
```
This uses `gh-pages` package to deploy the current directory to the `gh-pages` branch.

**CI/CD**: GitHub Actions workflow (`.github/workflows/ci.yml`) automatically deploys to GitHub Pages on every push to `main`.

## Updating Framework Data

Framework data is embedded directly in the HTML table (lines 86-3498). The `<tbody>` HTML is generated using the Swift CLI tooling in `../appleframeworks-cli`.

### Using the Generation Tooling

The `appleframeworks-cli` repository contains a Swift program that:

1. **Dynamically fetches all frameworks** from Apple's developer documentation API using `AppleFrameworkDocumentationProvider().fetchTechnologies()`
2. **Fetches metadata** for each framework including:
   - Framework name and description
   - Platform availability (iOS, macOS, watchOS, tvOS, visionOS, macCatalyst, iPadOS)
   - Minimum version introduced on each platform
   - Beta and deprecated status
3. **Generates `<tbody>` HTML** via the `tbodyHTML()` extension method
4. **Copies output to clipboard** for pasting into `index.html`

**To update framework data**:

1. Navigate to `../appleframeworks-cli`
2. Run the Swift CLI program (builds and executes via Xcode) or use the macOS app
3. The generated `<tbody>` HTML is copied to clipboard
4. Replace the existing `<tbody>` section in `index.html` (lines 86-3498) with the clipboard content

**Note**: As of June 2026, both the CLI and App dynamically fetch all frameworks from Apple's API, eliminating the need to manually update framework lists. The tools are now always up-to-date with new framework releases.

### Manual Framework Data Structure

If editing manually, each `<tr>` follows this structure:
- `<td><a href="APPLE_DOC_URL" title="DESCRIPTION" target="_blank">FRAMEWORK_NAME</a></td>` 
- Followed by `<td>VERSION</td>` for each platform: iOS, macOS, watchOS, tvOS, visionOS, macCatalyst, iPadOS
- Empty `<td></td>` if unavailable on a platform
- Beta frameworks get `<span class="tag is-info"> Beta</span>` tags
- Deprecated frameworks get `<span class="tag is-warning is-light"> Deprecated</span>` tags
- Version format: "X.Y" (e.g., "13.0", "10.15")

## Project Constraints

- No build step or bundler — dependencies are loaded directly from `node_modules/`
- `.nojekyll` file present to prevent GitHub Pages from processing the site with Jekyll
- `google43a1939e22e348ba.html` is a Google Search Console verification file (do not modify)
- The site must be viewable directly from the file system (all paths are relative or via `node_modules/`)
