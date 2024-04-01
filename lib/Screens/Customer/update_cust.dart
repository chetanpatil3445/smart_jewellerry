import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../Constants/Constant_Buttons.dart';
import '../../Constants/Constant_Textfield.dart';
import '../../Constants/Constants.dart';
import '../../Constants/Globals.dart';
import '../../Controllers/AddCustomer_Controller.dart';

class UpdateCustomer extends StatefulWidget {
  const UpdateCustomer({super.key});

  @override
  State<UpdateCustomer> createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
  AddCustControllers controller = AddCustControllers();
  File? _image;
  String imageURL = "";

  Future<void> _getCustomerData() async {
    try {
      // Reference to the customer document using the provided document ID
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(globalUserIdStored)
          .collection('Firms')
          .doc(globalFirmNameAllApp)
          .collection('Customer')
          .doc(globalUserID)
          .get();

      if (customerSnapshot.exists) {
        // Retrieve customer data and set it to the controllers
        Map<String, dynamic> customerData = customerSnapshot.data() as Map<String, dynamic>;
        setState(() {
          imageURL = customerData['user_imageUrl'];
          controller.fnameController.text = customerData['user_fname'];
          controller.lnameController.text = customerData['user_lname'];
          controller.mobNoController.text = customerData['user_mobile'];
          controller.emailController.text = customerData['user_email'];
          controller.countryController.text = customerData['user_country'];
          controller.stateController.text = customerData['user_state'];
          controller.cityController.text = customerData['user_city'];
          controller.adharController.text = customerData['user_adhar'];
          controller.panController.text = customerData['user_pan'];

          // Set other fields as needed
        });
      } else {
        print('Customer not found.');
        // Handle case where customer is not found
      }
    } catch (e) {
      print('Error getting customer data: $e');
      // Handle error
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCustomerData();
  }
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
                         width: 100,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(50),
                         ),
                          child: _image != null
                              ? ClipOval(child: Image.file(_image!))
                              : ClipOval(child: CachedNetworkImage(
                            placeholder: (context, url) => CircularProgressIndicator(), // Circular progress indicator as a placeholder
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            imageUrl: imageURL, fit: BoxFit.cover,)),
                        ),
                      ),

                      Gap(30),
                      TextField(
                        controller: controller.fnameController,
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
                    if(fname.isNotEmpty && lname.isNotEmpty ){
                      _uploadAndSaveData();
                    } else{
                      showValid();
                    }

                  },
                  child: const Text(
                    "Update",
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
        'images/$globalJewellerName/$globalFirmNameAllApp/Customer/${DateTime.now().millisecondsSinceEpoch}.jpg');
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
        await addToCustomer(globalUserID ,globalUserIdStored, stockData);
      } else {
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
          'user_imageUrl': imageURL,
        };
        await addToCustomer(globalUserID ,globalUserIdStored, stockData);
        // Handle case where image is not selected
        // You may choose to show an error message or handle it in any other way
      }
    } catch (e) {
      print('Error adding stock data: $e');
      // Handle error
    }
  }

  Future<void> addToCustomer(String globalUserID , String userId, Map<String, dynamic> stockData) async {
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
      await stockCollectionRef.doc(globalUserID).set(stockData);

      print('Stock data added successfully.');
    } catch (e) {
      print('Error adding stock data: $e');
    }
  }

}
