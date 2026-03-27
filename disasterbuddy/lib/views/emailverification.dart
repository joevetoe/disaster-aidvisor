// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/local_storage.dart';
import 'chatting_screen.dart';
import 'signup.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});
  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  Timer? timer;

  static const _darkNavy = Color(0xff1B2E4B);
  static const _orangeAccent = Color(0xffE8960C);

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      await LocalDb.setuserid(id: docid);
      FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('users').doc(docid).update({
        'emailverified': true,
      });

      Get.offAll(() => const ChattingScreen());
      print("Successfully");
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Email icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF3E0),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.mail_outline,
                      size: 40,
                      color: _orangeAccent,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Heading
                  Text(
                    'Check Your Email',
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        color: _darkNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'We have sent a verification email to',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        color: Color(0xff666666),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    auth.currentUser?.email ?? '',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        color: _darkNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Loading spinner
                  const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      color: _orangeAccent,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Verifying email...',
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        color: Color(0xff999999),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Spam notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xffF8F9FA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xffEEEEEE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xff999999), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Please check your spam folder in case you cannot find the verification email.',
                            style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                color: Color(0xff666666),
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Resend button
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _orangeAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      try {
                        FirebaseAuth.instance.currentUser
                            ?.sendEmailVerification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Verification email sent!'),
                            backgroundColor: _orangeAccent,
                          ),
                        );
                      } catch (e) {
                        debugPrint('$e');
                      }
                    },
                    child: Text(
                      'Resend Email',
                      style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                          color: _orangeAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
