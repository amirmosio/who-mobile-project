# General Implementation Rules

## Project Context

This is a Flutter application rewrite of a WHO (World Health Organization) mobile app, originally developed for both **Android** and **iOS**. The Flutter version should maintain consistency with both native implementations while using modern Flutter patterns.

## Key Principles

### 1. Consistency with Native Apps

The logic should be similar to both Android and iOS projects where possible:

- **iOS native code** is usually used as the primary reference
- **API Version**: Use V2 APIs (not V1)
- **Data Models**: Must be consistent with Android and iOS native versions
- **Constants**: Use the same constants across platforms

### 2. Integration of Different Approaches

When there are differences between iOS and Android native implementations:

1. **Analyze both approaches** - Understand the flow in both platforms
2. **Ask the user** - Come up with an integrated solution that is more convenient
3. **Wait for approval** - Make sure to get user confirmation before proceeding with the approach

### 3. TODO TEMP Comments

**IMPORTANT**: Do not remove `// TODO TEMP` comments in the codebase.

- These are for temporary changes that we don't want to commit
- They should be kept and will be removed later before final commits
- **Do not edit or update them**

## Implementation Guidelines

### API Integration

```dart
// ✅ Use V2 APIs
@GET('/api/v2/features')
Future<DataBasedResponse<FeatureModel, BaseMetaData>> getFeatures();

// ❌ Don't use V1 APIs
@GET('/api/v1/features')  // WRONG
```

### Model Consistency

When creating models, ensure they match the structure from native apps:

```dart
// Check Android/iOS model structure first
class UserModel {
  final int id;
  final String name;
  final String email;
  // Fields should match native implementations

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
  );
}
```

### Constants

Use existing constants and maintain consistency:

```dart
// Use existing constant definitions from lib/general/constants/
import 'package:who_mobile/general/constants/api_error_types.dart';
import 'package:who_mobile/general/constants/user_roles.dart';
```

## Migration Strategy

When migrating features from native apps:

1. **Review native implementation** (iOS first, then Android)
2. **Identify differences** between platforms
3. **Design unified Flutter approach** that satisfies both
4. **Consult user** if significant differences exist
5. **Implement with modern Flutter patterns** (Riverpod, GoRouter, etc.)
6. **Test against both native behaviors**

## Code Quality Standards

### DO
- ✅ Reference iOS implementation as primary guide
- ✅ Check Android implementation for differences
- ✅ Ask user before making architectural decisions
- ✅ Maintain API V2 compatibility
- ✅ Keep model structure consistent with native
- ✅ Preserve `// TODO TEMP` comments

### DON'T
- ❌ Remove or edit `// TODO TEMP` comments
- ❌ Use V1 APIs
- ❌ Create models without checking native structure
- ❌ Make breaking changes without user approval
- ❌ Ignore differences between iOS and Android implementations

## Example: Handling Platform Differences

```dart
// iOS uses approach A, Android uses approach B
// Proposed Flutter approach: C (combines best of both)

// Before implementing:
// 1. Document both approaches
// 2. Propose unified solution
// 3. Ask user for approval
// 4. Implement approved approach
```

## Reference Projects

- **iOS Native**: Primary reference for logic and flow
- **Android Native**: Secondary reference, check for differences
- **API**: V2 endpoints only
- **Models**: Must match native implementations

## Project Naming

- **NO mentions** of guidaevai, quizpatente, or quiz in any new code
- Use WHO-specific naming conventions
