import 'package:flutter/material.dart';

class TextWidgetCustom extends StatelessWidget {
  const TextWidgetCustom(
      {required this.text,
      this.color,
      this.size,
      this.fontWeight,
      this.maxLines,
      this.textAlign,
      this.overflow,
      this.fontStyle,
      this.fontFamily,
      this.lineHeight,
      this.letterSpacing,
      this.alignment,
      this.margin,
      this.padding,
      this.backgroundColor,
      this.height,
      this.width,
      this.radius,
      super.key});

  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final double? lineHeight;
  final double? letterSpacing;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: alignment,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          radius ?? 0,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color ?? Colors.black,
          fontSize: size ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          overflow: overflow,
          fontFamily: fontFamily,
          fontStyle: fontStyle,
          height: lineHeight,
          letterSpacing: letterSpacing ?? 0.5,
        ),
        maxLines: maxLines,
        textAlign: textAlign,
      ),
    );
  }
}
