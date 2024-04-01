import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Constants/Constant_Buttons.dart';
import '../../Constants/Constant_Textfield.dart';
import '../../Constants/Constants.dart';
import 'package:gap/gap.dart';
import 'dart:io';
import '../../Constants/Globals.dart';
import '../../Controllers/AddCustomer_Controller.dart';
import 'Customer_List.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  AddCustControllers controller = AddCustControllers();
  File? _image;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImage(File image) async {
    Reference ref = FirebaseStorage.instance.ref().child(
        'images/$globalJewellerName/$globalFirmNameAllApp/Customer/$CustName${DateTime.now().millisecondsSinceEpoch}.jpg');
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _uploadAndSaveData() async {
    String fname = controller.fnameController.text;
    String lname = controller.lnameController.text;
    String mobile = controller.mobNoController.text;
    String email = controller.emailController.text;
    String country = controller.countryController.text;
    String state = controller.stateController.text;
    String city = controller.cityController.text;
    String adhar = controller.adharController.text;
    String pan = controller.panController.text;

    // String usermob = mobile.substring(mobile.length - 4);
    String UserID = fname+"_"+email;


    // Validate inputs
    if (fname.isEmpty ||
        lname.isEmpty ||
        mobile.isEmpty ||
        email.isEmpty) {
      // Show error message or handle validation as per your requirement
      return;
    }

    try {
      // Upload image to Firebase Storage
      if (_image != null) {
        String imageUrl = await uploadImage(_image!);

        // Add stock data to Firestore
        Map<String, dynamic> stockData = {
          'user_fname': fname,
          'user_lname': lname,
          'user_mobile': mobile,
          'user_email': email,
          'user_country': country,
          'user_state': state,
          'user_city': city,
          'user_adhar': adhar,
          'user_pan': pan,
          'user_imageUrl': imageUrl,
        };

        // Replace 'userId' with your user ID logic
        await addToCustomer(UserID ,globalUserIdStored, stockData);
      } else {
        // Handle case where image is not selected
        // You may choose to show an error message or handle it in any other way
      }
    } catch (e) {
      print('Error adding stock data: $e');
      // Handle error
    }
  }

  Future<void> addToCustomer(String UserID , String userId, Map<String, dynamic> stockData) async {
    try {
      // Reference to the user's document in the "User" collection
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('User').doc(userId);

      // Reference to the "Firms" collection within the user's document
      CollectionReference firmsCollectionRef = userDocRef.collection('Firms');

      // Reference to the "test" document within the "Firms" collection
      DocumentReference testDocRef = firmsCollectionRef.doc(globalFirmNameAllApp);

      // Reference to the "stock" subcollection within the "test" document
      CollectionReference stockCollectionRef = testDocRef.collection('Customer');

      // Add a document within the "stock" subcollection with the provided data
     // await stockCollectionRef.add(stockData);
      await stockCollectionRef.doc(UserID).set(stockData);
      showSuc();
      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerList(),));

      print('Stock data added successfully.');
    } catch (e) {
      print('Error adding stock data: $e');
    }
  }
  String CustName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/BG1.png"),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Gap(15),
                      
                      InkWell(
                        onTap: () => _getImage(
                          ImageSource.gallery,
                        ),
                        child: Container(
                            height: 100,
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          //color: Colors.grey[300],
                          child: _image != null
                              ? ClipOval(child: Image.file(_image!))
                              : ClipOval(child: Image.asset("assets/addImg.png")),
                          alignment: Alignment.center,
                        ),
                      ),
                      
                      Gap(30),
                      TextField(
                        controller: controller.fnameController,
                        onChanged: (value) {
                          CustName = value ;
                        },
                        style: allTextStyle,
                        cursorColor: allHeadingPrimeColor,
                        decoration: customInputDecoration('First Name'),
                      ),
                      Gap(15),
                      TextField(
                        controller: controller.lnameController,
                        style: allTextStyle,
                        cursorColor: allHeadingPrimeColor,
                        decoration: customInputDecoration('Last Name'),
                      ),
                      Gap(15),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: controller.mobNoController,
                        style: allTextStyle,
                        cursorColor: allHeadingPrimeColor,
                        decoration: customInputDecoration('Mobile Number'),
                      ),
                      Gap(15),
                      TextField(
                        controller: controller.emailController,
                        style: allTextStyle,
                        cursorColor: allHeadingPrimeColor,
                        decoration: customInputDecoration('Email'),
                      ),
                      Gap(15),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.countryController,
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Country'),
                            ),
                          ),
                          Gap(15),
                          Expanded(
                            child: TextField(
                              controller: controller.stateController,
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('State'),
                            ),
                          ),
                        ],
                      ),
                      Gap(15),
                      TextField(
                        controller: controller.cityController,
                        style: allTextStyle,
                        cursorColor: allHeadingPrimeColor,
                        decoration: customInputDecoration('City'),
                      ),
                      Gap(15),
                      TextField(
                        controller: controller.adharController,
                        style: allTextStyle,
                        cursorColor: allHeadingPrimeColor,
                        decoration: customInputDecoration('Adhar Card No'),
                      ),
                      Gap(15),
                      TextField(
                        controller: controller.panController,
                        style: allTextStyle,
                        cursorColor: allHeadingPrimeColor,
                        decoration: customInputDecoration('Pan Card No'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: allButtonColor,
                  onPressed: () {
                    bool allImagesSelected = _image != null ;
                    String fname = controller.fnameController.text;
                    String lname = controller.lnameController.text;
                    if(fname.isNotEmpty && lname.isNotEmpty && allImagesSelected == true){
                      _uploadAndSaveData();
                    } else{
                      showValid();
                    }

                  },
                  child: const Text(
                    "Submit",
                    style: allButtonTexts,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void showValid() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text("Please select image."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
  void showSuc() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          backgroundColor: Colors.green,
          content: Text("Customer Added Success"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
