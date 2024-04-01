import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../Constants/Globals.dart';
import '../Constants/Constants.dart';
import 'Active_Users.dart';
import 'FIrmList.dart';
import 'InActive_Users.dart';
import 'globals_Admkin.dart';



class UpdateFirm extends StatefulWidget {
  const UpdateFirm({super.key});

  @override
  _UpdateFirmState createState() => _UpdateFirmState();
}

class _UpdateFirmState extends State<UpdateFirm> {

  final TextEditingController firmController = TextEditingController();





  String conditionFirmID = "";
  Future<void> fetchFirmDetails(String documentId) async {
    try {
      // Reference to the document with the specified ID in the "Firms" subcollection
      DocumentReference firmDocRef = FirebaseFirestore.instance.collection('User').doc(documentId).collection('Firms').doc(globalfirmIDupdate);

      // Get the document snapshot
      DocumentSnapshot firmSnapshot = await firmDocRef.get();

      // Check if the document exists
      if (firmSnapshot.exists) {
        // Extract firm data
        Map<String, dynamic>? firmData = firmSnapshot.data() as Map<String, dynamic>?;

        if (firmData != null) {
          setState(() {
            // Access firm data such as FirmName
            firmController.text = firmData['FirmName'] ?? '';
            conditionFirmID = firmData['FirmName'] ?? '';
            statusController.text = firmData['FirmStatus'] ?? "";
            selectedStatus = firmData['FirmStatus'] ?? "";

            // Access other data as needed
            // For example, if 'SubExpiryDate' field exists and is not null
            if (firmData['FirmExpiryDate'] != null) {
              firmExpiryDate = (firmData['FirmExpiryDate'] as Timestamp).toDate();
            }
            print(firmExpiryDate);
          });
        } else {
          print('Firm data is null.');
        }
      } else {
        print('Firm with ID $documentId does not exist.');
      }
    } catch (e) {
      print('Error fetching firm details: $e');
    }
  }




  @override
  void initState() {
    super.initState();

    fetchFirmDetails(globalUserId);
    firmExpiryDate = DateTime.now();
    print("#######$globalUserId");
    print("#######$globalfirmIDupdate");
  }

  late DateTime firmExpiryDate;

  String? selectedStatus;
  TextEditingController statusController = TextEditingController();


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
        title: Text('Update Firm',style: TextStyle(color: allHeadingPrimeColor),),
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

            Container(
              width: double.infinity,
              child: ElevatedButton(
                style:  ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        allHeadingPrimeColor
                    )
                ),
                onPressed: () async {

                  String firmId = firmController.text;

                  Map<String, dynamic> firmData = {
                    'FirmName': firmId,
                    'FirmExpiryDate': firmExpiryDate,
                    'FirmStatus': selectedStatus,
                  };

                  if(conditionFirmID == firmId) {
                    await updateFirm(globalfirmIDupdate, firmData);
                    print("common");
                  } else {
                    await updateMainFirm(globalfirmIDupdate, firmData);
                    print("main");
                  }


                },
                child: Text('Update Firm',style: TextStyle(color: Colors.white),),
              ),
            ),



          ],
        ),
      ),
    );
  }

    Future<void> updateFirm( String firmId, Map<String, dynamic> updatedData) async {
    try {
      // Reference to the document for the specified user ID and firm ID in the "Firms" subcollection
      DocumentReference firmDocRef = FirebaseFirestore.instance.collection('User').doc(globalUserId).collection('Firms').doc(firmId);

      // Check if the document exists
      DocumentSnapshot firmSnapshot = await firmDocRef.get();
      if (firmSnapshot.exists) {
        // Update firm details
        await firmDocRef.update(updatedData);

        // Show success alert
        showAlert(context, 'Success', 'Firm updated successfully');

        // Navigate to another page after 2 seconds
        Future.delayed(Duration(seconds: 2), () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FirmList()));
        });

        print('Firm updated successfully');
      } else {
        print('Firm with ID $firmId under user with ID $globalUserId does not exist.');
      }
    } catch (e) {
      print('Error updating firm: $e');
    }
  }

  Future<void> updateMainFirm(String firmId, Map<String, dynamic> updatedData) async {
    try {
      // Reference to the document for the specified user ID and firm ID in the "Firms" subcollection
      DocumentReference firmDocRef = FirebaseFirestore.instance.collection('User').doc(globalUserId).collection('Firms').doc(firmId);

      // Check if the document exists
      DocumentSnapshot firmSnapshot = await firmDocRef.get();
      if (firmSnapshot.exists) {
        // Get the updated FirmName from the updatedData
        String newFirmName = updatedData['FirmName'] as String;

        // Reference to the new document with the updated FirmName
        DocumentReference newFirmDocRef = FirebaseFirestore.instance.collection('User').doc(globalUserId).collection('Firms').doc(newFirmName);

        // Check if the new document already exists
        DocumentSnapshot newFirmSnapshot = await newFirmDocRef.get();
        if (newFirmSnapshot.exists) {
          print('Firm with name $newFirmName already exists.');
          // You may handle this case as per your requirement, e.g., show an error message and return
        } else {
          // Update firm details
          await newFirmDocRef.set(updatedData); // Create the new document with the updated data
          await firmDocRef.delete(); // Delete the old document

          // Show success alert
          showAlert(context, 'Success', 'Firm updated successfully');

          // Navigate to another page after 2 seconds
          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const FirmList()));
          });

          print('Firm updated successfully');
        }
      } else {
        print('Firm with ID $firmId under user with ID $globalUserId does not exist.');
      }
    } catch (e) {
      print('Error updating firm: $e');
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
