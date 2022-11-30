import 'dart:math';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_identifier.dart';

class PrintReceipt {
  String getRandomString(int length) {
    const characters =
        '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

//   sample() async {
//     final preferences = await SharedPreferences.getInstance();
//
//     //SIZE
//     // 0- normal size text
//     // 1- only bold text
//     // 2- bold with medium text
//     // 3- bold with large text
//     //ALIGN
//     // 0- ESC_ALIGN_LEFT
//     // 1- ESC_ALIGN_CENTER
//     // 2- ESC_ALIGN_RIGHT
//
// //     var response = await http.get("IMAGE_URL");
// //     Uint8List bytes = response.bodyBytes;
//     bluetooth.isConnected.then((isConnected) {
//       if (isConnected == true) {
//         // bluetooth.printNewLine();
//         bluetooth.printCustom(
//             preferences.getString(headerTitle).toString(), 0, 1);
//         bluetooth.printCustom(
//             preferences.getString(singleLineAddress).toString(), 0, 1);
//         bluetooth.printCustom(
//             "Pan Number : " + preferences.getString(panNumber).toString(),
//             0,
//             1);
//         bluetooth.printCustom(dottedLine, 1, 1);
//         bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
//         bluetooth.printCustom(dottedLine, 1, 1);
//         bluetooth.printLeftRight("Check-In", "Jul 12 2022 16:10", 1,
//             charset: "windows-1250");
//         bluetooth.printCustom(dottedLine, 1, 1);
//         bluetooth.printLeftRight("S.N", getRandomString(8), 0,
//             charset: "windows-1250");
//         bluetooth.printLeftRight("Rate", "Rs 50/hr", 0,
//             charset: "windows-1250");
//         bluetooth.printLeftRight("V.N", "Ba 009 Ch 4004", 0,
//             charset: "windows-1250");
//         bluetooth.printCustom(dottedLine, 1, 1);
//         bluetooth.printCustom(
//             preferences.getString(copyrightText).toString(), 0, 1);
//         bluetooth.printNewLine();
//         bluetooth.printNewLine();
//
//         // bluetooth.printImage(pathImage); //path of your image/logo
//         // bluetooth.printLeftRight("LEFT", "RIGHT", 0);
//         // bluetooth.printLeftRight("LEFT", "RIGHT", 1);
//         // bluetooth.printLeftRight("LEFT", "RIGHT", 1, format: "%-15s %15s %n");
//         // bluetooth.printLeftRight("LEFT", "RIGHT", 2);
//         // bluetooth.printLeftRight("LEFT", "RIGHT", 3);
//         // bluetooth.printLeftRight("LEFT", "RIGHT", 4);
//         // bluetooth.print3Column("Col1", "Col2", "Col3", 1);
//         // bluetooth.print3Column("Col1", "Col2", "Col3", 1,
//         //     format: "%-10s %10s %10s %n");
//         // bluetooth.printNewLine();
//         // bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1);
//         // bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1,
//         //     format: "%-8s %7s %7s %7s %n");
//         // bluetooth.printNewLine();
//         // String testString = " čĆžŽšŠ-H-ščđ";
//         // bluetooth.printCustom(testString, 1, 1, charset: "windows-1250");
//         // bluetooth.printLeftRight("Številka:", "18000001", 1,
//         //     charset: "windows-1250");
//         // bluetooth.printCustom("Body left", 1, 0);
//         // bluetooth.printCustom("Body right", 0, 2);
//         // bluetooth.printNewLine();
//         // bluetooth.printCustom("Thank You", 2, 1);
//         // bluetooth.printNewLine();
//         // bluetooth.printNewLine();
//         // bluetooth.printNewLine();
//         // bluetooth.paperCut();
//       }
//     });
//   }

  // printCheckIn() async {
  //   final preferences = await SharedPreferences.getInstance();
  //
  //   bluetooth.isConnected.then((isConnected) {
  //     if (isConnected == true) {
  //       bluetooth.printCustom(
  //           preferences.getString(headerTitle).toString(), 0, 1);
  //       bluetooth.printCustom(
  //           preferences.getString(singleLineAddress).toString(), 0, 1);
  //
  //       preferences.getBool(isPan) == true
  //           ? bluetooth.printCustom(
  //               "Pan Number : " + preferences.getString(panNumber).toString(),
  //               0,
  //               1)
  //           : bluetooth.printNewLine();
  //       bluetooth.printCustom(dottedLine, 1, 1);
  //       bluetooth.printQRcode(
  //           preferences.getString(qrToken).toString(), 200, 200, 1);
  //       bluetooth.printCustom(dottedLine, 1, 1);
  //       bluetooth.printCustom(
  //           "Check-In    ${preferences.get(checkIn).toString()}", 0, 1);
  //       bluetooth.printCustom(dottedLine, 1, 1);
  //       bluetooth.printLeftRight("S.N", getRandomString(8), 0,
  //           charset: "windows-1250");
  //       bluetooth.printLeftRight(
  //           "Rate", "Rs ${preferences.get(rate).toString()}/hr", 0,
  //           charset: "windows-1250");
  //       bluetooth.printLeftRight(
  //           "V.N", preferences.getString(fullVehicleId).toString(), 0,
  //           charset: "windows-1250");
  //       bluetooth.printCustom(dottedLine, 1, 1);
  //       preferences.getBool(isPowered) == true
  //           ? bluetooth.printCustom(
  //               preferences.getString(copyrightText).toString(), 0, 1)
  //           : bluetooth.printNewLine();
  //       bluetooth.printNewLine();
  //       bluetooth.printNewLine();
  //     }
  //   });
  // }
  printCheckIn() async {
    final preferences = await SharedPreferences.getInstance();
    List<String> garabageNameL =
        preferences.get(garbageListName)! as List<String>;
    String garbageName = garabageNameL.join(',');
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printCustom(
            preferences.getString(headerTitle).toString(), 0, 1);
        bluetooth.printCustom(
            preferences.getString(singleLineAddress).toString(), 0, 1);
        preferences.getBool(isPan) == true
            ? bluetooth.printCustom(
                "Pan Number : ${preferences.getString(panNumber)}", 0, 1)
            : bluetooth.printNewLine();
        bluetooth.printCustom(dottedLine, 1, 1);
        bluetooth.printCustom("Check-In", 1, 1);
        // bluetooth.printQRcode(
        //     preferences.getString(initalCompleteBarCode).toString(),
        //     200,
        //     200,
        //     1);
        bluetooth.printCustom(dottedLine, 1, 1);
        bluetooth.printLeftRight("Date", preferences.get(buyDate).toString(), 0,
            charset: "windows-1250");
        bluetooth.printLeftRight(
            "Ref No", preferences.get(referenceNum).toString(), 0,
            charset: "windows-1250");
        bluetooth.printLeftRight(
            "Name", preferences.get(visitorName).toString(), 0,
            charset: "windows-1250");
        bluetooth.printLeftRight(
            "Check-In Time", preferences.get(checkInTime).toString(), 0,
            charset: "windows-1250");
        bluetooth.printCustom("Garbage Name\n$garbageName", 0, 0);
        // bluetooth.printCustom(
        //     "Garbages: ${preferences.get(garbageListName)} \n Qty:${preferences.get(garbageListQuantity)} \n Total:${preferences.get(garbageListTotal)}",
        //     0,
        //     1);
        bluetooth.printLeftRight("Garbage Total",
            "Rs ${preferences.get(garbageTotal).toString()}", 0,
            charset: "windows-1250");
        // bluetooth.printLeftRight(
        //     "Due Amount", "Rs ${preferences.get(dueAmount).toString()}", 0,
        //     charset: "windows-1250");
        bluetooth.printLeftRight("Deposit Amount",
            "Rs ${preferences.get(depositAmount).toString()}", 0,
            charset: "windows-1250");
        bluetooth.printLeftRight(
            "Net Total", "Rs ${preferences.get(garbageNetTotal).toString()}", 0,
            charset: "windows-1250");

        bluetooth.printCustom(dottedLine, 1, 1);
        preferences.getBool(isPowered) == true
            ? bluetooth.printCustom(
                preferences.getString(copyrightText).toString(), 0, 1)
            : bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
      }
    });
  }

  printCheckOut() async {
    final preferences = await SharedPreferences.getInstance();
    final checkIN = preferences
        .getString(checkInTime)!
        .substring(0, preferences.getString(checkInTime)!.length - 8);
    final checkOUT = preferences
        .getString(checkOutTime)!
        .substring(0, preferences.getString(checkOutTime)!.length - 8);
    final checkDate = preferences
        .getString(checkOutDate)!
        .substring(0, preferences.getString(checkOutDate)!.length - 9);

    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printCustom(
            preferences.getString(headerTitle).toString(), 0, 1);
        bluetooth.printCustom(
            preferences.getString(singleLineAddress).toString(), 0, 1);
        preferences.getBool(isPan) == true
            ? bluetooth.printCustom(
                "Pan Number : ${preferences.getString(panNumber)}", 0, 1)
            : bluetooth.printNewLine();
        bluetooth.printCustom(dottedLine, 1, 1);
        bluetooth.printCustom("Check-Out", 1, 1);

        bluetooth.printCustom(dottedLine, 1, 1);
        bluetooth.printLeftRight("Check-In", checkIN, 0,
            charset: "windows-1250");
        bluetooth.printLeftRight("Check-Out", checkOUT, 0,
            charset: "windows-1250");
        bluetooth.printLeftRight("Check-Date", checkDate, 0,
            charset: "windows-1250");
        bluetooth.printLeftRight(
          "Total Amount",
          preferences.get(checkoutTotal).toString(),
          0,
        );
        bluetooth.printLeftRight(
            "Fine Amount", preferences.get(fineAmount).toString(), 0,
            charset: "windows-1250");
        bluetooth.printLeftRight(
            "Deposit Amount", preferences.get(depositAmount).toString(), 0,
            charset: "windows-1250");
        bluetooth.printLeftRight(
            "Return Amount", preferences.get(returnAmount).toString(), 0,
            charset: "windows-1250");
        bluetooth.printCustom(dottedLine, 1, 1);
        preferences.getBool(isPowered) == true
            ? bluetooth.printCustom(
                preferences.getString(copyrightText).toString(), 0, 1)
            : bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
      }
    });
  }
}