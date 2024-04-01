
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';

class UnitServices {

  static Future<void> initUniLinks() async {

    try {
      Uri? initialUri = await getInitialUri();
      _handleLink(initialUri);

      print("##########################$initialUri");
      print("##########################${initialUri}oiwhjo");

      getUriLinksStream().listen((Uri? uri) {
        if (uri != null) {
          _handleLink(uri);

        }
      });
    } catch (e) {
      print('Error initializing uni_links: $e');
    }
  }

 static void _handleLink(Uri? link) {
    print("##########################test");

    if (link != null && link.queryParameters.containsKey('referrer')) {
      String? referrer = link.queryParameters['referrer'];
      String decodedReferrer = Uri.decodeComponent(referrer!);
      // Your code to handle the referrer parameter...

      // if(decodedReferrer.isNotEmpty){
      //   globalCodeTestAuto = decodedReferrer;
      // } else {
      //   globalCodeTestAuto = "916Jewellery";
      }

    }
  }
