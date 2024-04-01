import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Constants/Constants.dart';
import '../Constants/Globals.dart';
import 'Active_Users.dart';
import 'AddFirm.dart';
import 'Admin_Home.dart';
import 'FIrmList.dart';
import 'InActive_Users.dart';
import 'globals_Admkin.dart';

class UserDetail extends StatefulWidget {
  const UserDetail( {super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Future<void> fetchUserDetails(String userId) async {
  //   try {
  //     // Reference to the document for the specified user ID in the "User" collection
  //     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('User').doc(userId).get();
  //
  //     // Check if the document exists
  //     if (userSnapshot.exists) {
  //       // Extract user data
  //       Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
  //       setState(() {
  //         fnameController.text = userData['fname'] ?? "";
  //         lnameController.text = userData['lname'] ?? "";
  //         mobNoController.text = userData['phoneNumber'] ?? "";
  //         cityController.text = userData['city'] ?? "";
  //         statusController.text = userData['status'] ?? "";
  //         selectedStatus = userData['status'] ?? "";
  //         ownIdController.text = userData['ownerId'] ?? "";
  //         selectedOwnId = userData['ownerId'] ?? "";
  //         subExpiryDate = (userData['SubExpiryDate'] as Timestamp).toDate();
  //       });
  //       // You can access other fields here and perform desired actions
  //      // print('User ID: $userId, Status: $status, UserName: $userName');
  //     } else {
  //       print('User with ID $userId does not exist.');
  //     }
  //   } catch (e) {
  //     print('Error fetching user details: $e');
  //   }
  // }
  Future<void> fetchUserDetails(String userId) async {
    try {
      // Reference to the document for the specified user ID in the "User" collection
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('User').doc(userId).get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Extract user data
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          setState(() {
            fnameController.text = userData['fname'] ?? "";
            lnameController.text = userData['lname'] ?? "";
            mobNoController.text = userData['phoneNumber'] ?? "";
            cityController.text = userData['city'] ?? "";
            statusController.text = userData['status'] ?? "";
            selectedStatus = userData['status'] ?? "";
            ownIdController.text = userData['ownerId'] ?? "";
            selectedOwnId = userData['ownerId'] ?? "";

            // Check if 'SubExpiryDate' field exists and is not null
            if (userData['SubExpiryDate'] != null) {
              subExpiryDate = (userData['SubExpiryDate'] as Timestamp).toDate();
            }
          });
        } else {
          print('User data is null.');
        }
      } else {
        print('User with ID $userId does not exist.');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }


  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController mobNoController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController ownIdController = TextEditingController();
  late DateTime subExpiryDate;
  String? selectedStatus;
  String? selectedOwnId;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   fetchUserDetails(globalUserId);
  //   print("######################################$globalUserId");
  //   subExpiryDate = DateTime.now();
  // }
  @override
  void initState() {
    super.initState();
    if (globalUserId != null) {
      fetchUserDetails(globalUserId!);
      print("######################################$globalUserId");
    } else {
      print("Global user ID is null.");
    }
    subExpiryDate = DateTime.now();
  }

  Future<bool> onWillPop() async {
    if ( globalCheckPage == "Active"){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActiveUsersScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InActiveUsersScreen(),
        ),
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return   WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Access Panel",style: TextStyle(color: allHeadingPrimeColor),),
          elevation: 0,
          leading: IconButton(
            icon:   Icon(Icons.arrow_back_ios,color: allHeadingPrimeColor,), onPressed: () {
            Navigator.pop(context);
          },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15,),
                        TextField(
                          keyboardType: TextInputType.none,
                          controller: fnameController,
                          cursorColor: allHeadingPrimeColor,
                          style: const TextStyle(
                            color: Color(0xFF323232),
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            labelText: 'first Name',
                            labelStyle:  const TextStyle(
                              color: Colors.grey
                            ),
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: allHeadingPrimeColor, width: 0.3)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: allHeadingPrimeColor, width: 0.3)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: allHeadingPrimeColor, width: 0.3)),
                          ),
                        ),
                        SizedBox(height: 15,),
                        TextField(
                          keyboardType: TextInputType.none,
                          controller: lnameController,
                          cursorColor: allHeadingPrimeColor,
                          style: const TextStyle(
                            color: Color(0xFF323232),
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            labelStyle:  const TextStyle(
                                color: Colors.grey
                            ),
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: allHeadingPrimeColor, width: 0.3)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: allHeadingPrimeColor, width: 0.3)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: allHeadingPrimeColor, width: 0.3)),
                          ),
                        ),
                        SizedBox(height: 15,),
                        TextField(
                          keyboardType: TextInputType.none,
                          controller: mobNoController,
                          cursorColor: allHeadingPrimeColor,
                          style: const TextStyle(
                            color: Color(0xFF323232),
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Mob No',
                            labelStyle:  const TextStyle(
                                color: Colors.grey
                            ),
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: allHeadingPrimeColor, width: 0.3)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: allHeadingPrimeColor, width: 0.3)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: allHeadingPrimeColor, width: 0.3)),
                          ),
                        ),
                        SizedBox(height: 15,),
                        TextField(
                          keyboardType: TextInputType.none,
                          controller: cityController,
                          cursorColor: allHeadingPrimeColor,
                          style: const TextStyle(
                            color: Color(0xFF323232),
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            labelText: 'city',
                            labelStyle:  const TextStyle(
                                color: Colors.grey
                            ),
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: allHeadingPrimeColor, width: 0.3)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: allHeadingPrimeColor, width: 0.3)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: allHeadingPrimeColor, width: 0.3)),
                          ),
                        ),
                        SizedBox(height: 15,),

                        DropdownButtonFormField<String>(
                          value: selectedStatus,
                          onChanged: (newValue) {
                            setState(() {
                              selectedStatus = newValue;
                              statusController.text = newValue ?? '';
                            });
                          },
                          items: ['Active', 'Passive'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Status',
                            labelStyle: TextStyle(color: Colors.grey),
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: allHeadingPrimeColor, width: 0.3),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: allHeadingPrimeColor, width: 0.3),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: allHeadingPrimeColor, width: 0.3),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),

                        DropdownButtonFormField<String>(
                          value: selectedOwnId,
                          onChanged: (newValue) {
                            setState(() {
                              selectedOwnId = newValue;
                              ownIdController.text = newValue ?? '';
                            });
                          },
                          items: ['Admin', 'Jeweller' , 'Staff'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Owner ID',
                            labelStyle: TextStyle(color: Colors.grey),
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: allHeadingPrimeColor, width: 0.3),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: allHeadingPrimeColor, width: 0.3),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: allHeadingPrimeColor, width: 0.3),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                             border: Border.all(
                               color: allHeadingPrimeColor,
                               width: 0.3,
                             )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subscription Date: ${DateFormat('yyyy-MM-dd').format(subExpiryDate)}', // Format the date as needed
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    // Show date picker and wait for user input
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: subExpiryDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(DateTime.now().year + 1), // Limit date range to the next year
                                    );

                                    // Update subExpiryDate if a date was selected
                                    if (pickedDate != null) {
                                      setState(() {
                                        subExpiryDate = pickedDate;
                                      });
                                      print(subExpiryDate);
                                    }
                                  },
                                  icon: Icon(Icons.date_range_outlined),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 15,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                color: allHeadingPrimeColor,
                                width: 0.3,
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Firms', // Format the date as needed
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FirmList()));
                                  },
                                  icon: Icon(Icons.remove_red_eye),
                                ),
                              ],
                            ),
                          ),
                        ),





                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            allHeadingPrimeColor
                        )
                    ),
                    onPressed: () async {
                      String productId = globalUserId;
                      Map<String, dynamic> updatedData = {
                        'fname': fnameController.text,
                        'lname': lnameController.text,
                        'phoneNumber': mobNoController.text,
                        'city': cityController.text,
                        'status': statusController.text,
                        'ownerId': ownIdController.text,
                        'SubExpiryDate': subExpiryDate,
                      };

                      await updateProduct(productId, updatedData);
                    },
                    child: Text("Update",style: allButtonText,),

                  ),
                ),
              )
            ],
          ),
        ),


      ),
    );
  }
  Future<void> updateProduct(String productId, Map<String, dynamic> updatedData) async {
    try {
      DocumentSnapshot document = await firestore.collection('User').doc(productId).get();

      if (document.exists) {
        // Update user details
        await firestore.collection('User').doc(productId).update(updatedData);

        showAlert(context, 'Success', 'User updated successfully');

        // Navigate to a page after 2 seconds
        Future.delayed(Duration(seconds: 2), () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPanel()));
        });
        print('User updated successfully');
      } else {
        print('Document not found: $productId');
      }
    } catch (e) {
      print('Error updating user: $e');
    }
  }
  Future<void> showAlert(BuildContext context, String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dismiss dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

}
