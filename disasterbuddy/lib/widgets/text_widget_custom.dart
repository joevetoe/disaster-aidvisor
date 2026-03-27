import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextWidgetCustom extends StatelessWidget {
  const MyTextWidgetCustom(
      {required this.text,
      this.color,
      this.size,
      this.fontWeight,
      this.maxLines,
      this.textAlign,
      this.overflow,
      super.key});

  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AutoSizeText(
        text,
        style: GoogleFonts.poppins().copyWith(
          color: color ?? Colors.black,
          fontSize: size ?? 18,
          fontWeight: fontWeight,
          overflow: overflow,
        ),
        //    TextStyle(
        //   color: color ?? Colors.black,
        //   fontSize: size ?? 18,
        //   fontWeight: fontWeight,
        //   overflow: overflow,
        // ),
        maxLines: maxLines,
        textAlign: textAlign,
      ),
    );
  }
}
