import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../Models/ProductListItem.dart';

class ProductCard extends StatelessWidget {
  ProductListItem _item;

  ProductCard(ProductListItem item) {
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
              // Show product page
              print(_item.name);
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
