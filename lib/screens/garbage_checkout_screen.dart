import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_identifier.dart';
import '../constants/theme.dart';
import '../networking.dart';
import '../widgets/widgets.dart';

class GarbageCheckout extends StatefulWidget {
  static const name = "checkoutg";
  const GarbageCheckout({Key? key}) : super(key: key);

  @override
  State<GarbageCheckout> createState() => _GarbageCheckoutState();
}

class _GarbageCheckoutState extends State<GarbageCheckout>
    with SingleTickerProviderStateMixin {
  final _focusNode = FocusNode();
  late TextEditingController _scanGarbageController;
  bool isFlagged = false;
  List<bool> isChecked = [];
  List<String> flag = [];
  PrintReceipt? printReceipt;
  SharedPreferences? preferences;
  late NetworkHelper _networkHelper;
  String? _scanBarcode;
  List<String?> stickerList = [];
  // ignore: prefer_typing_uninitialized_variables
  var args;

  addStickers(args) async {
    stickerList.add(args["garbages"].map((e) => e["sbar"]).toString());
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    setState(() {
      _scanBarcode = barcodeScanRes.substring(0, barcodeScanRes.length - 1);
    });
  }

  Future<void> initializePrefs() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    _scanGarbageController =
        TextEditingController.fromValue(TextEditingValue.empty);
    initializePrefs();
    _networkHelper = NetworkHelper();
    printReceipt = PrintReceipt();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)!.settings.arguments;
        addStickers(args);
        isChecked = List.filled(args["garbages"].length, false);
        flag = List.filled(args["garbages"].length, "N");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${args["nam"]}"),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.028, vertical: height * 0.04),
        child: Column(children: [
          TextFormField(
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Reference Number',
            ),
            initialValue: args["ref_n"].toString(),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
            initialValue: args["phone"].toString(),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Deposit Amount',
            ),
            initialValue: args["depo"].toString(),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            color: kColorPrimary.withAlpha(50),
            height: height * 0.4,
            child: ListView.builder(
                itemCount: args["garbages"].length,
                itemBuilder: (_, index) {
                  // for (var garbage in args["garbages"]) {
                  if (args["garbages"][index]["sbar"]
                      .contains(_scanBarcode ?? "1234")) {
                    isChecked[index] = true;
                    flag[index] = "Y";
                  }

                  return Column(
                    children: [
                      TextFormField(
                        enabled: false,
                        // onChanged: (b) {
                        //   print(args["garbages"][index]["sbar"]);
                        // },
                        initialValue:
                            args["garbages"][index]["gname"].toString(),
                        decoration: InputDecoration(
                          labelText: "Garbage Name",
                          suffixIcon: isChecked[index] == true
                              ? const Icon(
                                  Icons.check_circle_outlined,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.highlight_off_outlined,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  );
                }),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  focusNode: _focusNode,
                  autofocus: true,
                  controller: _scanGarbageController,
                  decoration: const InputDecoration(
                    labelText: 'Sticker Scan',
                  ),
                  onChanged: (v) {
                    v = v.substring(0, v.length - 1);
                    _scanGarbageController.text = v;
                    _scanBarcode = v;
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                  child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _scanGarbageController.clear();
                    _focusNode.requestFocus();
                    // _scanBarcode = "";
                  });
                },
                child: const Text("Scan Next"),
              )),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              final a = List.generate(args["garbages"].length, (index) {
                return {
                  "sid": args["garbages"][index]["sid"].toString(),
                  "flag": flag[index],
                };
              });
              if (kDebugMode) {
                print(a);
              }
              final result = await _networkHelper.verifyGarbage(
                  preferences!.get(userTicketNumber)!.toString(), a);
              if (result["msg"] == "Y") {
                await preferences!.setString(checkInTime, result["CiTime"]);
                await preferences!.setString(checkOutTime, result["CoTime"]);
                await preferences!.setDouble(checkoutTotal, result["tot"]);
                await preferences!.setDouble(fineAmount, result["fine"]);
                await preferences!.setDouble(depositAmount, result["depo"]);
                await preferences!.setDouble(returnAmount, result["ret"]);
                await preferences!
                    .setString(checkOutDate, result["CheckoutDate"].toString());
                await printReceipt!.printCheckOut();
                Fluttertoast.showToast(
                    msg: "Check-out completed.",
                    backgroundColor: kColorPrimary);
              }
            },
            child: const Text("Check-Out"),
          ),
        ]),
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await scanQR();
          if (kDebugMode) {
            print(_scanBarcode);
          }
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
    super.dispose();
    _scanGarbageController.dispose();
  }
}
