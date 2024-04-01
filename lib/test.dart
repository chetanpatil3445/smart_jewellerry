// Future<void> addToStock(String userId, Map<String, dynamic> stockData) async {
//   try {
//     // Reference to the user's document in the "User" collection
//     DocumentReference userDocRef = FirebaseFirestore.instance.collection('User').doc(userId);
//
//     // Reference to the "Firms" collection within the user's document
//     // Assuming "Firms" is a subcollection of the user's document
//     CollectionReference firmsCollectionRef = userDocRef.collection('Firms');
//
//     // Reference to the "test" document within the "Firms" collection
//     // Change 'test' to the specific document ID if it's not always 'test'
//     DocumentReference testDocRef = firmsCollectionRef.doc(globalFirmNameAllApp);
//
//     // Reference to the "stock" subcollection within the "test" document
//     CollectionReference stockCollectionRef = testDocRef.collection('stock');
//
//     // Add a document within the "stock" subcollection with the provided data
//     await stockCollectionRef.add(stockData);
//
//     print('Stock data added successfully.');
//   } catch (e) {
//     print('Error adding stock data: $e');
//   }
// }



import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../Constants/Constants.dart';
import '../../Constants/Globals.dart';
import 'dart:io';



class AddStock extends StatefulWidget {
  const AddStock({super.key});

  @override
  _AddStockState createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController grossWeightController = TextEditingController();
  final TextEditingController lessWeightController = TextEditingController();
  final TextEditingController netWeightController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController purityController = TextEditingController();
  final TextEditingController wastageController = TextEditingController();
  final TextEditingController fineWtController = TextEditingController();
  final TextEditingController finalPurityController = TextEditingController();
  final TextEditingController finalFineWtController = TextEditingController();
  final TextEditingController otherChrgController = TextEditingController();
  final TextEditingController valuationController = TextEditingController();
  final TextEditingController fixPriceController = TextEditingController();
  File? _image;
  List<File?> _images = [null, null, null];

  // Future<void> _getImage(ImageSource source) async {
  //   final pickedFile = await ImagePicker().pickImage(source: source);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  // Future<String> uploadImage(File image) async {
  //   Reference ref = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
  //   UploadTask uploadTask = ref.putFile(image);
  //   TaskSnapshot taskSnapshot = await uploadTask;
  //   return await taskSnapshot.ref.getDownloadURL();
  // }


  // Future<void> _uploadAndSaveData() async {
  //   String grossWeight = grossWeightController.text;
  //   String netWeight = netWeightController.text;
  //   String quantity = quantityController.text;
  //   String valuation = valuationController.text;
  //
  //   // Validate inputs
  //   if (grossWeight.isEmpty || netWeight.isEmpty || quantity.isEmpty || valuation.isEmpty) {
  //     // Show error message or handle validation as per your requirement
  //     return;
  //   }
  //
  //   try {
  //     // Upload image to Firebase Storage
  //     if (_image != null) {
  //       String imageUrl = await uploadImage(_image!);
  //
  //       // Add stock data to Firestore
  //       Map<String, dynamic> stockData = {
  //         'gross_weight': grossWeight,
  //         'net_weight': netWeight,
  //         'quantity': quantity,
  //         'valuation': valuation,
  //         'imageUrl': imageUrl,
  //       };
  //
  //       // Replace 'userId' with your user ID logic
  //       await addToStock(globalUserIdStored, stockData);
  //     } else {
  //       // Handle case where image is not selected
  //       // You may choose to show an error message or handle it in any other way
  //     }
  //   } catch (e) {
  //     print('Error adding stock data: $e');
  //     // Handle error
  //   }
  // }
  //
  //
  // Future<void> addToStock(String userId, Map<String, dynamic> stockData) async {
  //   try {
  //     // Reference to the user's document in the "User" collection
  //     DocumentReference userDocRef = FirebaseFirestore.instance.collection('User').doc(userId);
  //
  //     // Reference to the "Firms" collection within the user's document
  //     CollectionReference firmsCollectionRef = userDocRef.collection('Firms');
  //
  //     // Reference to the "test" document within the "Firms" collection
  //     DocumentReference testDocRef = firmsCollectionRef.doc(globalFirmNameAllApp);
  //
  //     // Reference to the "stock" subcollection within the "test" document
  //     CollectionReference stockCollectionRef = testDocRef.collection('stock');
  //
  //     // Add a document within the "stock" subcollection with the provided data
  //     await stockCollectionRef.add(stockData);
  //
  //     print('Stock data added successfully.');
  //   } catch (e) {
  //     print('Error adding stock data: $e');
  //   }
  // }

