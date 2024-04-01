import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_jewellerry/Constants/Constants.dart';
import '../Constants/Globals.dart';
import 'Customer/Add_Customer.dart';
import 'Customer/Customer_List.dart';
import 'MyDrawer.dart';
import 'Stock/Add_Stock.dart';
import 'Stock/Stock_List.dart';



class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String status = '';
  String userName = '';
  late DateTime subExpiryDate;

  Future<void> fetchUserDetails(String userId) async {
    try {
      // Reference to the document for the specified user ID in the "User" collection
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('User').doc(userId).get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Extract user data
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          status = userData['status'];
          globalStatus = userData['status'];
          userName = userData['fname'] + ' ' + userData['lname'];
          globalJewellerName = userData['fname'] + ' ' + userData['lname'];
          subExpiryDate = (userData['SubExpiryDate'] as Timestamp).toDate();
        });
        checkSubExpiryDate();
        // You can access other fields here and perform desired actions
        print('User ID: $userId, Status: $status, UserName: $userName');
      } else {
        print('User with ID $userId does not exist.');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  void showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Required'),
        content: Text('Your plan is expired for this firm "$globalFirmNameCheck" . \nto continue with our services , You have to pay charges.'),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK',style: AllTextStyle,),
          ),
        ],
      ),
    );
  }

  void showSelectFirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Firstly Please Select The Firm From Drawer'),
        //content: Text('Your plan is expired for this firm "$globalFirmNameCheck" . \nto continue with our services , You have to pay charges.'),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK',style: AllTextStyle,),
          ),
        ],
      ),
    );
  }

  // payment by date status change


  void checkSubExpiryDate() {
    DateTime now = DateTime.now();
    if (subExpiryDate.year == now.year &&
        subExpiryDate.month == now.month &&
        subExpiryDate.day == now.day) {
      // If subExpiryDate is today, call another function
      Map<String, dynamic> updatedData = {
        'status': 'Passive',
      };
      updateProduct(globalUserIdStored, updatedData );
    }
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateProduct(String productId, Map<String, dynamic> updatedData) async {
    try {
      DocumentSnapshot document = await firestore.collection('User').doc(productId).get();

      if (document.exists) {
        // Update user details
        await firestore.collection('User').doc(productId).update(updatedData);

        print('User updated successfully');
      } else {
        print('Document not found: $productId');
      }
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFirmDetails(globalFirmNameAllApp);
    fetchUserDetails(globalUserIdStored);
    }

   // firm Conditions

  Future<void> fetchFirmDetails(String globalFirmName) async {
    print("!!!!!!!!!!!!!!!!!$globalFirmName");
    try {
      // Reference to the document with the specified ID in the "Firms" subcollection
      DocumentReference firmDocRef = FirebaseFirestore.instance.collection('User').doc(globalUserIdStored).collection('Firms').doc(globalFirmName);

      // Get the document snapshot
      DocumentSnapshot firmSnapshot = await firmDocRef.get();

      // Check if the document exists
      if (firmSnapshot.exists) {
        // Extract firm data
        Map<String, dynamic>? firmData = firmSnapshot.data() as Map<String, dynamic>?;

        if (firmData != null) {
          setState(() {
            // Access firm data such as FirmName
            globalFirmCheckExp = firmData['FirmStatus'] ?? "";
            globalFirmNameCheck = firmData['FirmName'] ?? "";

            // Access other data as needed
            // For example, if 'SubExpiryDate' field exists and is not null
            if (firmData['FirmExpiryDate'] != null) {
              firmExpiryDate = (firmData['FirmExpiryDate'] as Timestamp).toDate();
            }
            checkFirmExpiryDate();
            print(firmExpiryDate);
            print(globalFirmCheckExp);
          });
        } else {
          print('Firm data is null.');
        }
      } else {
        print('Firm with ID $globalFirmName does not exist.');
      }
    } catch (e) {
      print('Error fetching firm details: $e');
    }
  }
  late DateTime firmExpiryDate;

  void checkFirmExpiryDate() {
    print("check");
    DateTime now = DateTime.now();
    if (firmExpiryDate.year == now.year &&
        firmExpiryDate.month == now.month &&
        firmExpiryDate.day == now.day &&
        firmExpiryDate.hour == now.hour ) {
      // If subExpiryDate is today, call another function
      Map<String, dynamic> updatedData = {
        'FirmStatus': 'Passive',
      };
      updateFirm(globalFirmNameAllApp, updatedData );
    }
  }

  Future<void> updateFirm( String firmId, Map<String, dynamic> updatedData) async {
    print("############Called");
    try {
      // Reference to the document for the specified user ID and firm ID in the "Firms" subcollection
      DocumentReference firmDocRef = FirebaseFirestore.instance.collection('User').doc(globalUserIdStored).collection('Firms').doc(firmId);

      // Check if the document exists
      DocumentSnapshot firmSnapshot = await firmDocRef.get();
      if (firmSnapshot.exists) {
        // Update firm details
        await firmDocRef.update(updatedData);

        // Show success alert

        // Navigate to another page after 2 seconds

        print('Firm updated successfully');
      } else {
        print('Firm with ID $firmId under user with ID $globalUserIdStored does not exist.');
      }
    } catch (e) {
      print('Error updating firm: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? exit = await AppNavigator.showExitConfirmationDialog(context);
        return exit ?? false; // If exit is null, default to false (stay in the app)
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        drawer: MyDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/BG1.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 20 , right: 20 , top: 10),
                  child: Container(
                    height: MediaQuery.of(context).size.height* 0.090,
                    width: double.infinity,
                   decoration: const BoxDecoration(
                     color:  boxBgColors,
                     borderRadius: BorderRadius.all(Radius.circular(8))
                   ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Todays Sell",style: allHeadingStyle,),
                            Text("₹ 100000",style: allHeadingStyle,)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Gold 66777/- GM",style: allHeadingStyle,),
                            Text("Silver 70000/- KG",style: allHeadingStyle,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if(globalFirmNameAllApp.isNotEmpty){
                              //
                              if (status == 'Active' && globalFirmCheckExp == 'Active' ) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerList(),));

                              } else {
                                showPaymentDialog(context);
                              }
                              //
                            } else {
                              showSelectFirmDialog(context);
                            }

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
                              Text("Customer",style: HomeIconsText,)
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height *0.04,),
                        GestureDetector(
                          onTap: () {
                            if(globalFirmNameAllApp.isNotEmpty){
                              //
                              if (status == 'Active' && globalFirmCheckExp == 'Active' ) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddStock(),));

                              } else {
                                showPaymentDialog(context);
                              }
                              //
                            } else {
                              showSelectFirmDialog(context);
                            }

                          },
                          child: Column(
                            children: [
                              ClipOval(
                                child: Container(
                                  color: boxBgColors,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset("assets/ready-stock 1.png",height: 75,width: 75,),
                                  ),
                                ),
                              ),
                              Text("Add Stock",style: HomeIconsText,)
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height *0.06,),
                        Column(
                          children: [
                            ClipOval(
                              child: Container(
                                color: boxBgColors,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset("assets/control-panel 1.png",height: 75,width: 75,),
                                ),
                              ),
                            ),
                            Text("Setting",style: HomeIconsText,)
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height *0.06,),
                        Column(
                          children: [
                            ClipOval(
                              child: Container(
                                color: boxBgColors,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset("assets/shopping-bag 1.png",height: 75,width: 75,),
                                ),
                              ),
                            ),
                            Text("Order",style: HomeIconsText,)
                          ],
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height *0.04,),
                        GestureDetector(
                          onTap: () {
                            if(globalFirmNameAllApp.isNotEmpty){
                              //
                              if (status == 'Active' && globalFirmCheckExp == 'Active' ) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => StockList(),));

                              } else {
                                showPaymentDialog(context);
                              }
                              //
                            } else {
                              showSelectFirmDialog(context);
                            }

                          },
                          child: Column(
                            children: [
                              ClipOval(
                                child: Container(
                                  color: boxBgColors,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset("assets/jewellery 1.png",height: 70,width: 70,),
                                  ),
                                ),
                              ),
                              Text("Jewellery",style: HomeIconsText,)
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height *0.06,),
                        Column(
                          children: [
                            ClipOval(
                              child: Container(
                                color: boxBgColors,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset("assets/clipboard 1.png",height: 70,width: 70,),
                                ),
                              ),
                            ),
                            Text("Cr DR Report",style: HomeIconsText,)
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height *0.06,),
                        Column(
                          children: [
                            ClipOval(
                              child: Container(
                                color: boxBgColors,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset("assets/annual-report 1.png",height: 70,width: 70,),
                                ),
                              ),
                            ),
                            Text("All Reports",style: HomeIconsText,)
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height *0.06,),
                        Column(
                          children: [
                            ClipOval(
                              child: Container(
                                color: boxBgColors,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset("assets/manufacturing 1.png",height: 75,width: 75,),
                                ),
                              ),
                            ),
                            Text("Supplier",style: HomeIconsText,)
                          ],
                        )

                      ],
                    ),

                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1
                )
              ],
            ),
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