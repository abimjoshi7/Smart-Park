import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/theme.dart';
import '../networking.dart';
import '../widgets/print_receipt.dart';
import 'screens.dart';

class CheckOut extends StatefulWidget {
  static const name = "check-out";
  const CheckOut({Key? key}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  List<bool> isChecked = [];
  List<Widget> shownWidgets = [];
  SharedPreferences? preferences;
  late final TextEditingController _textEditingController;
  late NetworkHelper _networkHelper;
  PrintReceipt? printReceipt;
  String _scanBarcode = "";
  String? flag;

  Future<void> initializePrefs() async {
    preferences = await SharedPreferences.getInstance();
  }

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
                        autofocus: true,
                        controller: _textEditingController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: "Ticket Number"),
                        onSubmitted: (v) async {
                          v = v.substring(0, v.length - 1);
                          if (v.length == 11) {
                            final result =
                                await _networkHelper.checkOutTicket(v);
                            if (result["msg"] == "Y" &&
                                result["msgType"] == "ok") {
                              setState(() {
                                shownWidgets.add(
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 28.0, vertical: 10),
                                      child: Column(
                                        children: [
                                          Container(
                                            color: kColorPrimary.withAlpha(50),
                                            height: height * 0.4,
                                            child: ListView.builder(
                                              // shrinkWrap: true,
                                              // physics:
                                              //     const NeverScrollableScrollPhysics(),
                                              itemBuilder: (_, index) {
                                                isChecked = List.filled(
                                                    result["garbages"].length,
                                                    false);
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: TextFormField(
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'Garbage Name',
                                                            ),
                                                            enabled: false,
                                                            initialValue:
                                                                "${result["garbages"][index]["gname"]}",
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        // Flexible(
                                                        //   child: TextFormField(
                                                        //     decoration:
                                                        //         const InputDecoration(
                                                        //       labelText:
                                                        //           'Quantity',
                                                        //     ),
                                                        //     enabled: false,
                                                        //     initialValue:
                                                        //         "${result["garbages"][index]["qty"]}",
                                                        //   ),
                                                        // ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Flexible(
                                                          child: TextFormField(
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'Garbage Rate',
                                                            ),
                                                            enabled: false,
                                                            initialValue:
                                                                "${result["garbages"][index]["grate"]}",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                  ],
                                                );
                                              },
                                              itemCount:
                                                  result["garbages"].length,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Reference Number',
                                            ),
                                            enabled: false,
                                            initialValue: result["ref_n"] ?? "",
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Name',
                                            ),
                                            enabled: false,
                                            initialValue: result["nam"] ?? "",
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Deposited Amount',
                                            ),
                                            enabled: false,
                                            initialValue:
                                                result["depo"].toString(),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (result["msg"] == "Y" &&
                                                  result["msgType"] == "ok") {
                                                Navigator.pushNamed(context,
                                                    GarbageCheckout.name,
                                                    arguments: result);
                                              }
                                            },
                                            child: const Text("Check-Out"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
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
            final result = await _networkHelper.checkOutTicket(_scanBarcode);
            setState(() {
              shownWidgets.add(
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            // shrinkWrap: true,
                            // physics:
                            //     const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              isChecked =
                                  List.filled(result["garbages"].length, false);
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Garbage Name',
                                          ),
                                          enabled: false,
                                          initialValue:
                                              "${result["garbages"][index]["gname"]}",
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Quantity',
                                          ),
                                          enabled: false,
                                          initialValue:
                                              "${result["garbages"][index]["qty"]}",
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Garbage Rate',
                                          ),
                                          enabled: false,
                                          initialValue:
                                              "${result["garbages"][index]["grate"]}",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              );
                            },
                            itemCount: result["garbages"].length,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Reference Number',
                          ),
                          enabled: false,
                          initialValue: result["ref_n"] ?? "",
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Name',
                          ),
                          enabled: false,
                          initialValue: result["nam"] ?? "",
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Deposited Amount',
                          ),
                          enabled: false,
                          initialValue: result["depo"].toString(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (result["msg"] == "Y" &&
                                result["msgType"] == "ok") {
                              Navigator.pushNamed(context, GarbageCheckout.name,
                                  arguments: result);
                            }
                          },
                          child: const Text("Check-Out"),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
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
