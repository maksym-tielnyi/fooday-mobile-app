import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/UserDataStorage.dart';
import 'package:mysql1/mysql1.dart';
import '../facebook__icon_icons.dart';
import '../Models/EntryPage.dart';
import 'package:fooday_mobile_app/google__icon_icons.dart';
import 'LoginScreen.dart';
import 'HomeScreen.dart';
import '../DatabaseConnector.dart';
import '../UserDataStorage.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final emailController = new TextEditingController();
    final loginController = new TextEditingController();
    final passwordController = new TextEditingController();
    final repeatedPasswordController = new TextEditingController();
    final phoneNumberController = new TextEditingController();

    String email;
    String username;
    String password;
    String phoneNumber;
    String repeatedPass;

    final headerEllipseRadius = Radius.elliptical(80, 40);
    return Material(
      color: Colors.white,
      child: Center(
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
                            child: Text("Реєстрація",
                                style:
                                Theme.of(context).textTheme.headline6))))),
            Container(
              height: 50,
              margin: EdgeInsetsDirectional.fromSTEB(40, 80, 40, 0),
              padding: EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
              child: TextField(
                controller: loginController,
                onChanged: (login){username = login;},
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Введіть логін",
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
                controller: emailController,
                onChanged: (email_1){email = email_1;},
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Введіть пошту",
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
                controller: phoneNumberController,
                onChanged: (number){phoneNumber = number;},
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Введіть номер телефону",
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
                controller: passwordController,
                onChanged: (pass){password = pass;},
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
            Container(
              height: 50,
              margin: EdgeInsetsDirectional.fromSTEB(40, 40, 40, 0),
              padding: EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
              child: TextField(
                controller: repeatedPasswordController,
                onChanged: (r_pass){repeatedPass = r_pass;},
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Повторите пароль",
                  filled: false,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.redAccent,
              ),
              // TextBox.fromLTRBD(30, 10, 100, 10, TextDirection.ltr),
            ),
            SizedBox(height: 50),
            Container(
              child: ElevatedButton(
                onPressed: () async {
                  if(password == repeatedPass && username != "" && password != "" && phoneNumber != "" && email != ""){
                    const String query = """
                    Insert into user (username, email, password, phone_number, role)
                    values (?, ?, ?, ?, ?)
                    """;

                    await DatabaseConnector.getQueryResultsAsync(query, [username, email, password, phoneNumber, "customer"]);

                    EntryPage user = await _getUserAsync(email, password);

                    UserDataStorage().setIdAsync(user.id);
                    UserDataStorage().setEmailAsync(user.email);
                    UserDataStorage().setUsernameAsync(user.username);

                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){return HomePage();}), (route) => false);

                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(100, 50),
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  "Зарегистрироваться",
                ),
              ),
            ),
            Container(
              child: TextButton(
                onPressed: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){return LoginScreen();}), (route) => false);

                },
                child: Text(
                  "Уже есть аккаунт?",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              margin: EdgeInsetsDirectional.fromSTEB(50, 0, 45, 0),
            ),
          ],
        ),
      ),
    );

  }
  Future<EntryPage> _getUserAsync(email, password) async {
    const USER_QUERY = """
    SELECT * FROM user WHERE email LIKE ? AND password LIKE ?;
    """;
    Results results = await DatabaseConnector.getQueryResultsAsync(
        USER_QUERY, [email, password]);
    var resultsList = results.toList(growable: false);
    if (resultsList.length != 1) {
      return null;
    }
    var row = resultsList[0];
    return EntryPage(
        id: row["user_id"],
        username: row["username"],
        email: row["email"],
        userRole: row["role"]);
  }
}
