import 'package:flutter/material.dart';

class CustomRoundButton extends StatelessWidget {
  const CustomRoundButton({
    super.key,
    required this.iconSize,
    required this.padding,
    this.icon,
    this.onTap,
  });

  final IconData? icon;
  final double iconSize;
  final double padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffE8960C),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: EdgeInsets.all(padding),
        child: Icon(
          icon ?? Icons.send_rounded,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
