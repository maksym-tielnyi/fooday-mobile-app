import 'package:flutter/material.dart';
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
                      Image.network(
                          "https://images.unsplash.com/photo-1541963463532-d68292c34b19?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&w=1000&q=80",
                          width: 100,
                          height: 90),
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
    // TODO: specify real user id
    Results results = await DatabaseConnector.getQueryResultsAsync(
        SET_AMOUNT_QUERY, [item.amount, item.product.id, 1]);
    return true;
  }

  Future<bool> _deleteItemAsync() async {
    const DELETE_ITEM_QUERY = """
    DELETE FROM basket_products WHERE product_id = ? AND user_id = ?;
    """;
    BasketItem item = _basket[_index];
    // TODO: specify real user id
    Results results = await DatabaseConnector.getQueryResultsAsync(
        DELETE_ITEM_QUERY, [item.product.id, 1]);
    return true;
  }
}
