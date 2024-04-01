import 'package:firebase_auth/firebase_auth.dart';
 import 'package:flutter/material.dart';


class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Authentication'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: phoneNumberController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {

                      String mobNo = phoneNumberController.text;
                      mobilenumber(mobNo);
                     // await verifyPhoneNumber(phoneNumberController.text);
                    },
                    child: Text('Send OTP'),
                  ),
                  SizedBox(height: 32),
                  TextField(
                    controller: otpController,
                    decoration: InputDecoration(labelText: 'OTP'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await signInWithPhoneNumber(otpController.text);
                    },
                    child: Text('Verify OTP'),
                  ),
                  SizedBox(height: 32),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await registerWithEmailAndPassword(
                        emailController.text,
                        passwordController.text,
                      );
                    },
                    child: Text('Register with Email'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await sendEmailVerification();
                    },
                    child: Text('Send Email Verification'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> mobilenumber (String mobNo) async {
    String countryCode = "91";
       String formattedNumber = '+$countryCode${mobNo.replaceAll(RegExp(r'[^0-9]'), '')}';
    await verifyPhoneNumber(formattedNumber);
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        print('Code Sent: $verificationId');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Auto Retrieval Timeout: $verificationId');
      },
    );
  }

  Future<void> signInWithPhoneNumber(String otp) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: "YOUR_VERIFICATION_ID", // Provide the verification ID obtained from codeSent callback
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> registerWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Registration successful');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      print('Email verification sent');
    } catch (e) {
      print(e.toString());
    }
  }
}
