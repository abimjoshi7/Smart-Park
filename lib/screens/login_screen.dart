import 'package:flutter/material.dart';
import 'package:mypark/widgets/login_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_identifier.dart';
import '../constants/theme.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class LoginScreen extends StatefulWidget {
  static const name = 'login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SharedPreferences? preferences;

  Future<void> initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initializePreferences().whenComplete(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              //logo area
              SliverToBoxAdapter(
                child: SizedBox(
                  height: height * 0.35,
                  child: Image.network(
                    preferences?.getString(appLogo) ?? kWelcomeImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              buildSliverSizedBox(height),
              //header area
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      // onTap: () {
                      //   Navigator.pushNamed(context, RootScreen.name,);
                      // },
                      onDoubleTap: () {
                        Navigator.pushNamed(
                          context,
                          AdminLoginScreen.name,
                        );
                      },
                      child: Text(
                        preferences?.getString(headerTitle) ??
                            "Podamibe Smart Park System",
                        style: kHeadTitle,
                      ),
                    ),
                  ],
                ),
              ),
              buildSliverSizedBox(height),
              //login area
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: width * 0.10),
                  child: const LoginForm(),
                ),
              ),
              buildSliverSizedBox(height),
              //copyright text area
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.20, vertical: 38.0),
                  child: Center(
                      child: Text(preferences?.getString(copyrightText) ??
                          "Powered By Podamibe Nepal")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter buildSliverSizedBox(double height) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: height * 0.04,
      ),
    );
  }
}
