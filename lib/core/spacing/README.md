# AppSpacing

Consistent spacing system for the application using constants defined in `UIConstants` and the `Gap` widget.

## Usage

### Gap Widget (replaces SizedBox)

Instead of using `SizedBox(height: 24)` or `SizedBox(width: 8)`, use `Gap`:

```dart
import 'package:gap/gap.dart';
import 'package:tictac/core/spacing/app_spacing.dart';

// Vertical spacing
Gap(AppSpacing.md)  // 16px
Gap(AppSpacing.xl)  // 24px

// Horizontal spacing
Row(
  children: [
    Icon(Icons.settings),
    Gap(AppSpacing.sm),  // 12px
    Text('Settings'),
  ],
)
```

### Padding with AppSpacing

```dart
import 'package:tictac/core/spacing/app_spacing.dart';

// Uniform padding
Padding(
  padding: AppSpacing.paddingAll(AppSpacing.xl),
  child: Widget(),
)

// Symmetric padding
Padding(
  padding: AppSpacing.paddingSymmetric(
    horizontal: AppSpacing.xl,
    vertical: AppSpacing.md,
  ),
  child: Widget(),
)

// Custom padding
Padding(
  padding: AppSpacing.paddingOnly(
    top: AppSpacing.xxl,
    left: AppSpacing.xl,
    right: AppSpacing.xl,
    bottom: 120,
  ),
  child: Widget(),
)
```

## Available Values

- `AppSpacing.xxs` = 4px
- `AppSpacing.xs` = 8px
- `AppSpacing.sm` = 12px
- `AppSpacing.md` = 16px
- `AppSpacing.lg` = 20px
- `AppSpacing.xl` = 24px
- `AppSpacing.xxl` = 32px
- `AppSpacing.xxxl` = 40px

These values correspond to constants defined in `UIConstants` to maintain consistency throughout the application.

