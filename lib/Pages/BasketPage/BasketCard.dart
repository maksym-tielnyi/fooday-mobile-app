import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/UserDataStorage.dart';
import 'package:mysql1/mysql1.dart';
import '../../DatabaseConnector.dart';
import '../../Models/BasketItem.dart';

class BasketCard extends StatelessWidget {
  final List<BasketItem> _basket;
  final int _index;
  final Function() _onListChanged;

  BasketCard(this._basket, this._index, this._onListChanged);

  @override
  Widget build(BuildContext context) {
    BasketItem item = _basket[_index];
    Widget imageWidget;
    const double IMAGE_WIDTH = 100;
    try {
      imageWidget = Image.memory(item.product.imageBlob.toBytes(), width: IMAGE_WIDTH);
    } catch (e) {
      imageWidget = Container(child: Icon(Icons.fastfood), width: IMAGE_WIDTH);
    }
    return Dismissible(
        key: GlobalKey(),
        onDismissed: (DismissDirection direction) {
          _onDeleteItemAsync();
        },
        child: GestureDetector(
            onTap: () {
              print(item.product.name);
            },
            child: Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      imageWidget,
                      SizedBox(width: 10),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(item.product.name,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.subtitle2),
                          SizedBox(height: 7),
                          Row(
                            children: [
                              Text(item.product.price.toString() + " грн.",
                                  style: Theme.of(context).textTheme.subtitle1),
                              SizedBox(width: 10),
                              Text(item.product.weight,
                                  style: Theme.of(context).textTheme.caption)
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.exposure_minus_1),
                                onPressed: item.amount > 1
                                    ? () async {
                                        item.amount--;
                                        await _setAmountAsync();
                                        _onListChanged();
                                      }
                                    : null,
                              ),
                              Text("${item.amount.toString()} шт."),
                              IconButton(
                                icon: Icon(Icons.plus_one),
                                onPressed: () async {
                                  item.amount++;
                                  await _setAmountAsync();
                                  _onListChanged();
                                },
                              ),
                              Spacer(flex: 1),
                              IconButton(
                                icon: Icon(Icons.cancel_outlined,
                                    color: Colors.redAccent),
                                onPressed: _onDeleteItemAsync,
                              )
                            ],
                          )
                        ],
                      ))
                    ],
                  )),
            )));
  }

  void _onDeleteItemAsync() async {
    _deleteItemAsync();
    _basket.removeAt(_index);
    _onListChanged();
  }

  Future<bool> _setAmountAsync() async {
    const SET_AMOUNT_QUERY = """
    UPDATE basket_products SET amount = ? WHERE product_id = ? AND user_id = ?;
    """;
    BasketItem item = _basket[_index];
    int userId = await UserDataStorage().getIdAsync();
    Results results = await DatabaseConnector.getQueryResultsAsync(
        SET_AMOUNT_QUERY, [item.amount, item.product.id, userId]);
    return true;
  }

  Future<bool> _deleteItemAsync() async {
    const DELETE_ITEM_QUERY = """
    DELETE FROM basket_products WHERE product_id = ? AND user_id = ?;
    """;
    BasketItem item = _basket[_index];
    int userId = await UserDataStorage().getIdAsync();
    Results results = await DatabaseConnector.getQueryResultsAsync(
        DELETE_ITEM_QUERY, [item.product.id, userId]);
    return true;
  }
}
