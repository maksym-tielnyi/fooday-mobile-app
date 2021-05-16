import 'package:flutter/material.dart';
import 'MainPage/MainPage.dart';
import 'BasketPage/BasketPage.dart';
import 'ProductPage/ProfileScreen.dart';
import 'OrdersPage/OrdersPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // Add navigation pages here:
  List<Widget> _navigationPages = [
    MainPage(),
    BasketPage(),
    OrdersPage(),
    ProfileScreen(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navigationPages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: this._selectedIndex,
        items: [
          BottomNavigationBarItem(label: "Головна", icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              label: "Кошик", icon: Icon(Icons.shopping_basket)),
          BottomNavigationBarItem(
              label: "Завомлення", icon: Icon(Icons.delivery_dining)),
          BottomNavigationBarItem(label: "Профіль", icon: Icon(Icons.person))
        ],
        onTap: onNavBarTapHandler,
      ),
    );
  }

  void onNavBarTapHandler(int index) {
    this.setState(() {
      _selectedIndex = index;
    });
  }
}
