import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../../DatabaseConnector.dart';
import '../../Models/ProductItem.dart';
import 'ImagesCarouselView.dart';
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
  Future<ProductItem> _productFuture;

  _ProductPageState(this._product) {
    _productFuture = _getProductAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _productFuture = _getProductAsync();
          });
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              FutureBuilder(
                future: _productFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data != null) {
                      _product = snapshot.data;
                      return Column(children: [
                        ImagesCarouselView(_product),
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
      RaisedButton(
          elevation: 5,
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {},
          child: Padding(
              child: Text("Додати до кошика",
                  style: TextStyle(color: Colors.white)),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15)))
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

  Future<ProductItem> _getProductAsync() async {
    final PRODUCT_QUERY = """
    SELECT *
FROM ((SELECT product_price.product_id, MAX(start_datetime) last_change FROM product_price GROUP BY product_price.product_id) last_price 
INNER JOIN product_price ON product_price.product_id = last_price.product_id AND product_price.start_datetime = last_price.last_change
INNER JOIN product ON product_price.product_id = product.product_id)
WHERE product_price.product_id = ?
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
}
