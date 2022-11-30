import 'dart:ui';

import 'package:flutter/material.dart';

//dimensions
final screenSize = window.physicalSize;
final height = screenSize.height;
final width = screenSize.width;

//colors
const kColorPrimary = Color(0xff34B757);
const kColorWhite = Colors.white;
// const kColorSecondary = Color(0xFFE50607);
const kColorSecondary = Color(0xFFE7D3A8);
const kWelcomeImageUrl =
    "https://img.freepik.com/free-vector/landscape-summer-city-park-with-happy-people-picnic-families-with-children-spending-time-nature-flat-vector-illustration-outdoor-activity-leisure-concept-banner-website-design_74855-21959.jpg?t=st=1658306200~exp=1658306800~hmac=9d42baa9bae6706210c4e8bb854763bae6e6c7e340dc2750ae463674b9ff50eb&w=1060";
// const kColorGreen = Color(0xff33F133);

//textstyle
const kHeadTitle = TextStyle(color: kColorPrimary, fontSize: 20);

//themedata
class CustomTheme {
  static kThemeData1() {
    return ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: kColorPrimary),
      primaryColor: kColorPrimary,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          fixedSize: const Size.fromWidth(200),
          side: const BorderSide(color: kColorSecondary),
        ),
      ),
      textTheme: const TextTheme(
        bodyText2: TextStyle(
            fontSize: 25, fontWeight: FontWeight.w400, color: Colors.black),
        button: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.amber,
        ),
      ),
    );
  }

  static kThemeData() => ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: kColorPrimary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: kColorPrimary,
            minimumSize: Size(width * 0.2, height * 0.025),
          ),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateColor.resolveWith((states) => kColorPrimary),
        ),
        checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all(kColorPrimary)),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: kColorPrimary),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: kColorPrimary),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          prefixIconColor: kColorPrimary,
          suffixIconColor: kColorPrimary,
          labelStyle: TextStyle(color: kColorPrimary),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kColorSecondary)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary)),
        ),
        snackBarTheme: const SnackBarThemeData(backgroundColor: kColorPrimary),
        dialogTheme: const DialogTheme(
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22),
          contentTextStyle: TextStyle(fontSize: 18, color: Colors.black),
        ),
      );
}
