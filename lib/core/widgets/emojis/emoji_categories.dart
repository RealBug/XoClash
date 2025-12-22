import 'package:flutter/material.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/l10n/app_localizations.dart';

class EmojiCategory {

  const EmojiCategory({
    required this.name,
    required this.icon,
    required this.emojis,
  });
  final String name;
  final String icon;
  final List<String> emojis;
}

class EmojiCategories {
  EmojiCategories._();

  static List<EmojiCategory> all(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    return <EmojiCategory>[
      EmojiCategory(
        name: l10n.emojiCategoryAnimals,
        icon: '🐾',
        emojis: <String>['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵'],
      ),
      EmojiCategory(
        name: l10n.emojiCategoryFood,
        icon: '🍕',
        emojis: <String>['🍎', '🍌', '🍇', '🍓', '🍑', '🍒', '🍊', '🍋', '🍉', '🍐', '🍍', '🥝', '🍅', '🥑', '🥕'],
      ),
      EmojiCategory(
        name: l10n.emojiCategoryObjects,
        icon: '📦',
        emojis: <String>['💎', '🔮', '🎯', '🎲', '🎪', '🎨', '🎭', '🎬', '🎤', '🎧', '🎹', '🎸', '🎺', '🎻', '🥁'],
      ),
      EmojiCategory(
        name: l10n.emojiCategoryNature,
        icon: '🌿',
        emojis: <String>['🌞', '🌙', '⭐', '🌟', '☀️', '🌤️', '⛅', '🌦️', '🌧️', '⛈️', '🌩️', '❄️', '☃️', '⛄', '🌊'],
      ),
      EmojiCategory(
        name: l10n.emojiCategoryFaces,
        icon: '😊',
        emojis: <String>['😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂', '🙃', '😉', '😊', '😇', '🥰', '😍'],
      ),
      EmojiCategory(
        name: l10n.emojiCategorySports,
        icon: '⚽',
        emojis: <String>['⚽', '🏀', '🏈', '⚾', '🎾', '🏐', '🏉', '🎱', '🏓', '🏸', '🥅', '🏒', '🏑', '🏏', '⛳'],
      ),
    ];
  }
}
