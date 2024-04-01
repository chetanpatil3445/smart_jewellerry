import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinput/pinput.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Admin_Panel/Admin_Home.dart';
import '../Constants/Constants.dart';
import '../Constants/Globals.dart';
import '../Screens/BottomBar.dart';
import '../Screens/Homepage.dart';


class PasscodeScreen extends StatefulWidget {
  final String userId;

  const PasscodeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {


  // status check staff jeweller admin
  Future<void> fetchUserDetails(String userId) async {
    try {
      // Reference to the document for the specified user ID in the "User" collection
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('User').doc(userId).get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Extract user data
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        setState(() {

          globalOwnerStatus = userData['ownerId'];

        });
        // You can access other fields here and perform desired actions
        print('User ID: $userId, Status: $globalOwnerStatus');
      } else {
        print('User with ID $userId does not exist.');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }
  // status check staff jeweller admin


  TextEditingController passcodeController = TextEditingController();

  Future<String> getStoredPasscode(String userId) async {
    try {
      // Query Firestore to get the passcode using the user ID
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .get();

      if (documentSnapshot.exists) {
        // Extract passcode from the document
        return documentSnapshot['passcode'];
      }
    } catch (error) {
      print("Error getting passcode: $error");
    }

    // Return a default passcode or handle the case where passcode is not found
    return "1234";
  }

  void _showIncorrectPasswordPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Incorrect Password"),
          content: Text("Please enter the correct passcode."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToCurveBar() {
    if(globalOwnerStatus == "Admin") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminPanel()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserDetails(globalUserIdStored);
    getFirmIdFromSharedPreferences();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:  Text("Passcode Verification",style: TextStyle(color: allHeadingPrimeColor),),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
             // image: AssetImage("assets/images/BG1.png"),
              image: AssetImage("assets/BG1.png"),
              fit: BoxFit.cover,
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                   children: [

                     Text("Enter 4 digit passcode",style: TextStyle(color: Colors.black, fontSize: 18 , fontWeight: FontWeight.w500),),
                    SizedBox(height: 10,),
                    Pinput(
                      controller: passcodeController,
                      keyboardType: TextInputType.number,
                      length: 4,
                      defaultPinTheme: PinTheme(
                        height: 50,
                        width: 50,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: PrimeColor,
                          border: Border.all(color: allHeadingPrimeColor, width: 1),
                          borderRadius: BorderRadius.circular(5)

                        )
                      ),
                    ),

                    SizedBox(height: 10),

                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style:  ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              allHeadingPrimeColor
                          )
                        ),
                        onPressed: () async {
                        // String enteredPasscode = passcodeController.text;
                         String enteredPasscode = md5.convert(utf8.encode(passcodeController.text)).toString();

                         print(enteredPasscode);
                          // Fetch the stored passcode from Firestore using the user ID
                          String storedPasscode = await getStoredPasscode(globalUserIdStored);
                          print(storedPasscode);

                          if (enteredPasscode == storedPasscode) {
                            // Passcode is correct, navigate to CurveBar
                            _navigateToCurveBar();
                          } else {
                            // Incorrect passcode, show popup
                            _showIncorrectPasswordPopup();
                          }
                        },
                        child: Text("Login",style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


// Define a function to retrieve firm ID from SharedPreferences
  Future<String?> _getFirmNameSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('firmId');
  }

// Call this function to get the firm ID from SharedPreferences
  void getFirmIdFromSharedPreferences() async {
    String? firmId = await _getFirmNameSharedPreferences();
    if (firmId != null) {
      setState(() {
        globalFirmNameAllApp = firmId;
        globalFirmNameCheck = firmId;
      });
    } else {
      // Handle the case when firmId is null, if needed
      print('Firm ID not found in SharedPreferences');
    }
  }



}

