import 'package:flutter/material.dart';

import '../Constants/Constants.dart';
import 'Active_Users.dart';
import 'InActive_Users.dart';
import 'globals_Admkin.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return   WillPopScope(
      onWillPop: () async {
        bool? exit = await AppNavigator.showExitConfirmationDialog(context);
        return exit ?? false; // If exit is null, default to false (stay in the app)
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Admin Access Panel",style: TextStyle(color: allHeadingPrimeColor),),
          automaticallyImplyLeading: false,

        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        globalCheckPage = "Active";
                      });
                       Navigator.push(context, MaterialPageRoute(builder: (context) => ActiveUsersScreen(),));
                    },
                    child: Column(
                      children: [
                        ClipOval(
                          child: Container(
                            color: boxBgColors,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/review 2.png",height: 75,width: 75,),
                            ),
                          ),
                        ),
                        Text("Active Users",style: HomeIconsText,)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        globalCheckPage = "InActive";
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InActiveUsersScreen(),));
                    },
                    child: Column(
                      children: [
                        ClipOval(
                          child: Container(
                            color: boxBgColors,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/review 2.png",height: 75,width: 75,),
                            ),
                          ),
                        ),
                        Text("UnActive Users",style: HomeIconsText,)
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ActiveUsersScreen()));
                    },
                    child: Column(
                      children: [
                        ClipOval(
                          child: Container(
                            color: boxBgColors,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/review 2.png",height: 75,width: 75,),
                            ),
                          ),
                        ),
                        Text("Staff Access",style: HomeIconsText,)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InActiveUsersScreen()));
                    },
                    child: Column(
                      children: [
                        ClipOval(
                          child: Container(
                            color: boxBgColors,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/review 2.png",height: 75,width: 75,),
                            ),
                          ),
                        ),
                        Text("UnActive Users",style: HomeIconsText,)
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AppNavigator {
  static Future<bool?> showExitConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => ExitConfirmationDialog(),
    );
  }
}
class ExitConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Exit Confirmation',style: allHeadingStyle,),
      content: Text('Are you sure you want to exit the app?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Stay in the app
          },
          child: Text('Cancel',style: AllTextStyle,),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Exit the app
          },
          child: Text('OK',style: AllTextStyle,),
        ),
      ],
    );
  }
}