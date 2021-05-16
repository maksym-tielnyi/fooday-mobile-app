import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/facebook__icon_icons.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends StatelessWidget {
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
                            child: Text("Профіль",
                                style:
                                    Theme.of(context).textTheme.headline6))))),
            Row(
              children: [
                Container(
                  margin: EdgeInsetsDirectional.fromSTEB(20, 10, 10, 0),
                  child: Icon(
                    Icons.account_circle,
                    size: 90,
                  ),
                ),
                Text(
                  "Ваш профіль",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                )
              ],
            ),
            Container(
              margin: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.fromSTEB(0, 20, 20,0),
                    child: Text(
                      "Змінити логін",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsetsDirectional.fromSTEB(40, 10, 40, 20),
                    padding: EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Введіть новий логін",
                        filled: false,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.redAccent,
                    ),
                    // TextBox.fromLTRBD(30, 10, 100, 10, TextDirection.ltr),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(width: 4, color: Colors.black)),
            ),
            Container(
              margin: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.fromSTEB(0, 20, 20, 10),
                    child: Text(
                      "Змінити пароль",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsetsDirectional.fromSTEB(40, 10, 40, 20),
                    padding: EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Введіть поточний пароль",
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
                    margin: EdgeInsetsDirectional.fromSTEB(40, 0, 40, 20),
                    padding: EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Введіть новий пароль",
                        filled: false,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.redAccent,
                    ),
                    // TextBox.fromLTRBD(30, 10, 100, 10, TextDirection.ltr),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(width: 4, color: Colors.black)),
            ),
            Container(
              margin: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.fromSTEB(0, 20, 20,0),
                    child: Text(
                      "Змінити номер телефону",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsetsDirectional.fromSTEB(40, 10, 40, 20),
                    padding: EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Введіть новий номер",
                        filled: false,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.redAccent,
                    ),
                    // TextBox.fromLTRBD(30, 10, 100, 10, TextDirection.ltr),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(width: 4, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
