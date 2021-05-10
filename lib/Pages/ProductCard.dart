import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../Models/ProductItem.dart';
import 'ProductPage/ProductPage.dart';

class ProductCard extends StatelessWidget {
  ProductItem _item;

  ProductCard(ProductItem item) {
    _item = item;
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    try {
      imageWidget = Image.memory(_item.imageBlob.toBytes());
    } catch (e) {
      imageWidget = Icon(Icons.fastfood);
    }
    return Card(
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductPage(_item)));
            },
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(flex: 1),
                imageWidget,
                Spacer(flex: 5),
                Text(_item.name),
                Spacer(flex: 1),
                Row(
                  children: [
                    Spacer(flex: 1),
                    Text(_item.weight.toString(),
                        style: Theme.of(context).textTheme.caption),
                    Spacer(flex: 4),
                    Text("${_item.price.toString()} грн.",
                        style: Theme.of(context).textTheme.subtitle1),
                    Spacer(flex: 1)
                  ],
                ),
                Spacer(flex: 1)
              ],
            ))));
  }
}
