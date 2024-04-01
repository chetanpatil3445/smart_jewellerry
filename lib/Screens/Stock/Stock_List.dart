import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_jewellerry/Constants/Constants.dart';
import 'package:smart_jewellerry/Constants/Globals.dart';

import 'StockDetail.dart';


class StockList extends StatefulWidget {
  const StockList({super.key});

  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  late Future<List<Map<String, dynamic>>> _stockListFuture;

  @override
  void initState() {
    super.initState();
    _stockListFuture = getStockList(globalUserIdStored, globalFirmNameAllApp); // Replace with actual user ID and firm name
  }

  // Future<List<Map<String, dynamic>>> getStockList(String userId, String firmName) async {
  //   try {
  //     // Reference to the user's document in the "User" collection
  //     DocumentReference userDocRef = FirebaseFirestore.instance.collection('User').doc(userId);
  //
  //     // Reference to the "Firms" collection within the user's document
  //     CollectionReference firmsCollectionRef = userDocRef.collection('Firms');
  //
  //     // Reference to the specific document within the "Firms" collection
  //     DocumentReference firmDocRef = firmsCollectionRef.doc(firmName);
  //
  //     // Reference to the "stock" subcollection within the specific document
  //     CollectionReference stockCollectionRef = firmDocRef.collection('stock');
  //
  //     // Get the documents from the "stock" subcollection
  //     QuerySnapshot snapshot = await stockCollectionRef.get();
  //
  //     // Convert each document to a Map<String, dynamic>
  //     List<Map<String, dynamic>> stockList = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  //
  //     return stockList;
  //   } catch (e) {
  //     print('Error getting stock data: $e');
  //     return [];
  //   }
  // }
  Future<List<Map<String, dynamic>>> getStockList(String userId, String firmName) async {
    try {
      // Reference to the user's document in the "User" collection
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('User').doc(userId);

      // Reference to the "Firms" collection within the user's document
      CollectionReference firmsCollectionRef = userDocRef.collection('Firms');

      // Reference to the specific document within the "Firms" collection
      DocumentReference firmDocRef = firmsCollectionRef.doc(firmName);

      // Reference to the "stock" subcollection within the specific document
      CollectionReference stockCollectionRef = firmDocRef.collection('stock');

      // Get the documents from the "stock" subcollection
      QuerySnapshot snapshot = await stockCollectionRef.get();

      // Convert each document to a Map<String, dynamic> and include the document ID
      List<Map<String, dynamic>> stockList = [];
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id; // Add the document ID to the map
        stockList.add(data);
      });

      return stockList;
    } catch (e) {
      print('Error getting stock data: $e');
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jewellery Panel",style: TextStyle(color: allHeadingPrimeColor),),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/BG4.png"),
              fit: BoxFit.cover,
            )),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _stockListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<Map<String, dynamic>> stockList = snapshot.data ?? [];
              if (stockList.isEmpty) {
                return Center(
                  child: Text('No data found'),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,

                      ),
                      itemCount: stockList.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> stockData = stockList[index];
                        List<String> imageUrls = [];
                        if (stockData['imageUrls'] != null) {
                          imageUrls = (stockData['imageUrls'] as List<dynamic>).cast<String>();
                        }
                        if (index % 2 == 0) {
                          // For even indices, show one design
                          return GestureDetector(
                            onTap: () {
                              if (stockList[index].containsKey('documentId')) {
                                String documentId = stockList[index]['documentId']; // Assuming each map contains a key 'documentId' representing the document ID
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StockDetailPage(documentId: documentId),
                                  ),
                                );
                              } else {
                                print('Document ID not found in the map.');
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      if (imageUrls.isNotEmpty)
                                        Container(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Container(
                                              width: double.infinity,
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrls[0],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (imageUrls.isEmpty)
                                        Container(
                                          child: Image.asset(
                                            'assets/images/NoImage.jpg',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        width: double.infinity,
                                        color:  Color(0x5FEEB9C0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('₹${stockData['valuation']}',style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w500),),
                                              Text('${stockData['Prod_Name'] ?? ""}',style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w400)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          // For odd indices, show another design
                          return GestureDetector(
                            onTap: () {
                              if (stockList[index].containsKey('documentId')) {
                                String documentId = stockList[index]['documentId']; // Assuming each map contains a key 'documentId' representing the document ID
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StockDetailPage(documentId: documentId),
                                  ),
                                );
                              } else {
                                print('Document ID not found in the map.');
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        width: double.infinity,
                                        color:  Color(0x5FEEB9C0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('₹${stockData['valuation']}',style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w500),),
                                              Text('${stockData['Prod_Name'] ?? ""}',style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w400)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      if (imageUrls.isNotEmpty)
                                        Container(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Container(
                                              width: double.infinity,
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrls[0],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (imageUrls.isEmpty)
                                        Container(
                                          child: Image.asset(
                                            'assets/images/NoImage.jpg',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          );
                        }
                      },
                    ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}