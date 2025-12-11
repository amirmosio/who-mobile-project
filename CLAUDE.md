# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Modular Rules

Detailed rules are organized in [.claude/rules/](.claude/rules/) directory:

- **[01-adding-new-api.md](.claude/rules/01-adding-new-api.md)** - API endpoint integration workflow
- **[02-riverpod-guide.md](.claude/rules/02-riverpod-guide.md)** - Complete Riverpod 3.0+ guide (CRITICAL)
- **[03-text-styles.md](.claude/rules/03-text-styles.md)** - Text styling and theming
- **[04-translation.md](.claude/rules/04-translation.md)** - Localization and i18n
- **[05-general-implementation.md](.claude/rules/05-general-implementation.md)** - General implementation rules

## Project Overview

This is a Flutter mobile application for WHO (World Health Organization) with modern architecture patterns. The app uses V2 APIs and follows best practices for state management, dependency injection, and navigation.

## Project Structure

```
lib/
├── app_core/              # Core application setup
│   ├── authenticator/     # JWT token management
│   ├── config/            # Environment constants
│   ├── theme/             # App-wide theming (colors, text styles, theme)
│   └── services/          # Core services (social auth, notifications)
│
├── general/               # Shared utilities and models
│   ├── constants/         # App constants (error types, user roles, etc.)
│   ├── database/          # Drift SQLite database with encryption
│   ├── extensions/        # Dart extensions
│   ├── models/            # Data models with JSON serialization
│   ├── services/          # Shared services (audio, device, permissions, etc.)
│   └── widgets/           # Reusable UI components
│
├── di/                    # Dependency Injection with GetIt + Injectable
│   ├── injector.dart      # DI configuration
│   └── *_module.dart      # Module-specific DI
│
├── network/               # API layer
│   └── rest_client.dart   # Retrofit REST client with all endpoints
│
├── providers/             # Riverpod state management
│   ├── base/              # BaseApiNotifier and BaseApiState
│   └── [feature]/         # Feature-specific providers
│
├── repository/            # Data layer
│   ├── base/              # BaseRepository with error handling
│   └── [feature]/         # Feature repositories
│
├── routing_config/        # GoRouter navigation
│   ├── routes.dart        # Route constants
│   └── base_navigator_route_builder.dart  # Router configuration
│
├── services/              # App-level services
│   └── navigation_tracker.dart
│
├── ui/                    # UI layer organized by feature
│   ├── auth_pages/        # Login, Register, Reset Password
│   ├── dashboard/         # Dashboard home
│   ├── profile_and_settings/  # Profile and settings
│   ├── notifications/     # Notifications
│   ├── blog/              # Blog feature
│   └── base_template/     # Navigation shell and base layouts
│
├── application.dart       # App configuration
└── main.dart              # Entry point
```

## Essential Commands

### Development Workflow
```bash
# Install dependencies
flutter pub get

# Code generation (run after ANY changes to providers, models, or API endpoints)
dart run build_runner build --delete-conflicting-outputs

# Generate translations (after updating l10n files)
flutter gen-l10n

# Run the app
flutter run

# Format code
dart format .

# Analyze code
flutter analyze
dart analyze

# Pre-commit setup (required for all developers)
brew install pre-commit
pre-commit install
pre-commit run --all-files  # Run manually
```

### Pre-commit Checks
The project uses pre-commit hooks that enforce:
- Dart/Flutter formatting (`dart format`)
- Code analysis (`flutter analyze`, `dart analyze`)
- No `TODO TEMP` comments in commits
- JSON/YAML validation
- Trailing whitespace removal

## Architecture Quick Reference

### State Management: Riverpod 3.0+
**See [02-riverpod-guide.md](.claude/rules/02-riverpod-guide.md) for complete guide**

Pattern selection:
- **BaseApiNotifier (85%)** - Simple API calls, CRUD operations
- **AsyncNotifier (10%)** - Lists with optimistic updates
- **Functional (5%)** - Computed values, DI

Critical rules:
- ✅ Initialize state in `build()` method only
- ✅ Use `ref.watch()` in build for reactive state
- ✅ Use `ref.read()` for actions only
- ❌ Never use `ref.read()` in `initState()` or `build()` for state

