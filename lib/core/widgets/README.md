# Core Widgets

This directory contains all reusable widgets for the application, organized by category in subdirectories.

## Structure

### 📢 `snackbars/`
Widgets for displaying toast notifications:
- `error_snackbar.dart` - Error snackbar
- `success_snackbar.dart` - Success snackbar
- `warning_snackbar.dart` - Warning snackbar
- `app_snackbar_content.dart` - Common content for snackbars

### 🔤 `formatters/`
Text formatting utilities:
- `game_id_formatter.dart` - Game ID formatting
- `username_formatter.dart` - Username formatting

### 📝 `inputs/`
Custom input fields:
- `username_text_field.dart` - Text field for usernames

### 🔘 `buttons/`
Reusable buttons:
- `game_button.dart` - Main application button
- `tab_button_widget.dart` - Tab button

### 👤 `avatars/`
Widgets for avatar selection and display:
- `avatar_selector.dart` - Main avatar selector
- `avatar_option_widget.dart` - Individual avatar option

### 🔷 `shapes/`
Widgets for game shapes and symbols:
- `shape_selector.dart` - Shape selector (X/O)
- `shape_section_widget.dart` - Shape selection section
- `shape_option_widget.dart` - Individual shape option
- `shape_preview_widget.dart` - Shape preview
- `game_shape_widget.dart` - Game shape widget
- `symbol_painters.dart` - Painters for drawing symbols

### 😀 `emojis/`
Widgets for emoji selection:
- `emoji_selector.dart` - Main emoji selector
- `emoji_section_widget.dart` - Emoji selection section
- `emoji_categories.dart` - Available emoji categories

### 🎨 `ui/`
Generic UI components:
- `switch_tile_widget.dart` - Tile with switch
- `section_header.dart` - Section header
- `scrollable_section.dart` - Scrollable section
- `modal_bottom_sheet.dart` - Modal bottom sheet

### ✨ `effects/`
Visual effects and backgrounds:
- `cosmic_background.dart` - Animated cosmic background
- `confetti_widget.dart` - Confetti widget

### 🏷️ `branding/`
Brand elements and logo:
- `app_logo.dart` - Application logo
- `clickable_logo.dart` - Clickable logo

### 🤖 `ai/`
AI-related widgets:
- `ai_character.dart` - AI character features and information

## Usage

To use a widget, import it from its subdirectory:

```dart
import 'package:tictac/core/widgets/buttons/game_button.dart';
import 'package:tictac/core/widgets/snackbars/success_snackbar.dart';
import 'package:tictac/core/widgets/shapes/shape_selector.dart';
```

## Organization

This organization allows to:
- ✅ Quickly find widgets by category
- ✅ Maintain a clear and scalable structure
- ✅ Avoid root directory pollution
- ✅ Facilitate IDE navigation
