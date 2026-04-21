import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/copyright_footer.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const _darkNavy = Color(0xff1B2E4B);
  static const _orangeAccent = Color(0xffE8960C);
  static const _hintGray = Color(0xffBBBBBB);
  static const _fieldBg = Color(0xffF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: _darkNavy, size: 20),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xffFFF3E0),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.lock_reset,
                          size: 40,
                          color: _orangeAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Heading
                    Center(
                      child: Text(
                        'Reset Password',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: _darkNavy,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Center(
                      child: Text(
                        'Enter your email address and we\'ll send you a link to reset your password.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Color(0xff666666),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: _hintGray, fontSize: 16),
                        fillColor: _fieldBg,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: _orangeAccent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: _orangeAccent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: _orangeAccent, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.mail_outline, color: _hintGray, size: 22),
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 28),

                    // Reset button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _darkNavy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 54),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _sendPasswordResetEmail();
                        }
                      },
                      child: Text(
                        'Send Reset Link',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Back to login
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Back to Sign In',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color(0xff3B7DD8),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const CopyrightFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendPasswordResetEmail() async {
    final String email = _emailController.text.trim();
    if (email.isEmpty) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent!'),
          backgroundColor: _orangeAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().split(']').last),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
