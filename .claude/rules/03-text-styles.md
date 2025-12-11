# Text Styles Guide

## Rule of Thumb

**Always centralize your text styles** — define them in your app's `ThemeData.textTheme` (and any brand-specific extras in a single `AppTextStyles` file) and then reuse via `Theme.of(context).textTheme` (or your `AppTextStyles`), only using `copyWith()` for one-off tweaks.

## Best Practices

### ✅ DO: Use Centralized Text Styles

```dart
// Preferred - Use theme text styles
Text(
  'Hello World',
  style: Theme.of(context).textTheme.bodyLarge,
)

// Or use centralized AppTextStyles
Text(
  'Hello World',
  style: AppTextStyles.bodyLarge,
)
```

### ✅ DO: Use copyWith() for One-Off Tweaks

```dart
// For one-off modifications
Text(
  'Hello World',
  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    color: Colors.red,
    fontWeight: FontWeight.bold,
  ),
)
```

### ❌ DON'T: Create Inline Styles

```dart
// ❌ NEVER create inline text styles
Text(
  'Hello World',
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
)
```

## Theme Location

- **Colors**: `lib/app_core/theme/colors.dart`
- **Text Styles**: `lib/app_core/theme/text_styles/app_text_styles.dart`
- **Theme Definition**: `lib/app_core/theme/theme.dart`

## Accessing Theme Colors

```dart
// Use theme colors
Theme.of(context).colorScheme.primary
YRColors.primaryColor
```

## DSA Font Support

The app supports dyslexia-friendly fonts with EasyReadingPRO font family. This is handled automatically through the centralized theme system.

## Example: Complete Text Style Usage

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Standard heading
        Text(
          'Heading',
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        // Body text
        Text(
          'Body text',
          style: Theme.of(context).textTheme.bodyLarge,
        ),

        // Custom color for specific case
        Text(
          'Error message',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}
```

## Key Takeaway

**Centralize → Reuse → copyWith() only when needed**

This ensures:
- Consistent design across the app
- Easy theme updates
- Better maintainability
- Support for theme switching (light/dark mode)
- Support for DSA fonts