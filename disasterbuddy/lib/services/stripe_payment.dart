// import 'dart:convert';
// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// import '../constants/colors.dart';
// import '../views/dashboard.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:ofmynd_project/chatgpt4.0/ai_chat_screen.dart';
// // import 'package:ofmynd_project/provider/auth_provider.dart';

// class StripePaymentHandle {
//   static Map<String, dynamic>? paymentIntent;

//   static Future<bool?> stripeMakePayment(
//       {required amount, required time}) async {
//     try {
//       bool? check;
//       paymentIntent = await createPaymentIntent('$amount', 'USD');
//       await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//               billingDetails: const BillingDetails(
//                   name: 'YOUR NAME',
//                   email: 'YOUREMAIL@gmail.com',
//                   phone: 'YOUR NUMBER',
//                   address: Address(
//                       city: 'YOUR CITY',
//                       country: 'YOUR COUNTRY',
//                       line1: 'YOUR ADDRESS 1',
//                       line2: 'YOUR ADDRESS 2',
//                       postalCode: 'YOUR PINCODE',
//                       state: 'YOUR STATE')),
//               paymentIntentClientSecret:
//                   paymentIntent!['client_secret'], //Gotten from payment intent
//               style: ThemeMode.dark,
//               merchantDisplayName: 'AddressMe'));
//       check = await displayPaymentSheet(time: time);
//       return check;
//       //STEP 3: Display Payment sheet
//     } catch (e) {
//       print(e.toString());
//       Get.showSnackbar(GetSnackBar(
//         message: e.toString(),
//         duration: const Duration(seconds: 3),
//         backgroundColor: MyColors.redColor,
//       ));
//     }
//     return null;
//   }

//   static displayPaymentSheet({required time}) async {
//     try {
//       // 3. display the payment sheet.
//       final check = await Stripe.instance.presentPaymentSheet();
//       log("$check");
//       // User? user = FirebaseAuth.instance.currentUser;
//       // final databaseref = FirebaseDatabase.instance.ref('users');
//       // databaseref.child(user?.email?.replaceAll('.', '') ?? '').set({
//       //   'trail': 'no',
//       //   'purchasedate': "${DateTime.now()}",
//       //   'purchased': "yes",
//       //   'countleft': "$time",
//       // });

//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(docid ?? '')
//           .update({
//         "ispaid": true,
//         "paidDate": DateTime.now().add(const Duration(days: 30)).toString(),
//       });
//       return true;
//       // await AuthController.updatepaymentforuser(AuthController().userData?.uid);
//       // }
//     } on Exception catch (e) {
//       if (e is StripeException) {
//         Get.showSnackbar(GetSnackBar(
//           message: 'Error from Stripe: ${e.error.localizedMessage}',
//           duration: const Duration(seconds: 3),
//           backgroundColor: MyColors.redColor,
//         ));
//       } else {
//         Get.showSnackbar(GetSnackBar(
//           message: 'Unforeseen error: $e',
//           duration: const Duration(seconds: 3),
//           backgroundColor: MyColors.redColor,
//         ));
//       }
//     }
//   }

// //create Payment
//   static createPaymentIntent(String amount, String currency) async {
//     try {
//       //Request body
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(amount),
//         'currency': currency,
//       };

//       //Make post request to Stripe
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer ${dotenv.env['secret_key']}',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       return json.decode(response.body);
//     } catch (err) {
//       throw Exception(err.toString());
//     }
//   }

// //calculate Amount
//   static calculateAmount(String amount) {
//     final calculatedAmount = (int.parse(amount)) * 100;
//     return calculatedAmount.toString();
//   }
// }
