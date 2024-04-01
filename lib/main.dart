import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Autocode.dart';
import 'Colors_Desings/ColorPrimary.dart';
import 'Login/splashScreen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UnitServices.initUniLinks();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
      ),
          home:   GetStarted(),
      //   home:   MyWidget(),
    );
  }
}


