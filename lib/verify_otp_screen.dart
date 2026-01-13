import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'otp_session.dart';

class VerifyOtpScreen extends StatefulWidget {
  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController otpController = TextEditingController();

  void verifyOtp() {
    if (otpController.text.trim() == OtpSession.otp) {
      Get.snackbar("Success", "OTP Verified");

      // NEXT ACTION
      // Example:
      // Get.to(Login());
      // or allow password reset
    } else {
      Get.snackbar("Error", "Invalid OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("OTP sent to ${OtpSession.email}"),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter OTP"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyOtp,
              child: Text("VERIFY OTP"),
            )
          ],
        ),
      ),
    );
  }
}
