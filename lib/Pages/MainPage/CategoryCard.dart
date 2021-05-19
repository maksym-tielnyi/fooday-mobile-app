import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/Models/ProductCategory.dart';

class CategoryCard extends StatelessWidget {
  ProductCategory _category;
  Function(ProductCategory category) _onClick;

  CategoryCard(this._category, this._onClick);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: GestureDetector(
            onTap: () {
              _onClick(_category);
            },
            child: Container(
                height: 40,
                padding: EdgeInsetsDirectional.fromSTEB(7, 10, 7, 10),
                child: Row(
                  children: [
                    Text(_category.name),
                    Icon(Icons.clear)
                  ],
                ))));
  }
}
