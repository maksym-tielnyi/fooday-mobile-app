import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Models/EntryPage.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final headerEllipseRadius = Radius.elliptical(80, 40);
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.only(
                      bottomLeft: headerEllipseRadius,
                      bottomRight: headerEllipseRadius)),
              child: SafeArea(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                          child: Text("Log in",
                              style: Theme.of(context).textTheme.headline6))))),
          Container(
            height: 50,
            margin: EdgeInsetsDirectional.fromSTEB(40, 130, 40, 0),
            color: Colors.deepOrange,
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Введите логин",
                fillColor: Colors.black12,
                filled: true,
              ),
            ),
            // TextBox.fromLTRBD(30, 10, 100, 10, TextDirection.ltr),
          ),
          Container(
            height: 50,
            margin: EdgeInsetsDirectional.fromSTEB(40, 50, 40, 0),
            color: Colors.deepOrange,
            // TextBox.fromLTRBD(30, 10, 100, 10, TextDirection.ltr),
          ),
          Container(
            height: 50,
            child: Text(
              "Forgot your pass?",
              style: Theme.of(context).textTheme.headline6,
            ),
            margin: EdgeInsetsDirectional.fromSTEB(40, 50, 40, 0),
          )
        ],
      ),
    );
  }
}
