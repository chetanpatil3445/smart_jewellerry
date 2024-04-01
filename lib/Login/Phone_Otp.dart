import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/Constants.dart';
import '../Constants/Globals.dart';
import 'Passcode_screen.dart';
import 'Registration.dart';
import 'Verify_Otp.dart';


var globalphone = "";
var globaluserId = ""; // Variable to store the user ID

class OtpLogin extends StatefulWidget {
  const OtpLogin({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<OtpLogin> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  bool _isLoading = false;

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });

    // Simulate a time-consuming task
    Future.delayed(Duration(seconds: 30), () {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'please try again or \nYour Number Is blocked By Firebase\ntry again tomorrow'),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }

  TextEditingController phoneController = TextEditingController();
  String phone = "";
  String CountryCode = "+91";

  int _counter = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          // Timer reached zero, you can perform any action here
          _timer.cancel(); // Stop the timer
        }
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _timer.cancel();
    super.dispose();
  }

  Future<void> _saveUserIdInSharedPreferences(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  Future<void> checkPhoneNumberExists(String phoneNumber) async {
    // Query Firestore to check if the phone number exists
    var querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Phone number found, get the user ID
      globaluserId = querySnapshot.docs.first.id;
      await _saveUserIdInSharedPreferences(globaluserId);
      setState(() {
        globalUserIdStored = globaluserId;
      });
      print("########Check Id USer $globaluserId");
      // Store user ID in shared preferences or wherever you want
      // Navigate to passcode screen
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PasscodeScreen(
                    userId: globalUserIdStored,
                  )));
    } else {
      // Phone number not found, navigate to OTP verification screen
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${CountryCode.toString() + phone}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          OtpLogin.verify = verificationId;
          Navigator.pushReplacement(
              // context, MaterialPageRoute(builder: (context) => OTPVERIFY()));
              context, MaterialPageRoute(builder: (context) => VeirfyOtp()));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
       body: Container(
         decoration: const BoxDecoration(
             image: DecorationImage(
               // image: AssetImage("assets/images/BG1.png"),
               image: AssetImage("assets/BG1.png"),
               fit: BoxFit.cover,
             )
         ),
         child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Container(
            //   child: Image.asset("assets/images/otpLogin.png",
            //     //height: MediaQuery.of(context).size.height *0.4,
            //   ),
            // ),
            Column(
              children: [
                SizedBox(height: 20,),
                Text("Welcome",style: TextStyle(
                  color:allHeadingPrimeColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),),
                 SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TextFormField(
                        controller: phoneController,
                        onChanged: (value) {
                          phone = value;
                          globalphone = value;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Mobile Number"
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            allHeadingPrimeColor,
                          )
                      ),
                      onPressed: () async {
                        _startLoading();
                        _startTimer();
                        await checkPhoneNumberExists(CountryCode + phone);


                      },
                      child: Text("Continue", style: TextStyle(
                          fontSize: 25 ,color: Colors.white
                      ),),
                    ),
                  ),
                ),

                Container(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text("")
                ),
              ],
            ),
          ],
      ),
       ),

    );
  }
}
