import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../Admin_Panel/Active_Users.dart';
import '../Admin_Panel/InActive_Users.dart';
import 'Homepage.dart';
import 'Stock/Add_Stock.dart';
import 'Stock/Stock_List.dart';



class CurveBar extends StatefulWidget {
  const CurveBar({super.key});

  @override
  State<CurveBar> createState() => _CurveBarState();
}

class _CurveBarState extends State<CurveBar> {
  int index = 2;
  final screen = const [
    InActiveUsersScreen(),
    ActiveUsersScreen(),
    Homepage(),
    AddStock(),
    StockList(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = [
      const Icon(Icons.history, size: 30),
      const Icon(Icons.favorite, size: 30),
      const Icon(Icons.home, size: 30),
      const Icon(Icons.person, size: 30),
      const Icon(Icons.settings, size: 30)
    ];
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      extendBody: true,
      body: screen[index],

      bottomNavigationBar: Theme(
        // this them is for to change icon colors.
        data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(
              color: Color(0xFFd88c9a),
            )),
        child: CurvedNavigationBar(
          // navigationBar colors
        //  color: const Color.fromARGB(255, 231, 46, 207),
          color: Color(0xfff1efee),
          //selected times colors
          buttonBackgroundColor: Color(0xfff1efee),
          backgroundColor: Colors.transparent,
          items: items,
          height: 53,
          index: index,
          onTap: (index) => setState(
                () => this.index = index,
          ),
        ),
      ),
    );
  }
}