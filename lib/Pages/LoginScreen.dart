import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/facebook__icon_icons.dart';
import '../Models/EntryPage.dart';
import 'package:fooday_mobile_app/google__icon_icons.dart';

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
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.only(
                      bottomLeft: headerEllipseRadius,
                      bottomRight: headerEllipseRadius)),
              child: SafeArea(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                          child: Text("Log in",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline6))))),
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
          Container(
            height: 50,
            child: Text(
              "Забыли пароль?",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline6,
            ),
            margin: EdgeInsetsDirectional.fromSTEB(40, 20, 40, 0),
          ),
          Container(
            margin: EdgeInsetsDirectional.fromSTEB(40, 0, 40, 0),
            height: 50,
            child: RaisedButton(
              child: Text("Вход"),


            ),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            color: Colors.redAccent,
            ),
          ),
          Container(
            height: 50,
            child: Text(
              "Войти с помощью:",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline6,
            ),
            margin: EdgeInsetsDirectional.fromSTEB(40, 20, 40, 0),
          ),


          Row(
            children: [
              Container(
                  margin: EdgeInsetsDirectional.fromSTEB(120, 0, 40, 0),
                  child: Icon(
                    Google_Icon.gplus,
                    size: 50,
                  )
              ),
              Container(
                  margin: EdgeInsetsDirectional.fromSTEB(10, 0, 40, 0),
                  child: Icon(
                    Facebook_Icon.facebook,
                    size: 50,
                  )
              )
            ],
          ),
        ],
      ),
    );
  }
}
