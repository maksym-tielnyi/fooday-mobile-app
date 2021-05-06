import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mysql1/mysql1.dart';
import '../../Models/ProductCategory.dart';
import '../../Models/ProductListItem.dart';
import '../../Models/AssortmentSortOption.dart';
import 'CategoryCard.dart';
import 'ProductsGridView.dart';
import 'FilterDialog.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  final _sortingOptions = [
    AssortmentSortOption("За назвою", "name", "ASC", Icons.arrow_downward),
    AssortmentSortOption("За назвою", "name", "DESC", Icons.arrow_upward),
    AssortmentSortOption("За ціною", "price", "DESC", Icons.arrow_downward),
    AssortmentSortOption("За ціною", "price", "ASC", Icons.arrow_upward)
  ];

  Future<List<ProductCategory>> _productCategories;
  Future<List<ProductListItem>> _products;
  Set<ProductCategory> _selectedCategories;
  AssortmentSortOption _sortingOption;
  String _filterQuery = "";

  _MainPageState() {
    _productCategories = _getProductCategoriesAsync();
    _products = _getProductsAsync();
    _selectedCategories = Set();
    _sortingOption = _sortingOptions[0];
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
                  padding: EdgeInsets.only(bottom: 5, top: 0),
                  child: Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width - 60,
                          height: 40,
                          child: Material(
                              color: Colors.transparent,
                              child: TextFormField(
                                initialValue: _filterQuery,
                                onChanged: (String value) {
                                  _filterQuery = value;
                                },
                                onEditingComplete: () {
                                  setState(() {
                                    _products = _getProductsAsync();
                                  });
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search_outlined,
                                        color: Colors.white),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white70)),
                                    hintText: "Пошук",
                                    hintStyle: TextStyle(color: Colors.white70),
                                    filled: true,
                                    border: InputBorder.none,
                                    hoverColor: Colors.black,
                                    fillColor: Colors.transparent),
                              ))))))),
      Expanded(
          child: Column(
        children: [
          FutureBuilder(
              future: _productCategories,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return Container(
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.filter_list),
                                onPressed: showFilterDialog),
                            ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: _selectedCategories.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CategoryCard(
                                    _selectedCategories.toList(
                                        growable: false)[index],
                                    (ProductCategory category) {
                                  setState(() {
                                    _selectedCategories.remove(category);
                                    _products = _getProductsAsync();
                                  });
                                });
                              },
                            ),
                            Card(
                                child: DropdownButton<AssortmentSortOption>(
                              underline: SizedBox(),
                              onChanged: (AssortmentSortOption value) {
                                setState(() {
                                  _sortingOption = value;
                                  _products = _getProductsAsync();
                                });
                              },
                              value: _sortingOption,
                              items: List.generate(
                                  _sortingOptions.length,
                                  (index) => DropdownMenuItem(
                                      value: _sortingOptions[index],
                                      child: Row(children: [
                                        Icon(_sortingOptions[index].icon),
                                        Text(_sortingOptions[index].name)
                                      ]))),
                            ))
                          ],
                        ),
                      ));
                }
                return Container();
              }),
          Expanded(
              child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _products = _getProductsAsync();
                    });
                    return null;
                  },
                  child: FutureBuilder(
                      future: _products,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data == null) {
                            return Center(child: Text("Виникла помилка"));
                          }
                          return ProductsGridView(snapshot.data);
                        }
                        return Center(child: CircularProgressIndicator());
                      })))
        ],
      ))
    ]));
  }

  void showFilterDialog() async {
    List<ProductCategory> categories = await _productCategories;
    await showDialog(
        context: context,
        builder: (BuildContext context) =>
            FilterDialog(categories, _selectedCategories));

    setState(() {
      _products = _getProductsAsync();
    });
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

    List<ProductListItem> result;
    result = await _getProductsWithFiltersAsync(connection);
    return result;
  }

  Future<List<ProductListItem>> _getProductsWithFiltersAsync(
      MySqlConnection connection) async {
    List<ProductCategory> categoriesList = _selectedCategories.isNotEmpty
        ? _selectedCategories.toList(growable: false)
        : await _productCategories;
    String categoryIdList = _getCategoriesStr(categoriesList);
    final ASSORTMENT_QUERY = """
SELECT product_price.product_id, name, weight, price, image, category_id
FROM ((SELECT product_price.product_id, MAX(start_datetime) last_change FROM product_price GROUP BY product_price.product_id) last_price 
INNER JOIN product_price ON product_price.product_id = last_price.product_id AND product_price.start_datetime = last_price.last_change
INNER JOIN product ON product_price.product_id = product.product_id)
WHERE (LOCATE(?, name) > 0) AND (product.category_id IN (${categoryIdList})) 
ORDER BY ${_sortingOption.sortingField} ${_sortingOption.sortingDirection}
""";
    var results;
    try {
      results = await connection.query(ASSORTMENT_QUERY, [_filterQuery]);
    } catch (e) {
      print("Exception: ${e}");
      rethrow;
    }
    connection.close();
    return _getProductItemsFromQueryResult(results);
  }

  List<ProductListItem> _getProductItemsFromQueryResult(dynamic results) {
    var products = List<ProductListItem>();
    for (var row in results) {
      products.add(ProductListItem(row[0], row[1], row[2], row[3], row[4]));
    }
    return products;
  }

  String _getCategoriesStr(List<ProductCategory> categories) {
    String selectedCategoriesStr = "";
    for (var c in categories) {
      selectedCategoriesStr += c.id.toString();
      if (c != categories.last) {
        selectedCategoriesStr += ", ";
      }
    }
    return selectedCategoriesStr;
  }
}
