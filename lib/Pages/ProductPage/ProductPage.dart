import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/UserDataStorage.dart';
import 'package:mysql1/mysql1.dart';
import '../../DatabaseConnector.dart';
import '../../Models/ProductItem.dart';
import 'ProductRatingWidget.dart';
import 'UserReviewWidget.dart';

class ProductPage extends StatefulWidget {
  ProductItem _product;

  ProductPage(this._product);

  @override
  State<StatefulWidget> createState() {
    return _ProductPageState(_product);
  }
}

class _ProductPageState extends State<ProductPage> {
  final _DIVIDER = Divider(thickness: 2, indent: 10, endIndent: 10);
  ProductItem _product;
  bool _productInBasket;
  Future<ProductItem> _productFuture;
  Future<bool> _productInBasketFuture;

  _ProductPageState(this._product) {
    _productFuture = _getProductAsync();
    _productInBasketFuture = _getProductInBasketAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _productInBasketFuture = _getProductInBasketAsync();
            _productFuture = _getProductAsync();
          });
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              FutureBuilder(
                future: Future.wait([_productFuture, _productInBasketFuture]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  Widget imageWidget;
                  try {
                    imageWidget = Image.memory(_product.imageBlob.toBytes());
                  } catch (e) {
                    imageWidget = Icon(Icons.fastfood);
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data != null &&
                        snapshot.data[0] != null &&
                        snapshot.data[1] != null) {
                      _product = snapshot.data[0];
                      _productInBasket = snapshot.data[1];
                      return Column(children: [
                        imageWidget,
                        _bodyWidget()
                      ]);
                    }
                    return Center(child: Text("Відбулась помилка"));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      ),
    ));
  }

  Widget _bodyWidget() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Text(_product.name, style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 10),
            _addToBasketAndPriceRowWidget(),
            SizedBox(height: 20),
            _DIVIDER,
            SizedBox(height: 10),
            _productDescriptionWidget(),
            _productCaloriesWidget(),
            SizedBox(height: 10),
            _DIVIDER,
            SizedBox(height: 15),
            UserReviewWidget(_product, () {
              setState(() {});
            }),
            ProductRatingWidget(_product),
            SizedBox(height: 20)
          ],
        ));
  }

  Widget _addToBasketAndPriceRowWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(children: [
        Text(_product.price.toString() + " грн.",
            style: Theme.of(context).textTheme.headline5),
        Text(_product.weight, style: Theme.of(context).textTheme.caption)
      ], crossAxisAlignment: CrossAxisAlignment.start),
      _basketButton()
    ]);
  }

  Widget _productDescriptionWidget() {
    return _product.description == null
        ? Container()
        : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text("Опис", style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 15),
            Text(_product.description),
            SizedBox(height: 15),
          ]);
  }

  Widget _productCaloriesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Поживна цінність (100г):",
            style: Theme.of(context).textTheme.subtitle1),
        SizedBox(height: 5),
        Text("Калорії: ${_product.calories}"),
        Text("Білки: ${_product.proteins}"),
        Text("Жири: ${_product.fats}"),
        Text("Вуглеводи: ${_product.carbohydrates}")
      ],
    );
  }

  Widget _basketButton() {
    return FutureBuilder(
      future: _productInBasketFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            _productInBasket = snapshot.data;
            if (_productInBasket) {
              return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary)),
                  onPressed: () async {
                    await _deleteFromBasketAsync();
                    setState(() {
                      _productInBasketFuture = _getProductInBasketAsync();
                    });
                  },
                  child: Padding(
                      child: Text("Видалити з кошика",
                          style: TextStyle(color: Colors.black)),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15)));
            }
            return RaisedButton(
                elevation: 5,
                color: Theme.of(context).colorScheme.primary,
                onPressed: () async {
                  await _addToBasketAsync();
                  setState(() {
                    _productInBasketFuture = _getProductInBasketAsync();
                  });
                },
                child: Padding(
                    child: Text("Додати до кошика",
                        style: TextStyle(color: Colors.white)),
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 15)));
          }
          return Container();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<bool> _getProductInBasketAsync() async {
    int userId = await UserDataStorage().getIdAsync();
    final IN_BASKET_QUERY = """
    SELECT * FROM basket_products WHERE product_id = ? AND user_id = ?;
    """;
    Results results = await DatabaseConnector.getQueryResultsAsync(
        IN_BASKET_QUERY, [_product.id, userId]);
    if (results == null) {
      return null;
    }
    return results.length == 1;
  }

  Future<ProductItem> _getProductAsync() async {
    final PRODUCT_QUERY = """
SELECT *
FROM product
WHERE product_id = ?
    """;
    Results results = await DatabaseConnector.getQueryResultsAsync(
        PRODUCT_QUERY, [_product.id]);
    ProductItem product = _queryResultToProductItem(results);
    return product;
  }

  ProductItem _queryResultToProductItem(Results results) {
    var resultsList = results.toList(growable: false);
    if (resultsList.length != 1) {
      return null;
    }
    dynamic row = resultsList[0];
    Blob descBlob = row["description"];
    return ProductItem(row["product_id"], row["name"], row["weight"],
        row["price"], row["image"],
        description: descBlob != null ? descBlob.toString() : null,
        calories: row["calories"],
        proteins: row["proteins"],
        fats: row["fats"],
        carbohydrates: row["carbohydrates"]);
  }

  Future<Results> _deleteFromBasketAsync() async {
    final DELETE_QUERY = """
    DELETE FROM basket_products WHERE product_id = ? AND user_id = ?;
    """;
    int userId = await UserDataStorage().getIdAsync();
    return await DatabaseConnector.getQueryResultsAsync(
        DELETE_QUERY, [_product.id, userId]);
  }

  Future<Results> _addToBasketAsync() async {
    final ADD_QUERY = """
    INSERT INTO basket_products (user_id, product_id, amount) 
    VALUES (?, ?, ?); 
    """;
    int userId = await UserDataStorage().getIdAsync();
    return await DatabaseConnector.getQueryResultsAsync(
        ADD_QUERY, [userId, _product.id, userId]);
  }
}
