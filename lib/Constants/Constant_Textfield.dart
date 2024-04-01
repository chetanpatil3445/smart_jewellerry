import 'package:flutter/material.dart';

import 'Constants.dart';


const TextStyle allTextStyle = TextStyle(
  color: Color(0xFF323232),
  fontSize: 17,
  fontWeight: FontWeight.w400,
);

// Define your custom constants here
const kBorderRadius = BorderRadius.all(Radius.circular(7));

// Define your custom input decoration constant
InputDecoration customInputDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(
      color: Colors.grey,
    ),
    isDense: true,
    focusedBorder: OutlineInputBorder(
      borderRadius: kBorderRadius,
      borderSide: BorderSide(
        color: allHeadingPrimeColor,
        width: 0.3,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: kBorderRadius,
      borderSide: BorderSide(
        color: allHeadingPrimeColor,
        width: 0.3,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: kBorderRadius,
      borderSide: const BorderSide(
        color: allHeadingPrimeColor,
        width: 0.3,
      ),
    ),
  );
}
