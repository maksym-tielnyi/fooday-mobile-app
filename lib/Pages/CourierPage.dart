import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/DatabaseConnector.dart';
import 'package:fooday_mobile_app/Models/UserOrderData.dart';
import 'package:fooday_mobile_app/Pages/OrderInfoPage/OrderInfoPage.dart';
import 'package:fooday_mobile_app/Utils.dart';
import 'package:mysql1/mysql1.dart';

class CourierOrdersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CourierOrdersPageState();
}

class _CourierOrdersPageState extends State<CourierOrdersPage> {
  Future<List<UserOrderData>> _myOrdersFuture;
  List<UserOrderData> _myOrdersAll;
  List<UserOrderData> _myOrdersInProcess;
  List<UserOrderData> _myOrdersDone;

  @override
  Widget build(BuildContext context) {
    _myOrdersFuture = _getUserOrders();
    return Scaffold(
      body: Container(
          child: Column(children: [
            _headerRoundedWidget(),
            SizedBox(height: 10),
            DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  children: [
                    FutureBuilder(
                        future: _myOrdersFuture,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            _myOrdersAll = snapshot.data;
                            _myOrdersInProcess = [];
                            _myOrdersDone = [];
                            for (var order in _myOrdersAll) {
                              if (order.isDone) {
                                _myOrdersDone.add(order);
                              } else {
                                _myOrdersInProcess.add(order);
                              }
                            }
                            return Column(children: [
                              Container(
                                  child: TabBar(
                                      labelColor: Colors.black,
                                      tabs: const [
                                        Tab(text: "У процесі"),
                                        Tab(text: "Завершені")
                                      ])),
                              Container(
                                height: MediaQuery.of(context).size.height - 200,
                                child: TabBarView(children: [
                                  Container(
                                      child: _ordersListWidget(_myOrdersInProcess)),
                                  Container(child: _ordersListWidget(_myOrdersDone))
                                ]),
                              )
                            ]);
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Виникла помилка"));
                          }
                          return Center(child: CircularProgressIndicator());
                        })
                  ],
                ))
          ])),
    );
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
                        child: Text("Ваші замовлення",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .merge(TextStyle(color: Colors.white70))))))));
  }

  Widget _ordersListWidget(List<UserOrderData> orders) {
    return Expanded(
        child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) {
              return _orderCardWidget(orders[index]);
            }));
  }

  Widget _orderCardWidget(UserOrderData order) {
    return GestureDetector(
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => OrderInfoPage(order)));
          setState(() {});
        },
        child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Row(
                children: [
                  _orderIcon(order),
                  SizedBox(width: 7),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(Utils.dateTimeString(order.creationDate),
                              style: Theme.of(context).textTheme.subtitle2),
                          Row(
                            children: [
                              Expanded(
                                  child: Text("${_getPrice(order)} грн.",
                                      style: Theme.of(context).textTheme.subtitle1)),
                              SizedBox(width: 10),
                              order.paymentValid
                                  ? Text("Сплачено",
                                  style: TextStyle(color: Colors.green))
                                  : Text("Не сплачено",
                                  style: TextStyle(color: Colors.grey))
                            ],
                          ),
                          Text(Utils.addressString(order))
                        ],
                      ))
                ],
              ),
            )));
  }

  Icon _orderIcon(UserOrderData order) {
    if (order.isDone) {
      return Icon(Icons.done, color: Colors.green);
    }
    if (order.courierId == null) {
      return Icon(Icons.access_time, color: Colors.yellow);
    } else {
      return Icon(Icons.delivery_dining, color: Colors.orange);
    }
  }

  Future<List<UserOrderData>> _getUserOrders() async {
    const ORDERS_QUERY = """
      SELECT order_id, date, need_payment, street, house, apartment_number, 
        completed, SUM(price * amount) as price, courier_id, discount_percent
      FROM delivery_order NATURAL JOIN order_products NATURAL LEFT JOIN order_courier 
        NATURAL LEFT JOIN promocode
      WHERE courier_id = ? 
      GROUP BY order_id 
      ORDER BY date DESC;
      """;
    // TODO: specify real user id
    Results results =
    await DatabaseConnector.getQueryResultsAsync(ORDERS_QUERY, [2]);

    return _userOrderFromResults(results);
  }

  List<UserOrderData> _userOrderFromResults(Results results) {
    List<UserOrderData> orders = [];
    var rowsList = results.toList(growable: false);
    for (var row in rowsList) {
      orders.add(UserOrderData(null,
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
              : Promocode(discountPercent: row["discount_percent"])));
    }
    return orders;
  }

  double _getPrice(UserOrderData order) {
    return order.promocode == null
        ? order.price
        : double.parse((order.price -
        order.price * (order.promocode.discountPercent / 100))
        .toStringAsFixed(2));
  }
}
