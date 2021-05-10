import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../Models/ProductItem.dart';
import '../ProductCard.dart';

class ProductsGridView extends StatelessWidget {
  List<ProductItem> _products;

  ProductsGridView(List<ProductItem> products) {
    this._products = products;
  }

  @override
  Widget build(BuildContext context) {
    final int PORTRAIT_COLUMNS = 2;
    final int LANDSCAPE_COLUMNS = 4;
    int columnsCount =
        (MediaQuery.of(context).orientation == Orientation.portrait)
            ? PORTRAIT_COLUMNS
            : LANDSCAPE_COLUMNS;

    return GridView.count(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        crossAxisCount: columnsCount,
        children: List<Widget>.generate(
            _products.length, (int index) => ProductCard(_products[index])));
  }
}
