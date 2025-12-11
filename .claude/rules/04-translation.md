# Translation and Localization Guide

## Adding New Translations

When the user asks for adding new translations, follow these steps:

### Step 1: Update ARB Files

Update the internationalization files for **each language** in the `lib/l10n/` folder:

- `intl_en.arb` (English)
- `intl_es.arb` (Spanish)
- `intl_it.arb` (Italian)

Example:

```json
{
  "welcomeMessage": "Welcome to the app",
  "@welcomeMessage": {
    "description": "Welcome message shown on home screen"
  },
  "loginButton": "Login",
  "@loginButton": {
    "description": "Text for login button"
  }
}
```

### Step 2: Generate Translation Files

Run the Flutter localization generation command:

```bash
flutter gen-l10n
```

This generates the translation classes in `lib/generated/i18n/`.

### Step 3: Replace Hardcoded Strings

Replace hardcoded strings in your code with `AppLocalizations`:

```dart
// ❌ Before (hardcoded)
Text('Welcome to the app')

// ✅ After (localized)
Text(AppLocalizations.of(context)!.welcomeMessage)
```

## Complete Example

### 1. Add to ARB files

**intl_en.arb**:
```json
{
  "homeTitle": "Home",
  "settingsTitle": "Settings",
  "saveButton": "Save"
}
```

**intl_es.arb**:
```json
{
  "homeTitle": "Inicio",
  "settingsTitle": "Configuración",
  "saveButton": "Guardar"
}
```

**intl_it.arb**:
```json
{
  "homeTitle": "Home",
  "settingsTitle": "Impostazioni",
  "saveButton": "Salva"
}
```

### 2. Generate

```bash
flutter gen-l10n
```

### 3. Use in Code

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Text(l10n.homeTitle),
        Text(l10n.settingsTitle),
        ElevatedButton(
          onPressed: () {},
          child: Text(l10n.saveButton),
        ),
      ],
    );
  }
}
```

## Localization with Parameters

For strings with placeholders:

**intl_en.arb**:
```json
{
  "welcomeUser": "Welcome, {userName}!",
  "@welcomeUser": {
    "description": "Welcome message with user name",
    "placeholders": {
      "userName": {
        "type": "String"
      }
    }
  }
}
```

**Usage**:
```dart
Text(AppLocalizations.of(context)!.welcomeUser('John'))
```

## Supported Languages

The app currently supports:
- English (en)
- Spanish (es)
- Italian (it)

## Important Notes

1. **Always update all language files** - Don't leave any language behind
2. **Use descriptive keys** - `loginButton` is better than `btn1`
3. **Add descriptions** - Use the `@key` pattern to document string usage
4. **Run `flutter gen-l10n`** after every ARB file change
5. **Never commit hardcoded strings** - Always use localization

## Configuration Location

- ARB files: `lib/l10n/`
- Generated files: `lib/generated/i18n/`
- Configuration: `l10n.yaml` at project root
