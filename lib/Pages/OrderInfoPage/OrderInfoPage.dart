import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/Models/UserOrderData.dart';
import 'package:fooday_mobile_app/Utils.dart';

class OrderInfoPage extends StatefulWidget {
  UserOrderData _order;

  OrderInfoPage(this._order);

  @override
  State<StatefulWidget> createState() => _OrderInfoPageState(_order);
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  UserOrderData _order;

  _OrderInfoPageState(this._order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [_headerRoundedWidget(), _bodyWidget()],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Text("№ замовлення: ",
                  style: Theme.of(context).textTheme.subtitle1),
              Text(_order.orderId.toString(),
                  style: Theme.of(context).textTheme.headline6)
            ]),
            Row(
              children: [
                Text("Дата замовлення: ",
                    style: Theme.of(context).textTheme.subtitle1),
                Text(Utils.dateTimeString(_order.creationDate),
                    style: Theme.of(context).textTheme.headline6)
              ],
            ),
            Row(
              children: [
                Text("Адреса замовлення: ",
                    style: Theme.of(context).textTheme.subtitle1),
                Expanded(
                    child: Text(Utils.addressString(_order),
                        style: Theme.of(context).textTheme.headline6))
              ],
            )
          ],
        ));
  }
}
