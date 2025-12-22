import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/shapes/game_shape_widget.dart';
import 'package:tictac/features/game/presentation/widgets/player_score_badge.dart';
import 'package:tictac/features/score/presentation/providers/session_scores_provider.dart';

class PlayerIndicator extends StatefulWidget {

  const PlayerIndicator({
    super.key,
    required this.context,
    required this.label,
    required this.isActive,
    required this.color,
    this.animationsEnabled = true,
    this.emoji,
    this.symbol,
    this.gameEmoji,
    this.gameShape,
    this.isWinner = false,
    this.isLoser = false,
    this.isDarkMode = true,
    this.isComputer = false,
    this.sessionScore,
  });
  final BuildContext context;
  final String label;
  final bool isActive;
  final Color color;
  final bool animationsEnabled;
  final String? emoji;
  final String? symbol;
  final String? gameEmoji;
  final String? gameShape;
  final bool isWinner;
  final bool isLoser;
  final bool isDarkMode;
  final bool isComputer;
  final SessionScore? sessionScore;

  @override
  State<PlayerIndicator> createState() => _PlayerIndicatorState();
}

class _PlayerIndicatorState extends State<PlayerIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _haloController;

  @override
  void initState() {
    super.initState();
    _haloController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.isActive && widget.animationsEnabled && !widget.isWinner && !widget.isLoser) {
      _haloController.repeat(reverse: true);
    } else {
      _haloController.value = 0.5;
    }
  }

  @override
  void didUpdateWidget(PlayerIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive && widget.animationsEnabled && !widget.isWinner && !widget.isLoser) {
        _haloController.repeat(reverse: true);
      } else {
        _haloController.stop();
        _haloController.value = 0.5;
      }
    }
  }

  @override
  void dispose() {
    _haloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _haloController,
        builder: (BuildContext context, Widget? child) {
          final double animationValue = _haloController.value;
          final double haloOpacity = widget.isActive && widget.animationsEnabled && !widget.isWinner && !widget.isLoser
              ? 0.1 + (math.sin(animationValue * 2 * math.pi) * 0.5 + 0.5) * 0.15
              : 0.1;

          return Card(
            elevation: widget.isActive ? (widget.isDarkMode ? 0.5 : 1) : 0,
            shadowColor: widget.isActive
                ? (widget.isDarkMode ? widget.color.withValues(alpha: 0.15) : widget.color.withValues(alpha: 0.15))
                : AppTheme.transparent,
            color: widget.isActive
                ? (widget.isDarkMode ? widget.color.withValues(alpha: 0.2) : widget.color.withValues(alpha: 0.1))
                : (widget.isDarkMode ? const Color(0xFF4A3A7B) : AppTheme.lightCardColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: widget.isActive
                    ? widget.color.withValues(alpha: 0.6 + haloOpacity * 0.15)
                    : (widget.isDarkMode
                        ? AppTheme.darkTextPrimary.withValues(alpha: 0.05)
                        : AppTheme.lightTextSecondary.withValues(alpha: 0.5)),
                width: widget.isActive ? 2 : 0.5,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: widget.isActive && widget.animationsEnabled && !widget.isWinner && !widget.isLoser
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: widget.isDarkMode
                          ? <BoxShadow>[
                              BoxShadow(
                                color: widget.color.withValues(alpha: haloOpacity * 0.2),
                                blurRadius: 12,
                              ),
                              BoxShadow(
                                color: widget.color.withValues(alpha: haloOpacity * 0.1),
                                blurRadius: 20,
                                spreadRadius: 1,
                              ),
                            ]
                          : <BoxShadow>[
                              BoxShadow(
                                color: widget.color.withValues(alpha: haloOpacity * 0.25),
                                blurRadius: 12,
                              ),
                              BoxShadow(
                                color: widget.color.withValues(alpha: haloOpacity * 0.15),
                                blurRadius: 20,
                                spreadRadius: 1,
                              ),
                            ],
                    )
                  : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isActive
                              ? (widget.isDarkMode ? widget.color.withValues(alpha: 0.2) : widget.color.withValues(alpha: 0.15))
                              : (widget.isDarkMode ? const Color(0xFF3A2A6B) : AppTheme.lightBackgroundColor),
                          border: Border.all(
                            color: widget.isActive
                                ? widget.color
                                : (widget.isDarkMode
                                    ? AppTheme.darkTextPrimary.withValues(alpha: 0.2)
                                    : AppTheme.lightTextSecondary.withValues(alpha: 0.5)),
                            width: widget.isActive ? 2.5 : 1.5,
                          ),
                          boxShadow: widget.isActive
                              ? <BoxShadow>[
                                  BoxShadow(
                                    color: widget.color.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: widget.color.withValues(alpha: 0.2),
                                    blurRadius: 6,
                                  ),
                                ]
                              : <BoxShadow>[],
                        ),
                        child: Center(
                          child: widget.emoji != null
                              ? Text(
                                  widget.emoji!,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(height: 1.0),
                                  textAlign: TextAlign.center,
                                )
                              : ClipRect(
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: widget.symbol != null
                                          ? Text(
                                              widget.symbol!,
                                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: widget.isActive ? widget.color : widget.color.withValues(alpha: 0.5),
                                                  ),
                                            )
                                          : Text(
                                              widget.label.length > 1 ? widget.label.substring(0, 1).toUpperCase() : widget.label,
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: widget.isActive ? widget.color : widget.color.withValues(alpha: 0.5),
                                                  ),
                                            ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Gap(AppSpacing.xs * 1.25),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    widget.label,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: widget.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Gap(AppSpacing.xs * 0.75),
                                PlayerScoreBadge(
                                  sessionScore: widget.sessionScore,
                                  color: widget.color,
                                  isDarkMode: widget.isDarkMode,
                                ),
                              ],
                            ),
                            Gap(AppSpacing.xxs * 0.75),
                            Row(
                              children: <Widget>[
                                if (widget.gameEmoji != null && widget.gameEmoji!.isNotEmpty) ...<Widget>[
                                  Text(
                                    widget.gameEmoji!,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.0),
                                  ),
                                  Gap(AppSpacing.xxs),
                                ] else if (widget.gameShape != null && widget.symbol != null) ...<Widget>[
                                  GameShapeWidget(
                                    symbol: widget.symbol!,
                                    shape: widget.gameShape!,
                                    color: widget.color,
                                  ),
                                  Gap(AppSpacing.xxs),
                                ],
                                Flexible(
                                  child: Text(
                                    widget.isWinner
                                        ? widget.context.l10n.winner
                                        : widget.isLoser
                                            ? widget.context.l10n.loser
                                            : widget.isActive
                                                ? (widget.isComputer ? 'His Turn' : widget.context.l10n.yourTurn)
                                                : '',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          height: 1.0,
                                          color: widget.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

