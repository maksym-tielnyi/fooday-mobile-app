import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/Models/ProductCategory.dart';

class CategoryCard extends StatelessWidget {
  ProductCategory _category;

  CategoryCard(ProductCategory category) {
    _category = category;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: GestureDetector(
            onTap: () {
              print(_category.name);
            },
            child: Container(
                height: 50,
                padding: EdgeInsetsDirectional.fromSTEB(7, 10, 7, 10),
                child: Center(child: Text(_category.name)))));
  }
}
