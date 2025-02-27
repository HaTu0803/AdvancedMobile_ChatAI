import 'package:flutter/material.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._(); //To avoid creating instances }

  static final LightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.black,
      side: const BorderSide(color: Colors.black),
      textStyle: const TextStyle(fontSize: 16, color: Colors.black, fontWeight : FontWeight.w600),
      padding: const EdgeInsets.symmetric (vertical : 16, horizontal : 20),
      shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular (14)),
    )
  ); // outlinedButtonTheneData

  static final DarkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      side: const BorderSide(color: Colors.black),
      textStyle: const TextStyle(fontSize: 16, color: Colors.white, fontWeight : FontWeight.w600),
      padding: const EdgeInsets.symmetric (vertical : 16, horizontal : 20),
      shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular (14)),
    )
  ); // outlinedButtonTheneData
}