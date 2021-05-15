import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../OrderPage/OrderPage.dart';
import '../../DatabaseConnector.dart';
import '../../Models/ProductItem.dart';
import '../../Models/BasketItem.dart';
import 'BasketCard.dart';

class BasketPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  List<BasketItem> _basketItems;
  Future<List<BasketItem>> _basketItemsFuture;

  _BasketPageState() {
    _basketItemsFuture = _getBasketItemsAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      _headerRoundedWidget(),
      SizedBox(height: 10),
      FutureBuilder(
        future: _basketItemsFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return Center(child: Text("Відбулась помилка"));
            }
            _basketItems = snapshot.data;
            return _basketItems.isEmpty
                ? _basketEmptyWidget()
                : _basketNotEmptyWidget();
          }
          return Expanded(child: Center(child: CircularProgressIndicator()));
        },
      )
    ]));
  }

  Widget _headerRoundedWidget() {
    const HEADER_ELLIPSE_RADIUS = Radius.elliptical(80, 40);
    return Container(
        decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.only(
                bottomLeft: HEADER_ELLIPSE_RADIUS,
                bottomRight: HEADER_ELLIPSE_RADIUS)),
        child: SafeArea(
            child: Padding(
                padding: EdgeInsets.only(bottom: 5, top: 0),
                child: Container(
                    height: 40,
                    child: Center(
                        child: Text("Кошик",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .merge(TextStyle(color: Colors.white70))))))));
  }

  Widget _basketEmptyWidget() {
    return Expanded(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("Icons/empty_basket_icon.png",
              height: 100, width: 100, fit: BoxFit.fitWidth),
          SizedBox(height: 20),
          Text("У Вашому кошику зараз порожньо")
        ],
      )),
    );
  }

  Widget _basketNotEmptyWidget() {
    return Expanded(
        child: Column(
      children: [
        _basketInfoWidget(),
        Divider(thickness: 1, color: Colors.grey),
        Expanded(child: _productsListWidget()),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                child: Padding(
                    child: Text("Замовити"),
                    padding: EdgeInsets.symmetric(vertical: 15)),
                onPressed: () async {
                  bool basketChanged = await Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return OrderPage(_basketItems);
                  }));
                  if (basketChanged != null && basketChanged) {
                    _basketItemsFuture = _getBasketItemsAsync();
                    setState(() {});
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                )))
      ],
    ));
  }

  Widget _basketInfoWidget() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("${_basketItems.length} ",
              style: Theme.of(context).textTheme.headline5),
          Text("товарів на суму ",
              style: Theme.of(context).textTheme.subtitle1),
          Text("${_findTotalPrice()} грн.",
              style: Theme.of(context).textTheme.headline5),
        ]);
  }

  Widget _productsListWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _basketItems.length,
      itemBuilder: (BuildContext context, int index) =>
          BasketCard(_basketItems, index, () {
        setState(() {});
      }),
    );
  }

  double _findTotalPrice() {
    double sum = 0;
    for (var item in _basketItems) {
      sum += item.product.price * item.amount;
    }
    return sum;
  }

  Future<List<BasketItem>> _getBasketItemsAsync() async {
    const BASKET_QUERY = """
SELECT *
FROM basket_products 
INNER JOIN ((SELECT product_price.product_id, MAX(start_datetime) last_change FROM product_price GROUP BY product_price.product_id) last_price 
  INNER JOIN product_price ON product_price.product_id = last_price.product_id AND product_price.start_datetime = last_price.last_change
  INNER JOIN product ON product_price.product_id = product.product_id) ON basket_products.product_id = product.product_id
WHERE user_id = ?;
    """;
    // TODO: specify real user id
    Results results =
        await DatabaseConnector.getQueryResultsAsync(BASKET_QUERY, [1]);
    if (results == null) {
      return null;
    }
    return _basketItemsFromResults(results);
  }

  List<BasketItem> _basketItemsFromResults(Results results) {
    List<BasketItem> basketItems = [];
    var rowsList = results.toList(growable: false);
    for (var row in rowsList) {
      basketItems.add(BasketItem(
          ProductItem(row["product_id"], row["name"], row["weight"],
              row["price"], row["image"]),
          row["amount"]));
    }
    return basketItems;
  }
}
