import 'dart:async';
import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:mypark/constants/connection_apis.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_identifier.dart';
import 'screens.dart';

class SplashScreen extends StatefulWidget {
  static const name = "splash";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  final BluetoothDevice _device =
      BluetoothDevice(bluetoothName, bluetoothAddress);
  SharedPreferences? preferences;
  bool? isLogged;

  Future<void> initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLogged = preferences?.getBool(logStatus);
    });
  }

  Future<void> connectBluetooth() async {
    try {
      if (await bluetooth.isAvailable == true && await bluetooth.isOn == true) {
        await bluetooth.connect(_device);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    initializePreferences();
    connectBluetooth();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashTransition: SplashTransition.slideTransition,
      splash: Image.network(preferences?.getString(appLogo) ??
          "https://podamibenepal.com/wp-content/uploads/2022/03/cropped-podamibe-logo-1.png"),
      nextScreen: isLogged == true ? const RootScreen() : const LoginScreen(),
      backgroundColor: Colors.white,
    );
  }
}