  Future<void> _getImage(ImageSource source, int index) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImage(File image) async {
    Reference ref = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _uploadAndSaveData() async {
    String grossWeight = grossWeightController.text;
    String netWeight = netWeightController.text;
    String quantity = quantityController.text;
    String valuation = valuationController.text;

    // Validate inputs
    if (grossWeight.isEmpty || netWeight.isEmpty || quantity.isEmpty || valuation.isEmpty) {
      // Show error message or handle validation as per your requirement
      return;
    }

    try {
      List<String> imageUrls = [];

      // Upload each image to Firebase Storage
      for (int i = 0; i < 3; i++) {
        if (_images[i] != null) {
          String imageUrl = await uploadImage(_images[i]!);
          imageUrls.add(imageUrl);
        } else {
          // Handle case where image is not selected
          // You may choose to show an error message or handle it in any other way
          imageUrls.add(''); // Add an empty string as a placeholder for non-selected images
        }
      }

      // Add stock data to Firestore
      Map<String, dynamic> stockData = {
        'gross_weight': grossWeight,
        'net_weight': netWeight,
        'quantity': quantity,
        'valuation': valuation,
        'imageUrls': imageUrls,
      };

      // Replace 'userId' with your user ID logic
      await addToStock(globalUserIdStored, stockData);
    } catch (e) {
      print('Error adding stock data: $e');
      // Handle error
    }
  }

  Future<void> addToStock(String userId, Map<String, dynamic> stockData) async {
    try {
      // Reference to the user's document in the "User" collection
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('User').doc(userId);

      // Reference to the "Firms" collection within the user's document
      CollectionReference firmsCollectionRef = userDocRef.collection('Firms');

      // Reference to the "test" document within the "Firms" collection
      DocumentReference testDocRef = firmsCollectionRef.doc(globalFirmNameAllApp);

      // Reference to the "stock" subcollection within the "test" document
      CollectionReference stockCollectionRef = testDocRef.collection('stock');

      // Add a document within the "stock" subcollection with the provided data
      await stockCollectionRef.add(stockData);

      print('Stock data added successfully.');
    } catch (e) {
      print('Error adding stock data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Stock'),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/BG1.png"),
              fit: BoxFit.cover,
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: categoryController,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Category',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: quantityController,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Quantity',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),


                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: grossWeightController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Gross Weight',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: lessWeightController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Less Weight',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: netWeightController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Net Weight',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: productNameController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Item Name',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: purityController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Purity',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: wastageController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Wastage',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: fineWtController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Fine Wt',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: finalPurityController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'FInal Purity',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: finalFineWtController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Final Fine Wt',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: otherChrgController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Other Charges',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: valuationController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Valuation',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: fixPriceController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Fix Price',
                                labelStyle:  const TextStyle(
                                    color: Colors.grey
                                ),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide:   BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                        color: allHeadingPrimeColor, width: 0.3)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),

                      SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Add Stone"),
                              SizedBox(height: 15,),
                              Container(
                                child:  SizedBox(height : 70 , child: Image.asset("assets/diamond.png")),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),

                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          3,
                              (index) => Expanded(
                            child: InkWell(
                              onTap: () => _getImage(ImageSource.gallery, index),
                              child: Container(
                                height: 80,
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                //color: Colors.grey[300],
                                child: _images[index] != null
                                    ? Image.file(_images[index]!)
                                    : Image.asset("assets/addImg.png"),
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                      ),


                      SizedBox(height: 20.0),

                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // String userId = globalUserIdStored; // Use the global user ID variable
                    // double grossWeight = double.tryParse(grossWeightController.text) ?? 0;
                    // double netWeight = double.tryParse(netWeightController.text) ?? 0;
                    // int quantity = int.tryParse(quantityController.text) ?? 0;
                    // double valuation = double.tryParse(valuationController.text) ?? 0;
                    //
                    // Map<String, dynamic> stoneData = {
                    //   'gross_weight': grossWeight,
                    //   'net_weight': netWeight,
                    //   'quantity': quantity,
                    //   'valuation': valuation,
                    //   // Add other fields as needed
                    // };
                    // Map<String, dynamic> stockData = {
                    //   'gross_weight': grossWeight,
                    //   'net_weight': netWeight,
                    //   'quantity': quantity,
                    //   'valuation': valuation,
                    //   'stoneData': stoneData,
                    //   // Add other fields as needed
                    // };

                    //addToStock(userId, stockData);
                    _uploadAndSaveData();
                  },
                  child: Text('Add Stock Data'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}





class StockListTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock List'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          // Example data for each item
          String imageUrl = 'https://via.placeholder.com/150'; // Example image URL
          double price = 100.0; // Example price
          String title = 'Item $index'; // Example title

          return GridItem(
            imageUrl: imageUrl,
            price: price,
            title: title,
          );
        },
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final String imageUrl;
  final double price;
  final String title;

  GridItem({
    required this.imageUrl,
    required this.price,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '\$$price',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

