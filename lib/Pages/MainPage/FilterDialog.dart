import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mysql1/mysql1.dart';
import '../../Models/ProductCategory.dart';
import '../../Models/ProductItem.dart';
import 'CategoryCard.dart';
import 'ProductsGridView.dart';

class FilterDialog extends StatefulWidget {
  List<ProductCategory> _categories;
  Set<ProductCategory> _selected;

  FilterDialog(this._categories, this._selected);

  @override
  State<StatefulWidget> createState() =>
      _FilterDialogState(_categories, _selected);
}

class _FilterDialogState extends State<FilterDialog> {
  List<ProductCategory> _categories;
  Set<ProductCategory> _selected;

  _FilterDialogState(this._categories, this._selected);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Категорії товарів"),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _categories.length,
              itemBuilder: (BuildContext context, int index) => Row(
                children: [
                  Checkbox(
                    value: _selected.contains(_categories[index]),
                    onChanged: (bool checked) {
                      setState(() {
                        if (checked) {
                          _selected.add(_categories[index]);
                        } else {
                          _selected.remove(_categories[index]);
                        }
                      });
                    },
                  ),
                  Text(_categories[index].name)
                ],
              )),
        ));
  }
}
