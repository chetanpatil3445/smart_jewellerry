import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Constants/Globals.dart';

class StockDetailPage extends StatefulWidget {
  final String documentId;

  const StockDetailPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _StockDetailPageState createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  Map<String, dynamic>? stockData;

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    try {
      // Fetch the details of the item using the document ID
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(globalUserIdStored)
          .collection('Firms')
          .doc(globalFirmNameAllApp)
          .collection('stock')
          .doc(widget.documentId)
          .get();

      setState(() {
        stockData = documentSnapshot.data() as Map<String, dynamic>;
      });
    } catch (e) {
      print('Error fetching stock data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (stockData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      List<String> imageUrls = []; // Assuming the images are stored as URLs in Firestore
      if (stockData!['imageUrls'] != null) {
        imageUrls = (stockData!['imageUrls'] as List<dynamic>).cast<String>();
      }
      return Scaffold(
        appBar: AppBar(
          title: Text('Item Detail'),
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/BG4.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200, // Set the height of the carousel slider
                      child: CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 16 / 9, // Set the aspect ratio of the images
                          viewportFraction: 1, // Set the fraction of the viewport to display at once
                          autoPlay: true, // Enable auto play
                          autoPlayInterval: Duration(seconds: 3), // Set the auto play interval
                          autoPlayAnimationDuration: Duration(milliseconds: 800), // Set the duration of auto play animation
                        ),
                        items: imageUrls.map((imageUrl) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Image.network(
                                imageUrl ?? 'assets/images/NoImage.jpg', // Use placeholder image if URL is null
                                fit: BoxFit.cover,
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Gross Weight: ${stockData!['gross_weight']}'),
                    Text('Net Weight: ${stockData!['net_weight']}'),
                    // Add more Text widgets to display other details as needed
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