### Adding New API Endpoints
**See [01-adding-new-api.md](.claude/rules/01-adding-new-api.md) for complete workflow**

1. Define Model → 2. Add API Endpoint → 3. Create Repository → 4. Create Provider → 5. UI Integration → 6. Run Codegen

### Dependency Injection: GetIt + Injectable

```dart
// Registration
@injectable
class MyRepository extends BaseRepository {
  MyRepository(super.apiClient);
}

// Access in providers
@riverpod
MyRepository myRepository(Ref ref) => getIt<MyRepository>();

// Access in code
final service = getIt<MyService>();
```

### Routing: GoRouter

```dart
// Navigate
context.push(YRRoutes.profile);
context.go(YRRoutes.dashboard);

// With parameters
context.push(YRRoutes.detailPage.replaceFirst(':id', '123'));
```

### Repository Pattern

```dart
@injectable
class FeatureRepository extends BaseRepository {
  FeatureRepository(super.apiClient);

  Future<RepositoryState> getData() async {
    return getRepositoryState(() => apiClient.getData());
  }
}
```

## Data Layer

### Network Layer
- REST Client: `lib/network/rest_client.dart` with Retrofit
- Dio for HTTP with auth, logging, error interceptors

### Database: Drift (SQLite with Encryption)
- Location: `lib/general/database/app_database.dart`
- Tables: `lib/general/database/tables/`
- Uses SQLCipher for encryption

## UI Guidelines

### Theme & Styling
**See [03-text-styles.md](.claude/rules/03-text-styles.md)**

Always use centralized text styles:
```dart
Text('Hello', style: Theme.of(context).textTheme.bodyLarge)
```

### Localization (i18n)
**See [04-translation.md](.claude/rules/04-translation.md)**

Process:
1. Update ARB files (en, es, it)
2. Run `flutter gen-l10n`
3. Use `AppLocalizations.of(context)!.stringId`

## Git Workflow

### Branch Naming (STRICT)
```bash
# Template: PROJECT-TASKID_feature-name_DDMMYYYY_author
git flow feature start WHO-123_add-user-profile_11122025_john
```

### Commit Messages
```
feat(feature_name): description       # New features
hotfix(feature_name): description     # Bug fixes
chore(feature_name): description      # Maintenance
doc(feature_name): description        # Documentation
refactor(feature_name): description   # Code refactoring
```

## Environment Configuration

```dart
// In main.dart
Constants.setEnvironment(Environment.staging);  // staging, prod, local
```

Configuration:
- `.env` file (NEVER commit)
- Firebase: REMOVED (not used)
- Sentry: Error tracking (production only)

## Code Quality Rules

### Avoid Over-Engineering
- Make ONLY requested changes
- Don't add features beyond requirements
- Don't refactor surrounding code unnecessarily
- Three similar lines > premature abstraction

### Security
- No XSS, SQL injection, command injection
- Validate at system boundaries only

### Backwards Compatibility
- Delete unused code completely
- No compatibility hacks

## Important Implementation Notes

1. **Native App Consistency**: iOS as primary reference, integrate Android differences
2. **Model Consistency**: Match Android and iOS native versions
3. **API Versioning**: Use V2 APIs only
4. **Provider Pattern**: 85% BaseApiNotifier, 10% AsyncNotifier, 5% custom
5. **Testing**: Override providers with `ProviderScope.overrides`
6. **NO mentions** of guidaevai, quizpatente, or quiz in new code

## Common Pitfalls

1. Forgetting code generation after provider/model/API changes
2. Using `ref.read()` in `build()` for state consumption
3. Reading provider state in `initState()`
4. Not using exhaustive switch for state handling
5. Creating providers without `@riverpod` annotation
6. Committing `.env` file or secrets
7. Not following branch naming convention
8. Forgetting to update all language files (en, es, it)
9. Using hardcoded strings instead of localization
10. Not preserving `// TODO TEMP` comments

## Key Services

- **StorageManager**: Secure storage for tokens/credentials
- **PermissionService**: Runtime permissions
- **Authenticator**: JWT token management

**For detailed rules, see [.claude/rules/](.claude/rules/) directory.**
