import 'package:authentication/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  bool isLoading = false;

  @override
  void initState() {
    sendverifylink();
    super.initState();
  }

  sendverifylink() async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseAuth.instance.currentUser!
        .sendEmailVerification()
        .then((value) => {
              Get.snackbar(
                "Email Verification",
                "Email Verification link has been sent to ${user.email}",
                margin: EdgeInsets.all(30),
                backgroundColor: Colors.white.withOpacity(0.1),
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              ),
            });
  }

  reload() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.currentUser!.reload();
      Get.offAll(Wrapper());
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar(
        "Error",
        "Failed to verify. Please try again.",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Email Verification",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.mark_email_unread_outlined,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 24),
            Text(
              "Verify Your Email",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "We've sent a verification link to your email.",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              "Please check your inbox and click the link to verify your account.",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: isLoading ? null : reload,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledBackgroundColor: Colors.grey,
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.black)
                  : Text("I've Verified My Email",
                      style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: sendverifylink,
              child: Text(
                "Resend Verification Email",
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
