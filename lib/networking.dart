import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mypark/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/app_identifier.dart';
import 'constants/connection_apis.dart';

class NetworkHelper {
  SharedPreferences? preferences;

  Future<UserModel> logIn(String password, String username) async {
    preferences = await SharedPreferences.getInstance();
    try {
      final request = await http.post(Uri.parse(loginUrl),
          body: {"username": username, "password": password});
      if (kDebugMode) {
        print("RESULT:${jsonDecode(request.body)}");
      }
      return userModelFromMap(request.body);
    } catch (e) {
      throw ("POST EXCEPTION:$e");
    }
  }

  //   preferences = await SharedPreferences.getInstance();
  //   try {
  //     final jsonRequest = jsonEncode(
  //         {"password": password, "username": "info@podamibenepal.com"});
  //     final response = await http.post(Uri.parse(baseUrl + "LogIn/LogIn"),
  //         body: jsonRequest);
  //     return jsonDecode(response.body);
  //   } catch (e) {
  //     throw ("POST EXCEPTION:" + e.toString());
  //   }
  // }

  Future<Map<String, dynamic>> checkInTicket(
      String ticketNumber, String userId) async {
    final request = await http.post(
        Uri.parse(
          ticketUrl,
        ),
        body:
            // checkerRequestToMap(CheckerRequest(
            //    tn: ticketNumber,
            //   uid: int.parse(userId),
            //   refN: "string",
            //   depo: 0,
            //   fine: 0,
            //   gtot: 0,
            //   sids: "",
            //   sid: "",
            //   tid: 0,
            //   stkrs: [],
            // ),),);
            {
          "tn": ticketNumber,
          "uid": userId,
          "ref_n": "string",
          "depo": "",
          "fine": "",
          "gtot": "",
          "sids": "string",
          "sid": "string",
          "tid": "",
          "stkrs": "",
        });
    if (kDebugMode) {
      print("RESULT:${jsonDecode(request.body)}");
    }
    return jsonDecode(request.body);
  }

  Future<Map<String, dynamic>> checkInGarbage(
    String ticketNumber,
    String userID,
    String referenceNumber,
  ) async {
    // String ticketNumber) async {
    final request = await http.post(Uri.parse(garbageUrl), body: {
      "tn": ticketNumber,
      "uid": userID,
      "ref_n": referenceNumber,
      "depo": "0",
      "fine": "0",
      "gtot": "0",
      "sids": "string",
      "sid": "",
      "tid": "0",
      "stkrs": ""
    });
    if (kDebugMode) {
      print("RESULT:${jsonDecode(request.body)}");
    }
    return jsonDecode(request.body);
  }

  Future<Map<String, dynamic>> garbageDeposit(String ticketNumber,
      String sticketIds, String garbageTotal, String depositAmount) async {
    // String ticketNumber) async {
    final request = await http.post(Uri.parse(garbageDepositUrl), body: {
      "tn": ticketNumber,
      "uid": "",
      "ref_n": "",
      "depo": depositAmount,
      "fine": "0",
      "gtot": garbageTotal,
      "sids": sticketIds,
      "sid": "string",
      "tid": "0",
      "stkrs": "",
    });
    if (kDebugMode) {
      print("RESULT:${jsonDecode(request.body)}");
    }
    return jsonDecode(request.body);
  }

  Future<Map<String, dynamic>> picnicDeposit(
      String ticketNumber, String depositAmount) async {
    // String ticketNumber) async {
    final request = await http.post(Uri.parse(picnicDepositUrl), body: {
      "tn": ticketNumber,
      "uid": "",
      "ref_n": "",
      "depo": depositAmount,
      "fine": "0",
      "gtot": "0",
      "sids": "string",
      "sid": "string",
      "tid": "0",
      "stkrs": "",
    });
    if (kDebugMode) {
      print("RESULT:${jsonDecode(request.body)}");
    }
    return jsonDecode(request.body);
  }

  Future<Map<String, dynamic>> checkOutTicket(String ticketNumber) async {
    // String ticketNumber) async {
    final request = await http.post(Uri.parse(getIssuedGarbageInfo), body: {
      "tn": ticketNumber,
      "uid": "",
      "ref_n": "string",
      "depo": "0",
      "fine": "0",
      "gtot": "0",
      "sids": "string",
      "sid": "string",
      "tid": "0",
      "stkrs": ""
    });
    if (kDebugMode) {
      print("RESULT:${jsonDecode(request.body)}");
    }
    return jsonDecode(request.body);
  }

  Future<Map<String, dynamic>> verifyGarbage(
      String ticketNumber, List<Map<String, String?>> totalGarbage) async {
    // String ticketNumber) async {
    final request = await http.post(
      Uri.parse(verifyGarbageUrl),
      body: jsonEncode({
        "tn": ticketNumber,
        "uid": "0",
        "ref_n": "string",
        "depo": "0",
        "fine": "0",
        "gtot": "0",
        "sids": "string",
        "sid": "string",
        "tid": "0",
        "stkrs": totalGarbage
      }),
      headers: {'Content-type': 'application/json'},
    );
    if (kDebugMode) {
      print("RESULT:${jsonDecode(request.body)}");
    }
    return jsonDecode(request.body);
  }

  Future<Map<String, dynamic>> printPicnic(
      String ticketNumber, String fine) async {
    // String ticketNumber) async {
    final request = await http.post(Uri.parse(picnicPrintUrl), body: {
      "tn": ticketNumber,
      "uid": "",
      "ref_n": "string",
      "depo": "0",
      "fine": fine,
      "gtot": "0",
      "sids": "string",
      "sid": "string",
      "tid": "0",
      "stkrs": ""
    });
    if (kDebugMode) {
      print("RESULT:${jsonDecode(request.body)}");
    }
    return jsonDecode(request.body);
  }

  Future<void> printConfig(
    String date,
    String refNum,
    String name,
    String spotName,
    String total,
    String due,
    String deposit,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(buyDate, date);
    preferences.setString(referenceNum, refNum);
    preferences.setString(visitorName, name);
    preferences.setString(picnicSpotName, spotName);
    preferences.setString(initialTotal, total);
    preferences.setString(dueAmount, due);
    preferences.setDouble(depositAmount, double.parse(deposit));
  }

  Future<void> deleteConfig() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove(panNumber);
    preferences.remove(headerTitle);
    preferences.remove(singleLineAddress);
    preferences.remove(copyrightText);
    preferences.remove(appId);
    preferences.remove(appLogo);
    preferences.remove(configURL);
    preferences.remove(loginURL);
    preferences.remove(isPowered);
    preferences.remove(isPan);
    preferences.clear();
  }

  Future<void> initalAdminConfig() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(panNumber, "123456789");
    preferences.setString(headerTitle, "Historical Manjushree Park");
    preferences.setString(singleLineAddress, "Jalbinayak, Chobhar");
    preferences.setString(copyrightText, "Powered By Podamibe Nepal");
    // preferences.setString(appId, "P105");
    // preferences.setString(appLogo,
    //     "https://podamibenepal.com/wp-content/uploads/2022/03/cropped-podamibe-logo-1.png");
    // preferences.setString(configURL,
    //     "https://management.propertycare.online/config.json?appId=P105");
    // preferences.setString(
    //     loginURL, "https://management.propertycare.online/api/login");
    preferences.setBool(isPan, true);
    preferences.setBool(isPowered, true);
  }
}
