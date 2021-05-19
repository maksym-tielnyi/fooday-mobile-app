import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fooday_mobile_app/UserDataStorage.dart';
import 'package:fooday_mobile_app/DatabaseConnector.dart';
import 'package:fooday_mobile_app/facebook__icon_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mysql1/mysql1.dart';
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
  String _loginInput = "";
  String _passwordInput = "";
  bool _lastTryError = false;

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
                            child: Text("Авторизація",
                                style:
                                    Theme.of(context).textTheme.headline6))))),
            Container(
              height: 50,
              margin: EdgeInsetsDirectional.fromSTEB(40, 130, 40, 0),
              padding: EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
              child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Введіть логин",
                    filled: false,
                  ),
                  onChanged: (String val) {
                    _loginInput = val;
                  }),
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
              child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Введіть пароль",
                    filled: false,
                  ),
                  onChanged: (String val) {
                    _passwordInput = val;
                  }),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.redAccent,
              ),
              // TextBox.fromLTRBD(30, 10, 100, 10, TextDirection.ltr),
            ),
            _lastTryError
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("Невірний логін або пароль",
                        style: TextStyle(color: Colors.redAccent)))
                : Container(),
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
                      "Регістрація",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  margin: EdgeInsetsDirectional.fromSTEB(50, 0, 20, 0),
                ),
                Container(
                  child: TextButton(
                    onPressed: () {
                      print("забули пароль");
                    },
                    child: Text(
                      "Забули пароль?",
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
                onPressed: _onLoginButtonPressAsync,
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(100, 50),
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  "Вхід",
                ),
              ),
            ),
            SizedBox(height: 90),
            Container(
              height: 50,
              child: Text(
                "Війти з допомогою:",
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
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Facebook_Icon.facebook,
                          size: 50,
                          color: Colors.redAccent,
                        )))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onLoginButtonPressAsync() async {
    EntryPage user = await _getUserAsync();
    if (user == null) {
      setState(() {
        _lastTryError = true;
      });
    } else {
      var storage = UserDataStorage();
      storage.setUsernameAsync(user.username);
      storage.setEmailAsync(user.email);
      storage.setIdAsync(user.id);
      storage.setPasswordAsync(user.password);
      switch (user.userRole) {
        case "customer":
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return HomePage();
          }), (route) => false);
          break;
        default:
          break;
      }
    }
  }

  Future<EntryPage> _getUserAsync() async {
    const USER_QUERY = """
    SELECT * FROM user WHERE email LIKE ? AND password LIKE ?;
    """;
    Results results = await DatabaseConnector.getQueryResultsAsync(
        USER_QUERY, [_loginInput, _passwordInput]);
    var resultsList = results.toList(growable: false);
    if (resultsList.length != 1) {
      return null;
    }
    var row = resultsList[0];
    return EntryPage(
        id: row["user_id"],
        username: row["username"],
        email: row["email"],
        userRole: row["role"],
        password: row["password"],
        phoneNumber: row["phoneNumber"]);

  }

  Future<void> _onGoogleAuthPress() async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ]);
    GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
    for (int i = 0; i < 100; i++) {
      print(signInAccount.email);
    }
  }
}
