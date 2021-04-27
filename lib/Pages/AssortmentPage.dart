import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/rendering.dart';
import '../Models/ProductCategory.dart';

class AssortmentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AssortmentPageState();
  }
}

class _AssortmentPageState extends State<AssortmentPage> {
  List<ProductCategory> _productCategories;

  @override
  Widget build(BuildContext context) {
    final headerEllipseRadius = Radius.elliptical(80, 40);

    _getProductCategories();
    return Container(
        child: Column(children: [
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
      Container(
          height: 50,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: _productCategories.length,
            itemBuilder: (BuildContext context, int index) {
              return _CategoryCard(_productCategories[index]);
            },
          ))
    ]));
  }

  void _getProductCategories() {
    _productCategories = [
      ProductCategory(0, "Теплі страви"),
      ProductCategory(1, "Холодні страви"),
      ProductCategory(2, "Закуски"),
      ProductCategory(3, "Десерти"),
      ProductCategory(4, "Напої")
    ];
  }
}

class _CategoryCard extends StatelessWidget {
  ProductCategory _category;

  _CategoryCard(ProductCategory category) {
    _category = category;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            height: 50,
            padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
            // decoration: BoxDecoration(color: Colors.white, boxShadow: [
            //   BoxShadow(
            //       offset: Offset.fromDirection(0.25 * pi), blurRadius: 10.0)
            // ]),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Icon(Icons.fastfood), Text(_category.name)])));
  }
}
