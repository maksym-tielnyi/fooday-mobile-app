import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/facebook__icon_icons.dart';
import '../Models/EntryPage.dart';
import 'package:fooday_mobile_app/google__icon_icons.dart';
import 'LoginScreen.dart';
import 'HomeScreen.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){return HomePage();}), (route) => false);
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
                onPressed: () {
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
}
