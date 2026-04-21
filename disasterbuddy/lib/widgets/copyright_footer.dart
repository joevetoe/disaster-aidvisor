import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CopyrightFooter extends StatelessWidget {
  const CopyrightFooter({super.key, this.padding});

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Copyright © 2026 BuildSOS.com',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            color: Color(0xff888888),
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
