import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/local_storage.dart';
import '../widgets/copyright_footer.dart';
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
  bool _agreedToPrivacyPolicy = false;
  bool _agreedToDisclaimer = false;

  bool get _allFieldsFilled =>
      firstNameController.text.isNotEmpty &&
      lastNameController.text.isNotEmpty &&
      zipCodeController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _agreedToPrivacyPolicy &&
      _agreedToDisclaimer;

  static const _orangeBorder = Color(0xffE8960C);
  static const _darkNavy = Color(0xff1B2E4B);
  static const _hintGray = Color(0xffBBBBBB);
  static const _fieldBg = Color(0xffF8F9FA);
  static const _linkBlue = Color(0xff3B7DD8);

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      hintText: hint,
      hintStyle: const TextStyle(color: _hintGray, fontSize: 16),
      fillColor: _fieldBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: _orangeBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: _orangeBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: _orangeBorder, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      prefixIcon: Icon(icon, color: _hintGray, size: 22),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _darkNavy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: Image.asset(
                      "assets/images/newimage.jpeg",
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Heading
                  Center(
                    child: Text(
                      'Create Your Account',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: _darkNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // First Name
                  TextField(
                    controller: firstNameController,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (_) => setState(() {}),
                    decoration: _fieldDecoration(
                      hint: 'First Name',
                      icon: Icons.person_outline,
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 14),

                  // Last Name
                  TextField(
                    controller: lastNameController,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (_) => setState(() {}),
                    decoration: _fieldDecoration(
                      hint: 'Last Name',
                      icon: Icons.person_outline,
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 14),

                  // Zip Code
                  TextField(
                    controller: zipCodeController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: _fieldDecoration(
                      hint: 'Zip Code',
                      icon: Icons.location_on_outlined,
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 14),

                  // Email
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => setState(() {}),
                    decoration: _fieldDecoration(
                      hint: 'Email',
                      icon: Icons.mail_outline,
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 14),

                  // Password
                  TextField(
                    obscureText: !_isPasswordVisible,
                    controller: _passwordController,
                    onChanged: (_) => setState(() {}),
                    decoration: _fieldDecoration(
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: _hintGray,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 14),

                  // Confirm Password
                  TextField(
                    obscureText: !_isConfirmPasswordVisible,
                    controller: _confirmPasswordController,
                    onChanged: (_) => setState(() {}),
                    decoration: _fieldDecoration(
                      hint: 'Confirm Password',
                      icon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: _hintGray,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),

                  // Privacy policy checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreedToPrivacyPolicy,
                          tristate: false,
                          onChanged: (bool? value) {
                            setState(() {
                              _agreedToPrivacyPolicy = value == true;
                            });
                          },
                          activeColor: _orangeBorder,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(color: _hintGray),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "I agree to the ",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Color(0xff666666),
                                fontSize: 14,
                              ),
                            ),
                            children: [
                              TextSpan(
                                text: "Privacy Policy",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: _orangeBorder,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const _PrivacyPolicyScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Disclaimer checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreedToDisclaimer,
                          tristate: false,
                          onChanged: (bool? value) {
                            setState(() {
                              _agreedToDisclaimer = value == true;
                            });
                          },
                          activeColor: _orangeBorder,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(color: _hintGray),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'I understand that Disaster AIDvisor is for general informational purposes only and is not a substitute for emergency services. If you are in immediate danger, please call 911.',
                          style: GoogleFonts.poppins(
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
                  const SizedBox(height: 24),

                  // Sign Up button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _allFieldsFilled ? _darkNavy : const Color(0xffCCCCCC),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 54),
                      elevation: 0,
                    ),
                    onPressed: _allFieldsFilled ? _handleSignUp : null,
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Already have account
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Color(0xff666666),
                            fontSize: 15,
                          ),
                        ),
                        children: [
                          TextSpan(
                            text: "Sign In",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: _linkBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const CopyrightFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    if (!_agreedToPrivacyPolicy || !_agreedToDisclaimer) {
      Fluttertoast.showToast(
        msg: "Please agree to the Privacy Policy and Disclaimer",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return;
    }

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
        msg: "Passwords do not match",
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
  }
}

class _PrivacyPolicyScreen extends StatelessWidget {
  const _PrivacyPolicyScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xff1B2E4B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff1B2E4B),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Text(
          '''Disaster AIDvisor – Terms and Conditions of Use

Effective Date: [Insert Date]
Last Updated: [Insert Date]

1. Informational Use Only
Disaster AIDvisor is intended to provide general, non-specific information and guidance to users who are preparing for, experiencing, or recovering from natural disasters. The Service may also provide generalized explanations of insurance policies and claims processes, or assist users in navigating post-disaster challenges. It draws from publicly available resources, the BuildSOS knowledge base, and large language models (LLMs) via OpenAI's ChatGPT API. It is intended solely for informational and educational purposes and does not constitute legal, financial, insurance, safety, emergency, or professional advice.

2. No Emergency or Real-Time Services
Disaster AIDvisor is not a substitute for 911, emergency alerts, or official disaster response systems. It does not provide real-time weather, evacuation, or safety information and must not be relied on during emergencies. If you are experiencing a life-threatening situation, please immediately call 911 or follow local emergency instructions.

3. Pass-Through to External Resources
The Service may reference or guide users to third-party materials such as FEMA programs, emergency shelter locators, disaster relief resources, insurance guides, and best practice checklists. These references are provided as a convenience only. BuildSOS does not create, control, verify, or guarantee the accuracy, completeness, or timeliness of any third-party resources or content. We are not responsible for any harm, loss, or confusion resulting from reliance on third-party material.

4. No Client, Fiduciary, or Advisory Relationship
Use of the Service does not create any professional relationship between you and BuildSOS or any of its agents. The Service does not constitute legal advice, insurance interpretation, contractor guidance, or emergency preparedness certification. Any decisions you make are your sole responsibility.

5. User Assumes All Risk
You agree that your use of Disaster AIDvisor is entirely at your own risk. BuildSOS and its affiliates, partners, officers, employees, or contractors disclaim any and all liability for damages, including but not limited to: Property damage or delayed recovery, Denied insurance claims, Physical injury or emotional distress, Missed deadlines or filings, Incomplete or outdated advice. You must independently verify all recommendations or resources provided by the Service.

6. No Document Uploads or Data Retention
Disaster AIDvisor does not accept, process, or store uploaded documents. You should not attempt to share sensitive personal or financial information through the Service. Any user input may be processed by the underlying AI system for functionality and improvement purposes, in accordance with our Privacy Policy.

7. Third-Party Technology Disclaimer
The Service is powered in part by OpenAI's language models and may interface with other third-party APIs and publicly available data. BuildSOS is not responsible for errors, hallucinations, delays, or outages caused by these providers.

8. Acceptable Use
You agree not to misuse the Service or attempt to rely on it in ways not intended, including but not limited to: Submitting false, harmful, or malicious content, Using the Service as a substitute for licensed professionals, Attempting to obtain real-time emergency updates from the chatbot, Making legal, medical, or financial decisions based solely on its responses. We reserve the right to suspend access for any user who misuses the Service.

9. Intellectual Property
All branding, interfaces, original content, and underlying systems developed by BuildSOS are the exclusive property of BuildSOS, LLC, and protected under applicable IP laws. You may not reproduce, copy, distribute, or repurpose content from the Service without written permission.

10. Modifications to Terms
We reserve the right to update or modify these Terms at any time without prior notice. Your continued use of the Service constitutes acceptance of any updated Terms.

11. Governing Law
These Terms shall be governed by and construed in accordance with the laws of the State of Louisiana, without regard to conflict of laws principles. Any disputes not subject to arbitration shall be brought exclusively in the state or federal courts located in Orleans Parish, Louisiana, and you hereby consent to their jurisdiction.

12. Contact Us
For questions regarding these Terms or your use of the Service, please contact: BuildSOS, LLC

13. Dispute Resolution and Binding Arbitration
PLEASE READ THIS SECTION CAREFULLY. IT AFFECTS YOUR LEGAL RIGHTS. You agree that any dispute, controversy, or claim arising out of or relating to your use of Disaster AIDvisor or these Terms shall be exclusively resolved through final and binding arbitration, rather than in court. Arbitration shall be conducted in accordance with the Commercial Arbitration Rules of the American Arbitration Association (AAA). The arbitration will be held in New Orleans, Louisiana, unless the parties agree otherwise.''',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff333333),
              fontSize: 14,
              height: 1.7,
            ),
          ),
        ),
      ),
    );
  }
}
