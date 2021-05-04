import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mysql1/mysql1.dart';
import '../../Models/ProductCategory.dart';
import '../../Models/ProductListItem.dart';
import 'CategoryCard.dart';
import 'ProductsGridView.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  Future<List<ProductCategory>> _productCategories;
  Future<List<ProductListItem>> _products;

  _MainPageState() {
    _productCategories = _getProductCategoriesAsync();
    _products = _getProductsAsync();
  }

  @override
  Widget build(BuildContext context) {
    final headerEllipseRadius = Radius.elliptical(80, 40);

    return Container(
        child: Column(//crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Text("Search bar",
                          style: Theme.of(context).textTheme.headline6))))),
      Expanded(
          child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _productCategories = _getProductCategoriesAsync();
                  _products = _getProductsAsync();
                });
                return null;
              },
              child: FutureBuilder(
                  future: Future.wait([_productCategories, _products]),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data[0] == null ||
                          snapshot.data[1] == null) {
                        return Center(child: Text("Виникла помилка"));
                      }
                      return Column(children: [
                        Container(
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: snapshot.data[0].length,
                              itemBuilder: (BuildContext context, int index) {
                                return CategoryCard(snapshot.data[0][index]);
                              },
                            )),
                        Text(
                          "Рекомендуємо:",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Expanded(child: ProductsGridView(snapshot.data[1]))
                      ]);
                    }
                    return Center(child: CircularProgressIndicator());
                  })))
    ]));
  }

  Future<List<ProductCategory>> _getProductCategoriesAsync() async {
    var settings = new ConnectionSettings(
        host: '10.0.2.2',
        port: 3306,
        user: 'root',
        password: 'YflOe234fOEM',
        db: 'fooday');
    MySqlConnection connection;
    try {
      connection = await MySqlConnection.connect(settings);
    } catch (e) {
      return null;
    }

    final CATEGORIES_QUERY = "SELECT category_id, name FROM product_category;";
    var results;
    try {
      results = await connection.query(CATEGORIES_QUERY);
    } catch (e) {
      print("Exception: ${e}");
      rethrow;
    }
    connection.close();

    List<ProductCategory> categories = List();
    for (var row in results) {
      Blob nameBlob = row[1];
      categories.add(ProductCategory(row[0], nameBlob.toString()));
    }
    return categories;
  }

  Future<List<ProductListItem>> _getProductsAsync() async {
    var settings = new ConnectionSettings(
        host: '10.0.2.2',
        port: 3306,
        user: 'root',
        password: 'YflOe234fOEM',
        db: 'fooday');
    MySqlConnection connection;
    try {
      connection = await MySqlConnection.connect(settings);
    } catch (e) {
      return null;
    }

    final ASSORTMENT_QUERY = """
SELECT product_price.product_id, name, weight, price, image
FROM (SELECT product_price.product_id, MAX(start_datetime) last_change FROM product_price GROUP BY product_price.product_id) last_price 
INNER JOIN product_price ON product_price.product_id = last_price.product_id AND product_price.start_datetime = last_price.last_change
INNER JOIN product ON product_price.product_id = product.product_id;
""";
    var results;
    try {
      results = await connection.query(ASSORTMENT_QUERY);
    } catch (e) {
      print("Exception: ${e}");
      rethrow;
    }
    connection.close();

    var products = List<ProductListItem>();
    for (var row in results) {
      products.add(ProductListItem(row[0], row[1], row[2], row[3], row[4]));
    }
    return products;
  }
}
