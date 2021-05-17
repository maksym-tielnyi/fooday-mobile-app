import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/facebook__icon_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Models/EntryPage.dart';
import 'package:fooday_mobile_app/google__icon_icons.dart';
import 'HomeScreen.dart';
import 'RegistrationScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount _currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        "501367131765-rr597dinschg0b984qdgh3lg5c5u2kcg.apps.googleusercontent.com",
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Widget build(BuildContext context) {
    final headerEllipseRadius = Radius.elliptical(80, 40);
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                        bottomLeft: headerEllipseRadius,
                        bottomRight: headerEllipseRadius)),
                child: SafeArea(
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                            child: Text("Log in",
                                style:
                                    Theme.of(context).textTheme.headline6))))),
            Container(
              height: 50,
              margin: EdgeInsetsDirectional.fromSTEB(40, 130, 40, 0),
              padding: EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Введите логин",
                  filled: false,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.redAccent,
              ),
              // TextBox.fromLTRBD(30, 10, 100, 10, TextDirection.ltr),
            ),
            Container(
              height: 50,
              margin: EdgeInsetsDirectional.fromSTEB(40, 40, 40, 0),
              padding: EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Введите пароль",
                  filled: false,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.redAccent,
              ),
              // TextBox.fromLTRBD(30, 10, 100, 10, TextDirection.ltr),
            ),
            Row(
              children: [
                Container(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return RegistrationScreen();
                      }), (route) => false);
                    },
                    child: Text(
                      "Регистрация",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  margin: EdgeInsetsDirectional.fromSTEB(50, 0, 20, 0),
                ),
                Container(
                  child: TextButton(
                    onPressed: () {
                      print("забыли пароль");
                    },
                    child: Text(
                      "Забыли пароль?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  margin: EdgeInsetsDirectional.fromSTEB(0, 0, 40, 0),
                ),
              ],
            ),
            SizedBox(height: 100),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return HomePage();
                  }), (route) => false);
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(100, 50),
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  "Вход",
                ),
              ),
            ),
            SizedBox(height: 90),
            Container(
              height: 50,
              child: Text(
                "Войти с помощью:",
                style: Theme.of(context).textTheme.headline6,
              ),
              margin: EdgeInsetsDirectional.fromSTEB(40, 20, 40, 0),
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsetsDirectional.fromSTEB(110, 0, 40, 0),
                    child: IconButton(
                        onPressed: _onGoogleAuthPress,
                        icon: Icon(
                          Google_Icon.gplus,
                          size: 50,
                          color: Colors.redAccent,
                        ))),
                Container(
                    margin: EdgeInsetsDirectional.fromSTEB(10, 0, 40, 0),
                    child: Icon(
                      Facebook_Icon.facebook,
                      size: 50,
                      color: Colors.redAccent,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onGoogleAuthPress() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            "501367131765-rr597dinschg0b984qdgh3lg5c5u2kcg.apps.googleusercontent.com");
    GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
    print(signInAccount.email);
  }
}
