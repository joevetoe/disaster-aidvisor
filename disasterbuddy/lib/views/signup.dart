import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;

import '../constants/colors.dart';
import '../constants/images.dart';
import '../services/local_storage.dart';
import 'emailverification.dart';
import 'login.dart';

String? docid;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.blackColor,
      body: SafeArea(
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
              const SizedBox(height: 70),
              Text(
                'Create Your\nAccount',
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _firstName(),
              const SizedBox(height: 30),
              _lastName(),
              const SizedBox(height: 30),
              _zipCode(),
              const SizedBox(height: 30),
              _emailAddress(),
              const SizedBox(height: 20),
              _password(),
              const SizedBox(height: 20),
              _confirmPassword(),
              const SizedBox(height: 10),
              _signin(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 30),
        child: _signup(context),
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
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _firstName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'First Name',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: firstNameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _lastName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last Name',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: lastNameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _zipCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Zip Code',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: zipCodeController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _password() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: !_isPasswordVisible,
          controller: _passwordController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _confirmPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: !_isConfirmPasswordVisible,
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
            suffixIcon: IconButton(
              icon: Icon(_isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _signup(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 50),
        elevation: 0,
      ),
      onPressed: () async {
        final email = _emailController.text;
        final password = _passwordController.text;
        final confirmPassword = _confirmPasswordController.text;
        if (email.isEmpty ||
            password.isEmpty ||
            confirmPassword.isEmpty ||
            firstNameController.text.isEmpty ||
            lastNameController.text.isEmpty ||
            zipCodeController.text.isEmpty) {
          Fluttertoast.showToast(
            msg: "Please fill in all fields",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          return;
        }

        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
        if (!emailRegex.hasMatch(email)) {
          Fluttertoast.showToast(
            msg: "Invalid email address",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          return;
        }

        if (password != confirmPassword) {
          Fluttertoast.showToast(
            msg: "Password and Confirm Password do not match",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          return;
        }
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        CollectionReference users =
            FirebaseFirestore.instance.collection('users');
        await Future.delayed(const Duration(seconds: 1));
        await LocalDb.setpassword(password: password);
        docid = users.id;
        await LocalDb.setusername(username: email);
        await users.add({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'zipCode': zipCodeController.text,
          'email': email,
          'password': password,
          'emailverified': false,
          // "ispaid": false,
          // "paidDate": "",
        }).then((v) {
          docid = v.id;

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const EmailVerificationScreen()));
        }).onError((handleError, stack) {
          print(handleError);
        });
        // Get.offAll(() => const Dashboard());
        // if (_formkey.currentState!.validate()) {
        // try {
        //   FirebaseAuth.instance
        //       .createUserWithEmailAndPassword(
        //     email: emailController.text,
        //     password: passwordController.text,
        //   )
        //       .then((v) async {
        //     final databaseref =
        //         FirebaseFirestore.instance.collection('users');
        //     await databaseref.add({
        //       'name': nameController.text,
        //       'email': emailController.text,
        //       'password': passwordController.text,
        //       'paidDuration': '',
        //       'paiddate': "",
        //     }).then((v) {
        //       Get.offAll(() => const DemoHome());
        //     }).onError((handleError, stack) {
        //       print(handleError);
        //     });
        //   });
        // } catch (signUpError) {
        //   if (signUpError is PlatformException) {
        //     if (signUpError.code ==
        //         'ERROR_EMAIL_ALREADY_IN_USE') {
        //       Get.showSnackbar(GetSnackBar(
        //           backgroundColor: MyColors.redColor,
        //           duration: const Duration(seconds: 2),
        //           messageText: MyTextWidgetCustom(
        //               color: MyColors.whiteColor,
        //               text: "Email already in Use")));
        //     } else if (signUpError.code ==
        //         'ERROR_WEAK_PASSWORD') {
        //       Get.showSnackbar(GetSnackBar(
        //           backgroundColor: MyColors.redColor,
        //           duration: const Duration(seconds: 2),
        //           messageText: MyTextWidgetCustom(
        //               color: MyColors.whiteColor,
        //               text: "Password is Weak.")));
        //     } else if (signUpError.code ==
        //         'ERROR_INVALID_EMAIL') {
        //       Get.showSnackbar(GetSnackBar(
        //           backgroundColor: MyColors.redColor,
        //           duration: const Duration(seconds: 2),
        //           messageText: MyTextWidgetCustom(
        //               color: MyColors.whiteColor,
        //               text: "Enter Valid Email.")));
        //     }
        //   }
        // }
        // }

        // await _generateAndSendOtp(email, password, context);
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, color: Colors.white),
        ],
      ),
    );
  }

  Widget _signin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: [
            const TextSpan(
              text: "Already Have Account? ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: "Login",
              style: const TextStyle(color: Colors.white, fontSize: 20),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
