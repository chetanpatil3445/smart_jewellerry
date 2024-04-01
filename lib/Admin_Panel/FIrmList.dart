import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../Constants/Globals.dart';
import '../Constants/Constants.dart';
import 'Active_Users.dart';
import 'AddFirm.dart';
import 'Admin_Home.dart';
import 'InActive_Users.dart';
import 'UpdateFirm.dart';
import 'User_Details.dart';
import 'globals_Admkin.dart';


class FirmList extends StatefulWidget {
  const FirmList({super.key});

  @override
  _FirmListState createState() => _FirmListState();
}

class _FirmListState extends State<FirmList> {
  late Future<List<String>> _firmListFuture;



  Future<List<Map<String, dynamic>>> getStockData(String userId) async {
    List<Map<String, dynamic>> stockDataList = [];

    try {
      // Reference to the user's document in the "User" collection
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('User').doc(userId);

      // Reference to the "stock" subcollection within the user's document
      CollectionReference stockCollectionRef = userDocRef.collection('Firms');

      // Get all documents from the "stock" subcollection
      QuerySnapshot querySnapshot = await stockCollectionRef.get();

      // Extract data from each document and add it to the list
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? stockData =
            doc.data() as Map<String, dynamic>?; // Convert to nullable Map
        if (stockData != null) {
          stockDataList.add(stockData);
        }
      });

      return stockDataList;
    } catch (e) {
      print('Error fetching stock data: $e');
      return stockDataList; // Return empty list on error
    }
  }

  @override
  void initState() {
    super.initState();
     firmExpiryDate = DateTime.now();
  }

  late DateTime firmExpiryDate;

  Future<bool> onWillPop() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetail(),
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Firm List'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFirmPage(),
                    ),
                  );
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: getStockData(globalUserId), // Replace with actual user ID
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Map<String, dynamic>> stockDataList = snapshot.data!;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: stockDataList.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> stockData = stockDataList[index];

                          return GestureDetector(
                            onTap: () {
                              globalfirmIDupdate = stockData['FirmName'] ?? "";
                              Navigator.push (
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateFirm(),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 0,
                              color: PrimeColor,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0 , bottom: 20 , left: 15 , right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${stockData['FirmName']}'),

                                    Row(
                                      children: [

                                        Text('${stockData['FirmStatus'] ?? ""}'),
                                        SizedBox(width: 15,),

                                        Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: stockData['FirmStatus'] == 'Active' ? Colors.green : Colors.red,
                                            borderRadius: BorderRadius.all(Radius.circular(50)),
                                          ),
                                        ),

                                      ],
                                    ),

                                    // Display other fields as needed
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
