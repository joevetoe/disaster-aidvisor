// import 'package:address_me/constants/colors.dart';
// import 'package:address_me/main.dart';
// import 'package:address_me/services/local_storage.dart';
// import 'package:address_me/views/dashboard.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../views/chatting_screen.dart';
import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'services/local_storage.dart';
import 'views/emailverification.dart';
import 'views/login.dart';
import 'views/signup.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4)).then((onValue) async {
      docid = await LocalDb.getuserid();
      final data =
          await FirebaseFirestore.instance.collection('users').doc(docid).get();
      if (data.exists) {
        if (data['emailverified'] == false) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (builder) => const EmailVerificationScreen()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (builder) =>
                      docid != null ? const ChattingScreen() : const Login()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => const Login()));
      }
    });
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      body: Center(
        child: Image.asset("assets/images/splashnew.png"),
      ),
    );
  }
}
