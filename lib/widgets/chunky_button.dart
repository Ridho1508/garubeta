import 'package:flutter/material.dart';

import '../core/app_colors.dart';

/// Tombol/kartu datar dengan garis tebal dan "tepi bawah" solid.
/// Saat ditekan, badannya turun dan tepi bawahnya mengecil.
class ChunkyButton extends StatefulWidget {
  const ChunkyButton({
    super.key,
    required this.child,
    required this.onTap,
    this.color = AppColors.gold,
    this.borderColor = AppColors.mocha,
    this.borderWidth = 3,
    this.shelfHeight = 5,
    this.radius = 28,
    this.minHeight = 72,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  });

  final Widget child;
  final VoidCallback onTap;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double shelfHeight;
  final double radius;
  final double minHeight;
  final EdgeInsetsGeometry padding;

  @override
  State<ChunkyButton> createState() => _ChunkyButtonState();
}

class _ChunkyButtonState extends State<ChunkyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final shelf = _pressed ? 1.0 : widget.shelfHeight;
    final drop = widget.shelfHeight - shelf;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        margin: EdgeInsets.only(top: drop, bottom: shelf),
        constraints: BoxConstraints(minHeight: widget.minHeight),
        padding: widget.padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.borderColor,
              offset: Offset(0, shelf),
              blurRadius: 0,
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
