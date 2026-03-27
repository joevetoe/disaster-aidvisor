// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/chatting_screen.dart';
import '../views/emailverification.dart';
import '../views/login.dart';
import '../views/signup.dart';
import 'local_storage.dart';

class AuthService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> signup(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      print("IN THE  AUTH SERICE $email");
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));
      await LocalDb.setpassword(password: password);
      await LocalDb.setusername(username: email);
      await users.add({
        'email': email,
        'password': password,
        'count': 10,
      }).then((v) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const ChattingScreen()));
      }).onError((handleError, stack) {
        print(handleError);
      });
    } on FirebaseAuthException catch (e) {
      print("IN THE  AUTH SERICE  ERROR ${e.toString()}");
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> signin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // If login is successful, save isLogin as true
      await prefs.setBool('isLogin', true);
      await LocalDb.setusername(username: email);
      await LocalDb.setpassword(password: password);
      await Future.delayed(const Duration(seconds: 1));
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      for (var doc in snapshot.docs) {
        String docId = doc.id;
        print('Document ID: $docId');
        if (doc['email'] == FirebaseAuth.instance.currentUser?.email) {
          docid = docId;
          await LocalDb.setuserid(id: docid);
        }

        FirebaseFirestore.instance
            .collection('users')
            .doc(docid)
            .get()
            .then((DocumentSnapshot) async {
          log("${await DocumentSnapshot.data()?['emailverified']}");
          if (await DocumentSnapshot.data()?['emailverified']) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const ChattingScreen()));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const EmailVerificationScreen()));
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> signout({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Login()));
  }

  Future<void> sendPasswordResetEmail(
      {required String email, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: "Password reset email sent successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }
}
