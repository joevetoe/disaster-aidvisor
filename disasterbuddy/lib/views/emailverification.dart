// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../services/local_storage.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_widget.dart';
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

  var height = Get.height;
  var width = Get.width;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.blackColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check),
              // Image.asset(AppImages.varifyemail),
              SizedBox(
                height: height * 0.03,
              ),
              TextWidgetCustom(
                text: "Check Your Email".tr,
                size: 18,
                fontWeight: FontWeight.w600,
                color: MyColors.whiteColor,
              ),
              SizedBox(
                height: height * 0.01,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: TextWidgetCustom(
                    text:
                        'We have sent you Email on \n${auth.currentUser?.email}',
                    size: 11,
                    color: MyColors.whiteColor,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              const Center(
                  child: CircularProgressIndicator(color: Colors.white)),
              SizedBox(
                height: height * 0.03,
              ),
              Center(
                child: TextWidgetCustom(
                  text: 'Verifying email....',
                  size: 14,
                  fontWeight: FontWeight.w700,
                  color: MyColors.whiteColor,
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Center(
                child: TextWidgetCustom(
                  text:
                      'Please check your spam folder in case you cannot find the verification code.',
                  size: 16,
                  fontWeight: FontWeight.w700,
                  color: MyColors.whiteColor,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              MyCustomButton(
                height: 40,
                // fontSize: 16,
                width: double.infinity,
                ontap: () {
                  try {
                    FirebaseAuth.instance.currentUser?.sendEmailVerification();
                  } catch (e) {
                    debugPrint('$e');
                  }
                },
                text: "Resend Email",
                color: MyColors.whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
