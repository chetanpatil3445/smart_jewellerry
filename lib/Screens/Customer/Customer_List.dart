import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_jewellerry/Constants/Globals.dart';
import 'package:smart_jewellerry/Screens/Customer/update_cust.dart';
import '../../Constants/Constants.dart';
import 'Add_Customer.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  late Future<List<Map<String, dynamic>>> _futureCustomersData;
  late List<Map<String, dynamic>> customersData;
  @override
  void initState() {
    super.initState();
    _futureCustomersData = getDataCustomer(globalUserIdStored, globalFirmNameAllApp);
  }

  Future<List<Map<String, dynamic>>> getDataCustomer(String userId, String firmName) async {
    try {
      // Reference to the "Customer" collection under the specified user and firm
      CollectionReference customerCollectionRef = FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('Firms')
          .doc(firmName)
          .collection('Customer');

      // Get all documents from the "Customer" collection
      QuerySnapshot querySnapshot = await customerCollectionRef.get();

      // Map the data of each document into a List<Map<String, dynamic>>
      List<Map<String, dynamic>> customersData = querySnapshot.docs.map((doc) {
        // Add the document ID to the customer data
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      return customersData;
    } catch (e) {
      print('Error getting customer data: $e');
      // Handle error
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
           onPressed: () {

           },
           icon: Icon(Icons.arrow_back_ios,color: allHeadingPrimeColor,),
        ),
        elevation: 0,
        title: Text('Customers List',style: TextStyle(color: allHeadingPrimeColor),),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddCustomer(),));
          }, icon: Icon(Icons.add,color: allHeadingPrimeColor,))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/BG1.png"),
              fit: BoxFit.cover,
            )),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureCustomersData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            List<Map<String, dynamic>> customersData = snapshot.data ?? [];

            if (customersData.isEmpty) {
              return Center(child: Text('No customers found.'));
            }

            return ListView.builder(
              itemCount: customersData.length,
              itemBuilder: (context, index) {
                final customerData = customersData[index];

                return Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        globalUserID = customersData[index]["id"] ;
                      });
                      print(globalUserID);
                      // Navigate to the UpdateCustomer page and pass the document ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdateCustomer(),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white60,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          color: PrimeColor,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0 , bottom: 10 , left: 8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white54,
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: ClipOval(
                                            child:
                                            // CircleAvatar(
                                            //   backgroundImage: customerData['user_imageUrl'] != null
                                            //       ? CachedNetworkImageProvider(customerData['user_imageUrl'])
                                            //       : AssetImage('assets/placeholder_image.jpg') as ImageProvider<Object>,
                                            // ),
                                            CachedNetworkImage(
                                              placeholder: (context, url) => CircularProgressIndicator(), // Circular progress indicator as a placeholder
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                              imageUrl: customerData['user_imageUrl'],fit: BoxFit.cover, )

                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                              Text('${customerData['user_fname']} ${customerData['user_lname']}',style: TextStyle(fontSize: 20 , color: Colors.black , fontWeight: FontWeight.w500),),
                                               SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Image.asset("assets/Call.png",height: 15,),
                                                  SizedBox(width: 10),
                                                  GestureDetector(
                                                      onTap: () {
                                                        _launchPhoneDialer(customerData['user_mobile']);
                                                      },
                                                      child: Text('${customerData['user_mobile']}')),
                                                ],
                                              ),
                                              SizedBox(height: 6),
                                               Row(
                                                 children: [
                                                   Image.asset("assets/location.png",height: 15,),
                                                   SizedBox(width: 10),
                                                   Text('${customerData['user_city']}, ${customerData['user_state']}, ${customerData['user_country']}'),
                                                 ],
                                               ),
                                            ],

                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              deleteCOnfirm(customersData);

                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }


  Future<void> _deleteCustomer(String docId, List<Map<String, dynamic>> customersData) async {
    try {
      // Reference to the customer document using the provided document ID
      DocumentReference customerDocRef = FirebaseFirestore.instance
          .collection('User')
          .doc(globalUserIdStored)
          .collection('Firms')
          .doc(globalFirmNameAllApp)
          .collection('Customer')
          .doc(docId);

      // Find the index of the customer data with the matching document ID
      int index = customersData.indexWhere((customer) => customer['id'] == docId);

      // Delete the customer document if found
      if (index != -1) {
        Map<String, dynamic> customerData = customersData[index];
        await customerDocRef.delete();

        // Optionally, delete the image from storage if customer data exists
        if (customerData['user_imageUrl'] != null) {
          String imageUrl = customerData['user_imageUrl'];
          Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
          await imageRef.delete();
        }

        // Refresh the list
        setState(() {
          _futureCustomersData = getDataCustomer(globalUserIdStored, globalFirmNameAllApp);
        });

        print('Customer deleted successfully.');
      } else {
        print('Customer with ID $docId not found.');
      }
    } catch (e) {
      print('Error deleting customer: $e');
      // Handle error
    }
  }

  void deleteCOnfirm(customersData){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Confirmation',style: allHeadingStyle,),
        content: Text('Are you sure you want to delete the customer ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Stay in the app
            },
            child: Text('Cancel',style: AllTextStyle,),
          ),
          TextButton(
            onPressed: () {
              _deleteCustomer(globalUserID , customersData);
              Navigator.of(context).pop(); // Exit the app
            },
            child: Text('OK',style: AllTextStyle,),
          ),
        ],
      ),
    );
  }
  void _launchPhoneDialer(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
