import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mypark/constants/theme.dart';
import 'package:mypark/networking.dart';
import 'package:mypark/widgets/print_receipt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_identifier.dart';

class VisitorDashboard extends StatefulWidget {
  static const name = "visitor-dashboard";
  const VisitorDashboard({Key? key}) : super(key: key);

  @override
  State<VisitorDashboard> createState() => _VisitorDashboardState();
}

class _VisitorDashboardState extends State<VisitorDashboard> {
  String visitorName = "";
  PrintReceipt? printReceipt;
  late TextEditingController _textEditingController;
  SharedPreferences? preferences;
  late StreamController<List<Map<String, dynamic>>> _streamController;
  late NetworkHelper _networkHelper;
  String? _scanBarcode;
  List<Map<String, dynamic>> list = [];
  List<String> stickerList = [];
  List<String> gnameList = [];
  List<String> gidList = [];
  List<String> grateList = [];
  List<String> gtotalList = [];
  List<String> gqtyList = [];
  List<dynamic> garbageList = [];
  // ignore: prefer_typing_uninitialized_variables
  var totalAmount;
  String? sid;
  late TextEditingController _scanGarbageController;
  final _focusNode = FocusNode();

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

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) {
      _streamController.sink.addStream(barcode);
    });
  }

  Future<void> initializePrefs() async {
    preferences = await SharedPreferences.getInstance();
    visitorName = (preferences!.getString(visitorName))!;
  }

  @override
  void initState() {
    initializePrefs();
    _textEditingController =
        TextEditingController.fromValue(TextEditingValue.empty);
    _scanGarbageController =
        TextEditingController.fromValue(TextEditingValue.empty);
    _networkHelper = NetworkHelper();
    _streamController = StreamController();
    super.initState();
    _streamController.sink.add([
      {
        "sid": 0,
        "gid": 0,
        "gname": "Initial Item",
        "grate": 0,
        "msg": "Y",
        "msgType": "ok",
        "nam": null,
        "ref_n": null,
        "bar": null,
        "garbages": null,
        "cnam": null,
        "phone": null,
        "depo": 0,
        "tt": null,
        "sname": null,
        "tot": null,
        "ad": null,
        "sd": null
      },
    ]);
    printReceipt = PrintReceipt();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${args["Nam"]}"),
      ),
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _streamController.stream,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.028, right: width * 0.028, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              child: Text(
                                "Date: ${preferences!.getString(buyDate)!}",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Card(
                              child: Text(
                                "Time: ${preferences!.getString(checkInTime)!}",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        //pinned header
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "Name",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Price",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: kColorPrimary.withAlpha(50),
                          height: height * 0.4,
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (_, int index) {
                                return ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data![index]["gname"]
                                              .toString(),
                                        ),
                                        Text(
                                          snapshot.data![index]["grate"]
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Text(
                            "TOTAL",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            "Amount: Rs ${totalAmount ?? 0}  ",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(),

                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextField(
                                autofocus: true,
                                focusNode: _focusNode,
                                controller: _scanGarbageController,
                                decoration: const InputDecoration(
                                    labelText: "Scan Garbage"),
                                onSubmitted: (v) async {
                                  v = v.substring(0, v.length - 1);
                                  if (v.length == 11) {
                                    _scanGarbageController.text = v;
                                    await _networkHelper
                                        .checkInGarbage(
                                      _scanGarbageController.text,
                                      preferences!
                                          .getString(persistUserID)
                                          .toString(),
                                      preferences!
                                          .getString(referenceNum)
                                          .toString(),
                                    )
                                        .then((value) {
                                      if (value["msg"] == "Y") {
                                        return list.add(value);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Already scanned",
                                            backgroundColor: kColorPrimary);
                                      }
                                    });
                                  }
                                  stickerList.add("$_scanBarcode");
                                  _streamController.add(list);
                                  totalAmount = list
                                      .map((e) => e["grate"])
                                      .toList()
                                      .reduce(
                                          (value, element) => value + element);
                                  sid = list
                                      .map((element) {
                                        return element["sid"];
                                      })
                                      .toList()
                                      .join(',');
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
                                  _focusNode.requestFocus();
                                  _scanGarbageController.clear();
                                });
                              },
                              child: const Text("Scan Next"),
                            ))
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () async {
              Map<String, dynamic> result;
              showDialog(
                  context: context,
                  builder: (_) => Dialog(
                        child: SizedBox(
                          height: height * 0.4,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _textEditingController,
                                  decoration: const InputDecoration(
                                      labelText: "Deposit Amount"),
                                  onSubmitted: (v) {
                                    _textEditingController.text = v;
                                    preferences!.setDouble(
                                        depositAmount,
                                        double.parse(
                                            _textEditingController.text));
                                  },
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Okay"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )).then((value) async {
                result = await _networkHelper.garbageDeposit(
                    preferences!.getString(userTicketNumber)!,
                    sid!,
                    totalAmount.toString(),
                    _textEditingController.text);
                garbageList.addAll(result["garbages"]);
                gidList
                    .add(garbageList.map((e) => e!["gid"]).toList().join(','));
                gnameList.add(
                    garbageList.map((e) => e!["gname"]).toList().join(','));
                grateList.add(
                    garbageList.map((e) => e!["grate"]).toList().join(','));
                gtotalList
                    .add(garbageList.map((e) => e!["tot"]).toList().join(','));
                gqtyList
                    .add(garbageList.map((e) => e!["qty"]).toList().join(','));
                // print("GARBAGELIST:" +
                //     garbageList.map((e) => e!["grate"]).toList().join(','));
                double netTotal = result["tot"] - result["depo"];

                if (result["msg"] == "Y") {
                  preferences!.setString(visitorName, result["nam"]);
                  preferences!.setString(referenceNum, result["ref_n"]);
                  preferences!.setString(userTicketNumber, result["bar"]);
                  preferences!.setDouble(depositAmount, result["depo"]);
                  preferences!.setDouble(garbageTotal, result["tot"]);
                  preferences!.setDouble(garbageNetTotal, netTotal.abs());
                  preferences!.setStringList(garbageListId, gidList);
                  preferences!.setStringList(garbageListName, gnameList);
                  preferences!.setStringList(garbageListRate, grateList);
                  preferences!.setStringList(garbageListTotal, gtotalList);
                  preferences!.setStringList(garbageListQuantity, gqtyList);
                  Fluttertoast.showToast(
                      msg: "Verification Completed",
                      backgroundColor: kColorPrimary);
                  printReceipt!.printCheckIn();
                  if (!mounted) return;
                  Navigator.of(context).pop;

                  // printReceipt?.printCheckIn();
                }
              });
            },
            label: Row(
              children: const [
                Icon(Icons.done_all_outlined),
                SizedBox(
                  width: 5,
                ),
                Text("Verify"),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          FloatingActionButton.extended(
            onPressed: () async {
              await scanQR().then((value) async {
                await _networkHelper
                    .checkInGarbage(
                  _scanBarcode!,
                  preferences!.getString(persistUserID).toString(),
                  preferences!.getString(referenceNum).toString(),
                )
                    .then((value) {
                  if (value["msg"] == "Y") {
                    return list.add(value);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Already scanned", backgroundColor: kColorPrimary);
                  }
                });
                stickerList.add("$_scanBarcode");
                _streamController.add(list);
                totalAmount = list
                    .map((e) => e["grate"])
                    .toList()
                    .reduce((value, element) => value + element);
                sid = list
                    .map((element) {
                      return element["sid"];
                    })
                    .toList()
                    .join(',');
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.sink.close();
    _textEditingController.dispose();
    _scanGarbageController.dispose();
  }
}
