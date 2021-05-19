import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/Pages/CourierPage.dart';
import 'package:fooday_mobile_app/Pages/LoginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FooDay',
      // color: Colors.red[300],
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.black,
      ),
      home: LoginScreen(),
      //home: CourierOrdersPage()
    );
  }
}
