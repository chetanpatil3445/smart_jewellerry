

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants/Constants.dart';
import '../Constants/Globals.dart';
import '../Screens/BottomBar.dart';
import 'Passcode_screen.dart';
import 'Phone_Otp.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  Constants myConstants = Constants();

  late bool isNumberStored;

  @override
  void initState() {
    super.initState();
    // Check if the user ID is stored in SharedPreferences
    checkUserId();
  }

  Future<void> checkUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isNumberStored = prefs.containsKey('globalphone');
      globalUserIdStored = prefs.getString('userId') ?? '';
    });
    print("#############TestKey####$globalUserIdStored");
    // testing
    if (globalUserIdStored.isNotEmpty) {
      // Mobile number is found, navigate to the home page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PasscodeScreen(userId: globalUserIdStored,)));
    } else {
      // Mobile number is not found, navigate to the OTP login page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpLogin()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: myConstants.primaryColor.withOpacity(.5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/Expense.png'),
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: () {
                  if (globalUserIdStored.isNotEmpty) {
                    // Mobile number is found, navigate to the home page
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CurveBar()));
                  } else {
                    // Mobile number is not found, navigate to the OTP login page
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpLogin()));
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: myConstants.primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Center(
                    child: Text('Get started', style: TextStyle(color: Colors.white, fontSize: 18),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: myConstants.primaryColor.withOpacity(.5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Developed By Chetan Patil', style: TextStyle(color: Colors.blue, fontSize: 15),),
        ),
      ),
    );
  }
}
