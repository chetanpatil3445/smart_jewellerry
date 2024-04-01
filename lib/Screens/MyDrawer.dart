import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_jewellerry/Constants/Constants.dart';

import '../Constants/Globals.dart';
import 'Homepage.dart';



 class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  late Future<List<String>> _firmListFuture;
  String? _selectedFirm;

  Future<List<String>> getFirmList(String userId) async {
    try {
      // Reference to the user's document in the "User" collection
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('User').doc(userId);

      // Reference to the "Firms" collection within the user's document
      CollectionReference firmCollectionRef = userDocRef.collection('Firms');

      // Get all documents (firms) within the "Firms" collection
      QuerySnapshot firmSnapshot = await firmCollectionRef.get();

      // Extract document IDs (firm names) from the snapshot
      List<String> firmList = [];
      firmSnapshot.docs.forEach((firmDoc) {
        firmList.add(firmDoc.id);
      });

      return firmList;
    } catch (e) {
      print('Error retrieving firm list: $e');
      return [];
    }
  }



  Future<void> _saveFirmNameSharedPreferences(String firmId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firmId', firmId);
  }

  // my profile details

  String userName = "" ;
  String city = "" ;
  String mobNo = "" ;
  String Identity = "" ;
  Future<void> fetchUserDetails(String userId) async {
    try {
      // Reference to the document for the specified user ID in the "User" collection
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('User').doc(userId).get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Extract user data
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          city = userData['city'];
          mobNo = userData['phoneNumber'];
          Identity = userData['ownerId'];
          userName = userData['fname'] + ' ' + userData['lname'];
         });
         // You can access other fields here and perform desired actions
       } else {
        print('User with ID $userId does not exist.');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserDetails(globalUserIdStored);
    _firmListFuture = getFirmList(globalUserIdStored);
    if(globalFirmNameAllApp.isNotEmpty){
      _selectedFirm = globalFirmNameAllApp ;
    }
    firmExpiryDate = DateTime.now();
  }

  // expired date by firm

  Future<void> fetchFirmDetails(String FirmIDName) async {
    try {
      // Reference to the document with the specified ID in the "Firms" subcollection
      DocumentReference firmDocRef = FirebaseFirestore.instance.collection('User').doc(globalUserIdStored).collection('Firms').doc(FirmIDName);

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
            print(firmExpiryDate);
            print(globalFirmCheckExp);
          });
        } else {
          print('Firm data is null.');
        }
      } else {
        print('Firm with ID $FirmIDName does not exist.');
      }
    } catch (e) {
      print('Error fetching firm details: $e');
    }
  }
  late DateTime firmExpiryDate;



  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: PrimeColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              //  height: 150,

              width: double.infinity,
              decoration: BoxDecoration(
                color: PrimeColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
              ),

              child:Padding(
                padding: const EdgeInsets.only(top: 8.0 ,bottom: 8),
                child: ListTile(
                  horizontalTitleGap: -5,
                  leading: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "http://www.nicesnippets.com/demo/profile-1.jpg"),
                    ),
                  ),
                  title: Text(
                    userName,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  minVerticalPadding: 10,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        "$city  $mobNo",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5),
                      Text(
                        Identity,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: ListView(
                    children: [


                      Container(

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder(
                            future: _firmListFuture,
                            builder: (context, AsyncSnapshot<List<String>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                List<String> firmList = snapshot.data ?? [];
                                if (firmList.isEmpty) {
                                  return Text('No firms found.');
                                }
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.3,
                                      color: allHeadingPrimeColor,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(6))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: DropdownButtonFormField<String>(
                                      decoration:   InputDecoration(
                                        enabledBorder: InputBorder.none,

                                      ),
                                      value: _selectedFirm,
                                      hint: Text('Select Firm'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedFirm = newValue;
                                          globalFirmNameAllApp = newValue!;
                                        });
                                        fetchFirmDetails(_selectedFirm!);
                                        _saveFirmNameSharedPreferences(globalFirmNameAllApp);
                                        print("##########$globalFirmNameAllApp");
                                      },
                                      items: firmList.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),

                      ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStatePropertyAll(0),
                            backgroundColor: MaterialStatePropertyAll(
                                Colors.white
                            )
                        ),
                        onPressed: () {},
                        child:ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Homepage()));
                          },
                          splashColor: Colors.grey,
                          leading: Image.asset(
                            "assets/list.png",
                            color: AllTextColor,
                            fit: BoxFit.cover,
                            height: 25,
                            width: 25,
                          ),
                          title: Text(
                            'Home',
                            style: TextStyle(
                                color: AllTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14
                            ),
                          ),
                        ), ),



                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
