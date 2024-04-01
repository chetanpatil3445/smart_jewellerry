import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import '../Constants/Constants.dart';
import '../Constants/Globals.dart';
import '../Screens/BottomBar.dart';
import 'Passcode_screen.dart';
import 'Phone_Otp.dart';
import 'package:crypto/crypto.dart';



class  Registration extends StatefulWidget {
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  var code = "";
  final FirebaseAuth auth = FirebaseAuth.instance;

  int _counter = 30;
  late Timer _timer;


  @override
  void initState() {
    super.initState();
    getData();
    // Start the countdown timer
    _startTimer();
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



  List<Map<String, dynamic>> dataList = [];

  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('User').get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          dataList = querySnapshot.docs.map((document) => document.data() as Map<String, dynamic>).toList();
         // globalDocumentIndex = dataList.length + 1;
        });
      //  print("###############$globalDocumentIndex");
      } else {
        // Handle case where collection is empty
        print('Collection is empty');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
   final TextEditingController _cityController = TextEditingController();
   final TextEditingController _passcodeController = TextEditingController();
   final TextEditingController _firmNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
       ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/BG3.png"),
              fit: BoxFit.cover,
            )
        ),
        child: Column(
          children: [
             Expanded(
               child: Padding(
                padding: const EdgeInsets.only(left: 15.0 , right: 15),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                      Text("Registration",style: TextStyle(color: allHeadingPrimeColor , fontSize: 22 , fontWeight: FontWeight.w700),),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.06,),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [

                            TextFormField(
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              controller: _nameController,
                              // initialValue: firstNameController.text,
                              autofocus: false,
                              style: AllTextStyle,
                              decoration: const InputDecoration(
                                focusedBorder:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: allHeadingPrimeColor)
                                ),
                                labelText: "First Name",
                                labelStyle: TextStyle(
                                  color: Colors.black
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 10.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey)
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 15,),

                            TextFormField(
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your Last name';
                                }
                                return null;
                              },
                              controller: _lastnameController,
                               autofocus: false,
                              style: AllTextStyle,
                              decoration: const InputDecoration(
                                focusedBorder:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: allHeadingPrimeColor)
                                ),
                                labelText: "Last Name",
                                labelStyle: TextStyle(
                                    color: Colors.black
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 10.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey)
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 15,),

                            TextFormField(
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your City';
                                }
                                return null;
                              },
                              controller: _cityController,
                              autofocus: false,
                              style: AllTextStyle,
                              decoration: const InputDecoration(
                                focusedBorder:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: allHeadingPrimeColor)
                                ),
                                labelText: "City",
                                labelStyle: TextStyle(
                                    color: Colors.black
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 10.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey)
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 15,),

                            TextFormField(
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your Shop Name';
                                }
                                return null;
                              },
                              controller: _firmNameController,
                              autofocus: false,
                              style: AllTextStyle,
                              decoration: const InputDecoration(
                                focusedBorder:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: allHeadingPrimeColor)
                                ),
                                labelText: "Shop Name",
                                labelStyle: TextStyle(
                                    color: Colors.black
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 10.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey)
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 30,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Create a 4 digit passcode"),
                              ],
                            ),

                            SizedBox(height: 15,),

                            Pinput(
                              controller: _passcodeController,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ),
             ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(

                children: [

                  Container(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            allHeadingPrimeColor
                        )
                      ),
                      onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                        try{
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: OtpLogin.verify, smsCode: globalOtp);
                          // Sign the user in (or link) with the credential
                          await auth.signInWithCredential(credential);
                          await _createUserInFirestore();


                          String firmId = _firmNameController.text;
                          DateTime currentDate = DateTime.now();

                          Map<String, dynamic> firmData = {
                            'FirmName': firmId,
                            'FirmExpiryDate': currentDate.add(const Duration(days: 30)),
                            'FirmStatus': 'Active',
                          };
                          setState(() {
                            globalFirmNameAllApp = firmId ;
                          });
                          AddFirm(globalUserIdStored, firmId, firmData);



                           String userId = auth.currentUser!.uid;
                          _formKey.currentState?.reset();
                          Navigator.push (
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasscodeScreen(userId: globalUserIdStored,),
                            ),
                          );
                         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UserList()));
                        }
                        catch(e){
                          final snackBar = SnackBar(
                            content: Text('Invalid OTP. Please try again.'),
                            duration: Duration(seconds: 3),
                          );

                          // Find the Scaffold in the widget tree and show the SnackBar
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } }
                      },
                      child: Text("Submit", style: TextStyle(
                        color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                      ),),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );

  }

  Future<void> _saveFirmNameSharedPreferences(String firmId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firmId', firmId);
  }


  Future<void> _createUserInFirestore() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        String firstName = _nameController.text;
        String cityName = _cityController.text;
        String lastname = _lastnameController.text;
        String passcodes = md5.convert(utf8.encode(_passcodeController.text)).toString();
        DateTime currentDate = DateTime.now();

        // Create or update the user document in Firestore
        await FirebaseFirestore.instance.collection('User').doc(user.uid).set({
          'phoneNumber': user.phoneNumber,
          'city': cityName,
          'fname': firstName,
          'lname': lastname,
          'passcode': passcodes,
          'userId': user.uid,
          'status': 'Active',
          'ownerId': 'Jeweller',
          'SubExpiryDate': currentDate.add(const Duration(days: 30)),
          // Add other user information as needed
        });

        // Save user ID in SharedPreferences
        print("testing ##################${user.uid}");
        setState(() {
          globalUserIdStored = user.uid;
        });

        await _saveUserIdInSharedPreferences(user.uid);
      }
    } catch (e) {
      print("Error creating/updating user in Firestore: $e");
      // Handle error, show error message, etc.
    }
  }

  Future<void> _saveUserIdInSharedPreferences(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  Future<void> AddFirm(String userId, String firmId, Map<String, dynamic> firmData) async {
    try {
      // Reference to the user's document in the "User" collection
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('User').doc(userId);

      // Reference to the "Firms" collection within the user's document
      CollectionReference firmCollectionRef = userDocRef.collection('Firms');

      // Set a document with the specified firm ID and data
      await firmCollectionRef.doc(firmId).set(firmData);
      _saveFirmNameSharedPreferences(firmId);
      print('Firm added successfully.');
    } catch (e) {
      print('Error adding firm: $e');
    }
  }
}

//    var   currentPasscode = md5.convert(utf8.encode(controller.passwordController.text)).toString();