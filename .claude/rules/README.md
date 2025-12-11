# Claude Rules Directory

This directory contains modular Claude Code rules organized by topic. Each file focuses on a specific aspect of development for the WHO Mobile Flutter project.

## Rules Overview

### [01-adding-new-api.md](01-adding-new-api.md)
Step-by-step guide for adding new API endpoints with Riverpod 3.0+ patterns.
- Model definition
- API endpoint creation
- Repository setup
- Provider implementation
- UI integration
- Code generation

### [02-riverpod-guide.md](02-riverpod-guide.md)
**CRITICAL** - Complete Riverpod 3.0+ state management guide.
- Zero-tolerance rules
- Pattern selection (BaseApiNotifier, AsyncNotifier, Functional)
- Implementation examples
- Code review checklist
- Testing patterns

### [03-text-styles.md](03-text-styles.md)
Text styling and theming guidelines.
- Centralized text styles
- Theme usage
- DSA font support
- Best practices

### [04-translation.md](04-translation.md)
Localization and internationalization guide.
- Adding new translations
- ARB file structure
- Supported languages (en, es, it)
- Usage patterns

### [05-general-implementation.md](05-general-implementation.md)
General implementation rules and project context.
- Native app consistency (iOS/Android)
- API versioning (V2)
- Model consistency
- TODO TEMP handling
- Project naming conventions

## Quick Reference

### Most Important Rules

1. **Riverpod State Management** → [02-riverpod-guide.md](02-riverpod-guide.md)
   - `ref.watch()` in build for reactive state
   - `ref.read()` for actions only
   - Never initialize state in constructor

2. **Adding API Endpoints** → [01-adding-new-api.md](01-adding-new-api.md)
   - Model → API → Repository → Provider → UI → Codegen

3. **Text Styles** → [03-text-styles.md](03-text-styles.md)
   - Always use `Theme.of(context).textTheme`
   - Never inline `TextStyle()`

4. **Translations** → [04-translation.md](04-translation.md)
   - Update all ARB files (en, es, it)
   - Run `flutter gen-l10n`
   - Use `AppLocalizations.of(context)!`

5. **General Rules** → [05-general-implementation.md](05-general-implementation.md)
   - iOS implementation as primary reference
   - Use V2 APIs only
   - Ask before making architectural decisions

## How to Use

Claude Code automatically reads the main `CLAUDE.md` file which references these rules. Each rule file can be updated independently for easier maintenance.

## File Naming Convention

Files are numbered to indicate their reading order:
- `01-` - Core workflows (API integration)
- `02-` - Critical patterns (Riverpod)
- `03-05` - Specific guidelines (styling, translation, general)

## Updating Rules

When updating rules:
1. Edit the specific rule file
2. Keep examples clear and concise
3. Update this README if adding new files
4. Ensure consistency across related rules
