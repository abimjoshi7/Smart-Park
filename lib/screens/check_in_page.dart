import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_identifier.dart';
import '../constants/theme.dart';
import '../networking.dart';
import '../widgets/print_receipt.dart';
import 'screens.dart';

class CheckIn extends StatefulWidget {
  static const name = "check-in";
  const CheckIn({Key? key}) : super(key: key);

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  bool withItems = false;
  SharedPreferences? preferences;
  late TextEditingController _textEditingController;
  late NetworkHelper _networkHelper;
  PrintReceipt? printReceipt;
  String _scanBarcode = "";
  List<Widget> shownWidgets = [];

  Future<void> initializePrefs() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initializePrefs();
    _networkHelper = NetworkHelper();
    printReceipt = PrintReceipt();
    _textEditingController =
        TextEditingController.fromValue(TextEditingValue.empty);
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      await preferences!.setString(initalCompleteBarCode, barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    setState(() {
      _scanBarcode = barcodeScanRes.substring(0, barcodeScanRes.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.028, vertical: height * 0.010),
              child: SizedBox(
                height: 130,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _focusNode.requestFocus();
                          _textEditingController.clear();
                          shownWidgets.clear();
                        });
                      },
                      child: const Text('Scan next'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Flexible(
                      child: TextField(
                        focusNode: _focusNode,
                        autofocus: true,
                        controller: _textEditingController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: "Ticket Number"),
                        onSubmitted: (v) async {
                          v = v.substring(0, v.length - 1);
                          if (v.length == 11) {
                            setState(() {
                              _textEditingController.text = v;
                              if (kDebugMode) {
                                print(_textEditingController.text);
                              }
                            });
                            final result = await _networkHelper.checkInTicket(
                                _textEditingController.text,
                                preferences!.getString(persistUserID)!);
                            preferences!.setString(
                                userTicketNumber, _textEditingController.text);
                            preferences!.setString(
                                buyDate,
                                result["Bdate"]
                                    .substring(0, result["Bdate"].length - 13));
                            preferences!.setString(
                                referenceNum, result["ref_n"] ?? "123123");
                            preferences!.setString(
                                visitorName, result["Nam"] ?? "asdqwe");
                            // preferences!.setString(
                            //     checkInTime,
                            //     result["chkInTime"]
                            //             .substring(0, result["chkInTime"].length - 8) ??
                            //         "123");
                            switch (result["flag"]) {
                              case "V":
                                await preferences!.setString(
                                    buyDate,
                                    result["Bdate"].substring(
                                        0, result["Bdate"].length - 13));
                                await preferences!
                                    .setString(referenceNum, result["ref_n"]);
                                await preferences!
                                    .setString(visitorName, result["Nam"]);
                                await preferences!.setString(
                                    checkInTime,
                                    result["chkInTime"].substring(
                                        0, result["chkInTime"].length - 8));
                                setState(() {
                                  shownWidgets.add(
                                    SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 28.0, vertical: 10),
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                labelText: 'Date',
                                              ),
                                              initialValue: preferences
                                                      ?.get(buyDate)
                                                      .toString() ??
                                                  "",
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                labelText: 'Reference Number',
                                              ),
                                              initialValue: preferences
                                                      ?.get(referenceNum)
                                                      .toString() ??
                                                  "",
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                labelText: 'Name',
                                              ),
                                              initialValue: preferences
                                                      ?.get(visitorName)
                                                      .toString() ??
                                                  "",
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                labelText: 'Check-In Time',
                                              ),
                                              initialValue: preferences
                                                      ?.get(checkInTime)
                                                      .toString() ??
                                                  "",
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                    VisitorDashboard.name,
                                                    arguments: result);
                                                // print(garbageList);
                                              },
                                              child: const Text("Scan Garbage"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });

                                break;
                              case "A":
                                Fluttertoast.showToast(
                                    msg: "Ticket is already verified",
                                    backgroundColor: kColorPrimary);
                                break;
                              case "M":
                                Fluttertoast.showToast(
                                    msg: "Ticket is invalid",
                                    backgroundColor: kColorPrimary);
                                break;
                              default:
                                Fluttertoast.showToast(
                                    msg:
                                        "Something went wrong. Please contact the administrator.",
                                    backgroundColor: kColorPrimary);
                                break;
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: shownWidgets,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await scanQR().then((value) async {
            setState(() {
              _textEditingController.text = _scanBarcode;
            });
            final result = await _networkHelper.checkInTicket(
                _scanBarcode, preferences!.getString(persistUserID)!);
            await preferences!.setString(userTicketNumber, _scanBarcode);

            switch (result["flag"]) {
              case "V":
                await preferences!.setString(buyDate,
                    result["Bdate"].substring(0, result["Bdate"].length - 13));
                await preferences!.setString(referenceNum, result["ref_n"]);
                await preferences!.setString(visitorName, result["Nam"]);
                await preferences!.setString(
                    checkInTime,
                    result["chkInTime"]
                        .substring(0, result["chkInTime"].length - 8));
                setState(() {
                  shownWidgets.add(
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28.0, vertical: 10),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Date',
                              ),
                              initialValue:
                                  preferences?.get(buyDate).toString() ?? "",
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Reference Number',
                              ),
                              initialValue:
                                  preferences?.get(referenceNum).toString() ??
                                      "",
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                              initialValue:
                                  preferences?.get(visitorName).toString() ??
                                      "",
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Check-In Time',
                              ),
                              initialValue:
                                  preferences?.get(checkInTime).toString() ??
                                      "",
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, VisitorDashboard.name,
                                    arguments: result);
                                // print(garbageList);
                              },
                              child: const Text("Scan Garbage"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });

                break;
              case "A":
                return Fluttertoast.showToast(
                    msg: "Ticket is already verified",
                    backgroundColor: kColorPrimary);
              case "M":
                return Fluttertoast.showToast(
                    msg: "Ticket is invalid", backgroundColor: kColorPrimary);
              default:
                return Fluttertoast.showToast(
                    msg:
                        "Something went wrong. Please contact the administrator.",
                    backgroundColor: kColorPrimary);
            }
          });
        },
        label: Row(
          children: const [
            Icon(Icons.adf_scanner),
            SizedBox(
              width: 5,
            ),
            Text("SCAN"),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
