import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../Constants/Constant_Textfield.dart';
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


  Future<void> _getImage(ImageSource source, int index) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImage(File image) async {
    Reference ref = FirebaseStorage.instance.ref().child('images/$globalJewellerName/$globalFirmNameAllApp/stock/${DateTime.now().millisecondsSinceEpoch}.jpg');
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _uploadAndSaveData() async {
    String prodName = productNameController.text;
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
        'Prod_Name': prodName,
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
                              cursorColor: allHeadingPrimeColor,
                              style: allTextStyle,
                              decoration: customInputDecoration('Category'),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: quantityController,
                              style: allTextStyle,
                              keyboardType: TextInputType.number,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Quantity'),
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
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Gross Wt'),
                             ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: lessWeightController,
                              keyboardType: TextInputType.number,
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Less Wt'),
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
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Net WT'),
                             ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: productNameController,
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Item Name'),
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
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Purity'),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: wastageController,
                              keyboardType: TextInputType.number,
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Wastage'),
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
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Fine Wt'),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: finalPurityController,
                              keyboardType: TextInputType.number,
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Final Purity'),
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
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Final Fine Wt'),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: otherChrgController,
                              keyboardType: TextInputType.number,
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Other Charges'),
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
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Valuation'),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: fixPriceController,
                              keyboardType: TextInputType.number,
                              style: allTextStyle,
                              cursorColor: allHeadingPrimeColor,
                              decoration: customInputDecoration('Fix Price'),
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
                        children: List.generate(3,
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
                  // onPressed: () {
                  //   _uploadAndSaveData();
                  // },
                  onPressed: () {
                    bool allImagesSelected = _images.every((image) => image != null);
                    if (allImagesSelected) {
                      _uploadAndSaveData();
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Alert"),
                            content: Text("Please select all 3 images."),
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
                  },
                  child: Text('Add Stock '),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
