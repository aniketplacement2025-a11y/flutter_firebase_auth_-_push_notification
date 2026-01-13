import 'dart:math';

import 'package:emailjs/emailjs.dart' as EmailJS;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_notification/forgot.dart';
import 'package:flutter_firebase_notification/sign_up.dart';
import 'package:flutter_firebase_notification/verify_otp_screen.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart' as google_sign_in;
import 'package:emailjs/emailjs.dart';

import 'otp_session.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // REQUIRED: init once (main() or initState)
  //   EmailJS.Options(
  //       publicKey: 'z1yDxC2-7XO2tvqA9',
  //   ); // PUBLIC KEY
  // }

  signIn() async {
    setState(() {
      isLoading=true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.trim(), password: password.text);
    }on FirebaseAuthException catch(e){
      Get.snackbar("error msg", e.code);
    } catch(e){
      Get.snackbar("error msg", e.toString());
    }
    setState(() {
      isLoading=false;
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      // Create GoogleSignIn instance with explicit import
      final google_sign_in.GoogleSignIn googleSignIn =
      google_sign_in.GoogleSignIn.instance;

      // Trigger sign-in flow
      final GoogleSignInAccount? googleUser =
      await googleSignIn.authenticate();

      if (googleUser == null) {
        print('User cancelled Google Sign-In');
        return; // User cancelled
      }

      // Get authentication tokens
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Debug: Print available properties
      print('Available properties:');
      print('idToken: ${googleAuth.idToken}');

      // Method 1: Try with just idToken
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

    } catch (error) {
      print('Google Sign-In Error: $error');
    }
  }

  String generateOtp() {
    return (Random().nextInt(900000) + 100000).toString();
  }

  // Future<void> sendOtpEmail(String userEmail) async {
  //   final otp = generateOtp();
  //
  //   try {
  //     await EmailJS.send(
  //       'service_6q26gfj',          // service_id
  //       'template_r3t8m1f',         // template_id
  //       {
  //         'to_email': userEmail,    // template_params
  //         'otp': otp,
  //       },
  //     );
  //
  //     Get.snackbar("Success", "OTP sent to your inbox");
  //     print("OTP sent successfully");
  //
  //   } catch (e) {
  //     print("EmailJS error: $e");
  //     Get.snackbar("Error", "Failed to send OTP");
  //   }
  // }





  @override
  Widget build(BuildContext context) {
    return isLoading? Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(hintText: 'Enter Email'),
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(hintText: 'Enter Password'),
            ),

            ElevatedButton(
                onPressed: (() => signIn()),
                child: Text("Login"),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: (() => Get.to(SignUp())),
              child: Text("Register Now"),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: (() => Get.to(Forgot())),
              child: Text("Forgot Password"),
            ),

            Center(
              child: ElevatedButton(
                  onPressed: (()=>signInWithGoogle()),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Sign In with Google",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  )
              ),
            ),

            // Center(
            //   child: ElevatedButton(
            //       onPressed: () {
            //         if (email.text.trim() == "") {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             SnackBar(content: Text("Enter an Email First"),)
            //           );
            //         } else {
            //           sendOtpEmail(email.text.trim());
            //         }
            //       },
            //       child: Text(
            //         "SEND OTP EMAIL",
            //         style: TextStyle(
            //           fontSize: 25,
            //         ),
            //       ),
            //   ),
            // ),


          ],
        ),
      ),
    );
  }
}
