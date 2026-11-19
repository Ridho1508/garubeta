import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'chunky_button.dart';

/// Tombol kotak berisi satu ikon (home, suara, gembok, dll).
class SquareButton extends StatelessWidget {
  const SquareButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: ChunkyButton(
        color: color,
        minHeight: 64,
        radius: 24,
        shelfHeight: 4,
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: Icon(icon, size: 32, color: AppColors.mocha),
      ),
    );
  }
}
