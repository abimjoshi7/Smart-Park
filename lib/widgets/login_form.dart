import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mypark/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_identifier.dart';
import '../constants/theme.dart';
import '../networking.dart';
import '../screens/screens.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late UserModel _userModel;
  String? userName;
  String? userPassword;
  late bool isVisible;
  final _formKey = GlobalKey<FormState>();
  late NetworkHelper _networkHelper;

  @override
  void initState() {
    _networkHelper = NetworkHelper();
    super.initState();
    isVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Wrap(runSpacing: 13, children: [
            TextFormField(
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.account_box_outlined),
                labelText: 'Username',
              ),
              textInputAction: TextInputAction.next,
              onSaved: (value) {
                userName = value;
              },
              validator: (userName) {
                if (userName!.isEmpty) {
                  return "User name cannot be empty";
                }
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              obscureText: isVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.key,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  icon: Icon(!isVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                ),
                labelText: 'Password',
              ),
              textInputAction: TextInputAction.done,
              onSaved: (value) {
                userPassword = value;
              },
              validator: (userPassword) {
                if (userPassword!.isEmpty) {
                  return "Password should not be empty";
                }
                return null;
              },
            ),
          ]),
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
          onPressed: () async {
            final preferences = await SharedPreferences.getInstance();
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              _userModel = await _networkHelper.logIn(userPassword!, userName!);

              if (_userModel.msg == "2") {
                // StorageHelper.save(userName!, _userModel.fn);
                // StorageHelper.save(userID, _userModel.uid.toString());
                await preferences.setString(persistUserName, _userModel.fn);
                await preferences.setBool(logStatus, true);
                await preferences.setString(
                    persistUserID, _userModel.uid.toString());
                Fluttertoast.showToast(
                    msg: "You are successfully logged in",
                    backgroundColor: kColorPrimary);
                if (!mounted) return;
                Navigator.pushNamed(context, RootScreen.name);
                // Navigator.pushNamedAndRemoveUntil(
                //     context, RootScreen.name, (Route route) => route.isFirst,
                //     arguments: _userModel);
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Invalid Credentials. Please try again.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            }
          },
          child: const Text(
            "LOGIN",
          ),
        )
      ],
    );
  }
}
