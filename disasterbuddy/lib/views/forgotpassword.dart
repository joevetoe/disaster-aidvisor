// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../constants/images.dart';
import '../widgets/text_widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  static final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.blackColor,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon:
                Icon(Icons.arrow_back_ios_rounded, color: MyColors.whiteColor)),
        title: Text(
          "Reset Passowrd",
          style: TextStyle(color: MyColors.whiteColor),
        ),
      ),
      backgroundColor: MyColors.blackColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  color: MyColors.whiteColor,
                  child: Center(
                    child: Image.asset(
                      "assets/images/newimage.jpeg",
                      height: Get.height * 0.3,
                    ),
                  ),
                ),
                // Container(
                //   color: MyColors.whiteColor,
                //   child: Center(
                //     child: Image.asset(
                //       "assets/images/splash.png",
                //       height: Get.height * 0.2,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 10),
                Text(
                  'Reset Password',
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _emailAddress(),
                const SizedBox(height: 40),
                _resetPasswordButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: (val) {
            if (val!.isEmpty) {
              return "Please Enter Email";
            }
            return null;
          },
          controller: _emailController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: '',
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _resetPasswordButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange, // Match the Sign In button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 50),
        elevation: 0,
      ),
      onPressed: () async {
        if (_formkey.currentState!.validate()) {
          try {
            _sendPasswordResetEmail();
          } catch (e) {
            // log("$e");
            Get.showSnackbar(GetSnackBar(
                backgroundColor: MyColors.redColor,
                duration: const Duration(seconds: 2),
                messageText: TextWidgetCustom(
                    color: MyColors.whiteColor,
                    text: e.toString().split(']').last)));
          }
        }
      },
      child: const Text(
        "Reset Password",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _sendPasswordResetEmail() async {
    final String email = _emailController.text.trim();
    if (email.isEmpty) {
      Get.showSnackbar(GetSnackBar(
          backgroundColor: MyColors.redColor,
          duration: const Duration(seconds: 2),
          messageText: TextWidgetCustom(
              color: MyColors.whiteColor,
              text: "Please enter an email address.")));
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Get.showSnackbar(GetSnackBar(
          backgroundColor: MyColors.redColor,
          duration: const Duration(seconds: 2),
          messageText: TextWidgetCustom(
              color: MyColors.whiteColor, text: "Password reset email sent!")));
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
          backgroundColor: MyColors.redColor,
          duration: const Duration(seconds: 2),
          messageText: TextWidgetCustom(
              color: MyColors.whiteColor, text: e.toString().split(']').last)));
    }
  }
}
