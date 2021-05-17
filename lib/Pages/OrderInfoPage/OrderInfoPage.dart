import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/DatabaseConnector.dart';
import 'package:fooday_mobile_app/Models/BasketItem.dart';
import 'package:fooday_mobile_app/Models/ProductItem.dart';
import 'package:fooday_mobile_app/Models/UserOrderData.dart';
import 'package:fooday_mobile_app/Utils.dart';
import 'package:mysql1/mysql1.dart';

class OrderInfoPage extends StatefulWidget {
  UserOrderData _order;

  OrderInfoPage(this._order);

  @override
  State<StatefulWidget> createState() => _OrderInfoPageState(_order);
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  int _orderId;
  Future<UserOrderData> _orderFuture;
  UserOrderData _order;
  Future<List<BasketItem>> _orderItemsFuture;
  List<BasketItem> _orderItems;

  _OrderInfoPageState(this._order) {
    _orderId = _order.orderId;
  }

  @override
  Widget build(BuildContext context) {
    _orderItemsFuture = _getOrderItemsAsync();
    _orderFuture = _getOrderDataAsync();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            _headerRoundedWidget(),
            FutureBuilder(
                future: Future.wait([_orderFuture, _orderItemsFuture]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    _order = snapshot.data[0];
                    _orderItems = snapshot.data[1];
                    return _bodyWidget();
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Виникла помилка"));
                  }
                  return Center(child: CircularProgressIndicator());
                })
          ],
        ));
  }

  Widget _headerRoundedWidget() {
    const HEADER_ELLIPSE_RADIUS = Radius.elliptical(80, 40);
    return Container(
        decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.only(
                //bottomLeft: HEADER_ELLIPSE_RADIUS,
                bottomRight: HEADER_ELLIPSE_RADIUS)),
        child: SafeArea(
            child: Padding(
                padding: EdgeInsets.only(bottom: 5, top: 0),
                child: Stack(
                  children: [
                    Container(
                        height: 40,
                        child: Center(
                            child: Text("Замовлення",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .merge(TextStyle(color: Colors.white70))))),
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ))));
  }

  Widget _bodyWidget() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
        child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _orderFuture = _getOrderDataAsync();
                _orderItemsFuture = _getOrderItemsAsync();
              });
            },
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      Text("№ замовлення: ",
                          style: Theme.of(context).textTheme.subtitle1),
                      Text(_order.orderId.toString(),
                          style: Theme.of(context).textTheme.subtitle2)
                    ]),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Text("Дата замовлення: ",
                            style: Theme.of(context).textTheme.subtitle1),
                        Expanded(
                            child: Text(
                                Utils.dateTimeString(_order.creationDate),
                                style: Theme.of(context).textTheme.subtitle2))
                      ],
                    ),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Text("Адреса замовлення: ",
                            style: Theme.of(context).textTheme.subtitle1),
                        Expanded(
                            child: Text(Utils.addressString(_order),
                                style: Theme.of(context).textTheme.subtitle2))
                      ],
                    ),
                    Divider(
                        height: 20, thickness: 1, indent: 10, endIndent: 10),
                    Container(
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _orderItems.length,
                            itemBuilder: _orderItemCard)),
                    Divider(
                        height: 20, thickness: 1, indent: 10, endIndent: 10),
                    Row(
                      children: [
                        Text("Всього:",
                            style: Theme.of(context).textTheme.subtitle1),
                        Spacer(),
                        Text("${_getPrice().toString()} грн.",
                            style: Theme.of(context).textTheme.headline5)
                      ],
                    ),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Text("Оплата: ",
                            style: Theme.of(context).textTheme.subtitle1),
                        _order.paymentValid
                            ? Text("Сплачено",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .merge(TextStyle(color: Colors.green)))
                            : Expanded(
                                child: Row(
                                children: [
                                  Expanded(
                                      child: Text("Не сплачено",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2)),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text("GPay"),
                                  )
                                ],
                              ))
                      ],
                    ),
                    SizedBox(height: 15),
                    _orderStateWidget()
                  ],
                ))));
  }

  double _getPrice() {
    return _order.promocode == null
        ? _order.price
        : double.parse((_order.price -
                _order.price * (_order.promocode.discountPercent / 100))
            .toStringAsFixed(2));
  }

  Widget _orderStateWidget() {
    if (_order.isDone) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.done, color: Colors.grey),
          Text("Завершено",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .merge(TextStyle(color: Colors.grey)))
        ],
      );
    }
    if (_order.courierId == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.watch_later_outlined, color: Colors.orange),
          Text("Очікує обробки",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .merge(TextStyle(color: Colors.orange)))
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: Text("Відстежити кур'єра на карті"),
          style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _orderItemCard(BuildContext context, int index) {
    BasketItem item = _orderItems[index];
    return Card(
        child: Padding(
            padding: EdgeInsets.all(7),
            child: Row(
              children: [
                Text(item.product.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle2),
                SizedBox(width: 5),
                Text(item.amount.toString() + " шт."),
                Spacer(),
                Text((item.product.price * item.amount).toString() + " грн.",
                    style: Theme.of(context).textTheme.subtitle1)
              ],
            )));
  }

  Future<UserOrderData> _getOrderDataAsync() async {
    const ORDERS_QUERY = """
      SELECT order_id, date, need_payment, street, house, apartment_number, 
        completed, SUM(price * amount) as price, courier_id, discount_percent 
      FROM delivery_order NATURAL JOIN order_products NATURAL LEFT JOIN order_courier
        NATURAL LEFT JOIN promocode 
      WHERE order_id = ?
      """;
    Results results =
        await DatabaseConnector.getQueryResultsAsync(ORDERS_QUERY, [_orderId]);
    return _userOrderFromResults(results);
  }

  UserOrderData _userOrderFromResults(Results results) {
    UserOrderData order;
    var rowsList = results.toList(growable: false);
    if (rowsList.length != 1) {
      return null;
    }
    var row = rowsList[0];
    return UserOrderData(null,
        orderId: row["order_id"],
        street: row["street"],
        house: row["house"],
        apartmentNumber: row["apartment_number"],
        paymentValid: row["need_payment"] == 0,
        isDone: row["completed"] != 0,
        price: row["price"],
        creationDate: row["date"],
        courierId: row["courier_id"],
        promocode: row["discount_percent"] == null
            ? null
            : Promocode(discountPercent: row["discount_percent"]));
  }

  Future<List<BasketItem>> _getOrderItemsAsync() async {
    const ITEMS_ORDER = """
    SELECT product.product_id, name, weight, amount, order_products.price as price 
    FROM order_products 
    INNER JOIN product ON product.product_id = order_products.product_id 
    WHERE order_id = ?; 
    """;
    Results results =
        await DatabaseConnector.getQueryResultsAsync(ITEMS_ORDER, [_orderId]);
    var resultsList = results.toList(growable: false);
    List<BasketItem> orderItems = [];
    for (var row in resultsList) {
      orderItems.add(BasketItem(
          ProductItem(row["product_id"], row["name"], row["weight"],
              row["price"], null),
          row["amount"]));
    }
    return orderItems;
  }
}
