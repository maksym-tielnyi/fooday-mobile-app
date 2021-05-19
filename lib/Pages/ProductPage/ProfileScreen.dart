import 'dart:ui';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/UserDataStorage.dart';
import 'package:fooday_mobile_app/facebook__icon_icons.dart';
import 'package:fooday_mobile_app/telegram_icon_icons.dart';

import '../URL.dart';

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
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                      child: Column(
                        children: [
                          Container(
                            margin:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 20, 0),
                            child: Text(
                              "Змінити логін",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            height: 50,
                            margin:
                                EdgeInsetsDirectional.fromSTEB(40, 10, 40, 20),
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Введіть новий логін",
                                filled: false,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
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
                            margin:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 20, 10),
                            child: Text(
                              "Змінити пароль",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            height: 50,
                            margin:
                                EdgeInsetsDirectional.fromSTEB(40, 10, 40, 20),
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Введіть поточний пароль",
                                filled: false,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: Colors.redAccent,
                            ),
                            // TextBox.fromLTRBD(30, 10, 100, 10, TextDirection.ltr),
                          ),
                          Container(
                            height: 50,
                            margin:
                                EdgeInsetsDirectional.fromSTEB(40, 0, 40, 20),
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Введіть новий пароль",
                                filled: false,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
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
                      margin: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 15),
                      child: Column(
                        children: [
                          Container(
                            margin:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 20, 0),
                            child: Text(
                              "Змінити номер телефону",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            height: 50,
                            margin:
                                EdgeInsetsDirectional.fromSTEB(40, 10, 40, 20),
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Введіть новий номер",
                                filled: false,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
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
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 50),
                            side: BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: Text(
                          "Зберегти зміни",
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.fromSTEB(40, 15, 40, 20),

                      child: ElevatedButton(
                        onPressed: URL.launchURL,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                            minimumSize: Size(100, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),

                        child: Row(
                          children: [
                            SizedBox(width: 8),
                            Icon(Telegram_icon.telegram_plane),
                            SizedBox(width: 20),
                            Text(
                              "Перейти до Телеграм-боту",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
