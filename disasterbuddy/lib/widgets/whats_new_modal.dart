import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/release_notes.dart';

class WhatsNewModal extends StatelessWidget {
  final ReleaseNote release;
  final VoidCallback onClose;

  const WhatsNewModal({
    super.key,
    required this.release,
    required this.onClose,
  });

  static const _navy = Color(0xff1B2E4B);
  static const _orange = Color(0xffE8960C);
  static const _bodyGray = Color(0xff374151);
  static const _subtleGray = Color(0xff6b7280);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/newimage.jpeg',
                    height: 36,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _orange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'v${release.version}',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                release.title,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: _navy,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Here's what's new in this release",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: _subtleGray,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final highlight in release.highlights)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _highlightRow(highlight),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Got it',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _highlightRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(top: 1),
          decoration: const BoxDecoration(
            color: _orange,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 13, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: _bodyGray,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
