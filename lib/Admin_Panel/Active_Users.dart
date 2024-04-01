import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Constants/Constants.dart';
import '../Constants/Globals.dart';
import 'Admin_Home.dart';
import 'InActive_Users.dart';
import 'User_Details.dart';
import 'globals_Admkin.dart';


class ActiveUsersScreen extends StatefulWidget {
  const ActiveUsersScreen({super.key});

  @override
  _ActiveUsersScreenState createState() => _ActiveUsersScreenState();
}

class _ActiveUsersScreenState extends State<ActiveUsersScreen> {



  late TextEditingController searchController;
  late Future<List<DocumentSnapshot>> _activeUsersFuture;



  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
   // _getActiveUsers();
    _activeUsersFuture = _getActiveUsers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Future<void> _getActiveUsers() async {
  //   CollectionReference usersRef = FirebaseFirestore.instance.collection('User');
  //   QuerySnapshot querySnapshot = await usersRef.where('status', isEqualTo: 'Active').get();
  //   setState(() {
  //     _activeUsersFuture = Future.value(querySnapshot.docs);
  //   });
  // }
  Future<List<DocumentSnapshot>> _getActiveUsers() async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('User');
    QuerySnapshot querySnapshot = await usersRef.where('status', isEqualTo: 'Active').get();
    return querySnapshot.docs;
  }


  List<DocumentSnapshot> _filterUsers(List<DocumentSnapshot> users, String query) {
    if (query.isEmpty) {
      return users;
    }
    return users.where((user) {
      Map<String, dynamic> userData = user.data() as Map<String, dynamic>;
      return userData['city'].toLowerCase().contains(query.toLowerCase()) ||
          userData['phoneNumber'].contains(query) ||
          userData['fname'].toLowerCase().contains(query.toLowerCase()) ||
          userData['lname'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<bool> onWillPop() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminPanel(),
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
          toolbarHeight: 50,
          elevation: 0,
          title:   Text('Active Users',style: TextStyle(color: allHeadingPrimeColor),),
          leading: IconButton(
            icon:   Icon(Icons.arrow_back_ios,color: allHeadingPrimeColor,), onPressed: () {
            Navigator.pop(context);
          },
          ),
        ),

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                cursorColor: allHeadingPrimeColor,
                style: const TextStyle(
                  color: Color(0xFF323232),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle:  const TextStyle(
                      color: Colors.grey
                  ),
                  isDense: true,
                  prefixIcon: const Icon(Icons.search,color: allHeadingPrimeColor,),
                  suffixIcon: IconButton(color: allHeadingPrimeColor, onPressed: () {
                    searchController.clear();
                  _getActiveUsers();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ActiveUsersScreen()),
                    );

                  },
                    icon: const Icon(Icons.clear),),
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
                onChanged: (query) {
                  _activeUsersFuture.then((users) {
                    setState(() {
                      _activeUsersFuture = Future.value(_filterUsers(users, query));
                    });
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: _activeUsersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<DocumentSnapshot> activeUsers = snapshot.data!;
                    return ListView.builder(
                      itemCount: activeUsers.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> userData = activeUsers[index].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${userData['fname']} ${userData['lname']}'),
                               Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(Radius.circular(50))
                                ),
                                child: Text(""),
                              )
                            ],
                          ),
                          subtitle: Text('${userData['phoneNumber']} - ${userData['city']} - ${userData['status']}'),
                          onTap: () {
                             setState(() {
                              globalUserId = userData['userId'];
                             });
                            print(globalUserId);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserDetail()),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
