import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../Constants/Globals.dart';
import '../Constants/Constants.dart';
import 'Active_Users.dart';
import 'FIrmList.dart';
import 'InActive_Users.dart';
import 'globals_Admkin.dart';



class AddFirmPage extends StatefulWidget {
  const AddFirmPage({super.key});

  @override
  _AddFirmPageState createState() => _AddFirmPageState();
}

class _AddFirmPageState extends State<AddFirmPage> {

  final TextEditingController firmController = TextEditingController();

  Future<void> AddFirm(String userId, String firmId, Map<String, dynamic> firmData) async {
    try {
      // Reference to the user's document in the "User" collection
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('User').doc(userId);

      // Reference to the "Firms" collection within the user's document
      CollectionReference firmCollectionRef = userDocRef.collection('Firms');

      // Set a document with the specified firm ID and data
      await firmCollectionRef.doc(firmId).set(firmData);
      showAlert(context, 'Success', 'Firm updated successfully');

      // Navigate to another page after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FirmList()));
      });
      print('Firm added successfully.');
    } catch (e) {
      print('Error adding firm: $e');
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

  late Future<List<String>> _firmListFuture;
  @override
  void initState() {
    super.initState();
    _firmListFuture = getFirmList(globalUserId);
    firmExpiryDate = DateTime.now();
  }

  late DateTime firmExpiryDate;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: allHeadingPrimeColor,),
        ),
        elevation: 0,
        title: Text('Add Firm',style: TextStyle(color: allHeadingPrimeColor),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            TextField(
              controller: firmController,
              cursorColor: allHeadingPrimeColor,
              style: const TextStyle(
                color: Color(0xFF323232),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                labelText: 'firm',
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
            SizedBox(height: 16),
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
                      'Subscription Date: ${DateFormat('yyyy-MM-dd').format(firmExpiryDate)}', // Format the date as needed
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed: () async {
                        // Show date picker and wait for user input
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: firmExpiryDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 1), // Limit date range to the next year
                        );

                        // Update subExpiryDate if a date was selected
                        if (pickedDate != null) {
                          setState(() {
                            firmExpiryDate = pickedDate;
                          });
                          print(firmExpiryDate);
                        }
                      },
                      icon: Icon(Icons.date_range_outlined),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style:  ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    allHeadingPrimeColor
                  )
                ),
                onPressed: () {
                  String userId = globalUserId;
                  String firmId = firmController.text;

                  Map<String, dynamic> firmData = {
                    'FirmName': firmId,
                    'FirmExpiryDate': firmExpiryDate,
                    'FirmStatus': 'Active',
                  };

                  AddFirm(userId, firmId, firmData);
                },
                child: Text('Add Firm',style: TextStyle(color: Colors.white),),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
