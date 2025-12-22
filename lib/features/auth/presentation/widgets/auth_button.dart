import 'package:flutter/material.dart';
import 'package:tictac/core/widgets/buttons/game_button.dart';

class AuthButton extends StatelessWidget {

  const AuthButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GameButton(
      text: label,
      icon: icon,
      onPressed: onPressed,
      isOutlined: true,
    );
  }
}
