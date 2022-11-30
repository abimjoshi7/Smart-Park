import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_identifier.dart';
import '../constants/theme.dart';
import 'screens.dart';

class RootScreen extends StatefulWidget {
  static const name = 'home-screen';

  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Widget> _widgets = [
    const CheckIn(),
    const CheckOut(),
  ];
  SharedPreferences? preferences;
  String? firstName;
  String? uid;

  Future<void> initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      firstName = preferences!.getString(persistUserName);
      uid = preferences!.getString(persistUserID);
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    initializePreferences();
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as UserModel;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome, ${firstName ?? ""}'),
          automaticallyImplyLeading: false,
          actions: [
            Row(
              children: [
                //settings
                Visibility(
                  visible: uid == "8095" ? true : false,
                  // visible: true,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Settings.name,
                      );
                      // Navigator.pushNamed(context, Settings.name,
                      //     arguments: args);
                    },
                    icon: const Icon(
                      Icons.settings,
                    ),
                  ),
                ),
                //print
                // IconButton(
                //   onPressed: () async {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: ((context) => const TestScreen()),
                //       ),
                //     );
                //   },
                //   icon: const Icon(Icons.print),
                // ),
                //logout
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text(
                          "Smart Park System",
                          textAlign: TextAlign.center,
                        ),
                        content: const Text(
                          "Are you sure?",
                          textAlign: TextAlign.center,
                        ),
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                        actions: [
                          Row(
                            children: [
                              Flexible(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final preferences =
                                        await SharedPreferences.getInstance();
                                    await preferences.setBool(logStatus, false);
                                    await preferences.clear();
                                    await preferences.remove(logStatus).then(
                                        (value) => Navigator.popAndPushNamed(
                                            context, LoginScreen.name));
                                    // if (args["user_name"] == "Super Admin" &&
                                    //     args["user_id"] == "1") {
                                    //   _networkHelper.deleteConfig().then(
                                    //         (value) => Navigator.popAndPushNamed(
                                    //             context, LoginScreen.name),
                                    //       );
                                    // }
                                  },
                                  child: const Text("Logout"),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: kColorPrimary),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(height * 0.04),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.door_front_door_outlined),
                  text: "Check-in",
                ),
                Tab(
                  icon: Icon(Icons.door_back_door_outlined),
                  text: "Check-out",
                )
              ],
            ),
          ),
        ),
        body: TabBarView(controller: _tabController, children: _widgets),
      ),
    );
  }
}
