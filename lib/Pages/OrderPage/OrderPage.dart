import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../../DatabaseConnector.dart';
import '../../Models/UserOrderData.dart';
import '../../Models/BasketItem.dart';

class OrderPage extends StatefulWidget {
  List<BasketItem> _basket;

  OrderPage(this._basket);

  @override
  State<StatefulWidget> createState() => _OrderPageState(_basket);
}

class _OrderPageState extends State<OrderPage> {
  static const _FORMS_COUNT = 3;
  UserOrderData _orderData;
  List<GlobalKey<FormState>> _formKeys =
      List.generate(_FORMS_COUNT, (int index) => GlobalKey<FormState>());
  int _currentStep = 0;
  String _promocodeInput = "";

  _OrderPageState(List<BasketItem> _basket) {
    _orderData = UserOrderData(_basket);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(children: [
              _headerRoundedWidget(),
              Flexible(
                  child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: _bodyWidget()))
            ]),
            SafeArea(
                child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }))
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
                child: Container(
                    height: 40,
                    child: Center(
                        child: Text("Замовлення",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .merge(TextStyle(color: Colors.white70))))))));
  }

  Widget _bodyWidget() {
    return Container(
        child: Column(
      children: [
        Stepper(
          physics: ScrollPhysics(),
          currentStep: _currentStep,
          controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
              Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Row(children: [
                    ElevatedButton(
                        onPressed: onStepContinue, child: const Text("Далі"))
                  ])),
          onStepTapped: (int index) {
            if (index < _currentStep && !_orderData.paymentValid) {
              setState(() {
                _currentStep = index;
              });
            }
          },
          onStepContinue: _onStepContinue,
          steps: [
            Step(
                title: Text("Контактні дані"),
                content: Container(child: _userContactDataWidget(0)),
                state: _stepState(0),
                isActive: _currentStep == 0),
            Step(
                title: Text("Підтвердження замовлення"),
                content: Container(child: _chequeWidget(1)),
                state: _stepState(1),
                isActive: _currentStep == 1),
            Step(
                title: Text("Оплата"),
                content: Container(child: _paymentWidget(2)),
                state: _stepState(2),
                isActive: _currentStep == 2)
          ],
        )
      ],
    ));
  }

  void _onStepContinue() async {
    if (_formKeys[_currentStep].currentState.validate()) {
      if (_currentStep == 1) {
        _orderData.orderId = await _createOrderAsync();
        await _moveBasketToOrderAsync();
      }
      if (_currentStep < _FORMS_COUNT - 1) {
        setState(() {
          _currentStep++;
        });
      } else {
        final SnackBar sb = SnackBar(
            content: Row(children: [
              Icon(Icons.done_outline_rounded, color: Colors.green),
              SizedBox(width: 10),
              Expanded(
                  child: Text(
                      "Ваше замовлення прийняте. Залишилось тільки трохи почекати!"))
            ]),
            duration: Duration(seconds: 5));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        Navigator.pop(context, true);
      }
    }
  }

  StepState _stepState(int index) {
    if (index < _currentStep) {
      return StepState.complete;
    }
    if (index == _currentStep) {
      return StepState.editing;
    }
    return StepState.disabled;
  }

  Widget _userContactDataWidget(int index) {
    return Form(
        key: _formKeys[index],
        child: Column(
          children: [
            TextFormField(
              initialValue: _orderData.street,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(labelText: "Вулиця"),
              validator: (String value) {
                if (value.isEmpty) {
                  return "Обов'язково до заповнення";
                }
                _orderData.street = value;
                return null;
              },
              onChanged: (String value) {
                _orderData.street = value;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: TextFormField(
                  initialValue: _orderData.house,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(labelText: "Будинок"),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Обов'язково до заповнення";
                    }
                    _orderData.house = value;
                    return null;
                  },
                  onChanged: (String value) {
                    _orderData.house = value;
                  },
                )),
                Expanded(
                    child: TextFormField(
                  initialValue: _orderData.apartmentNumber,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(labelText: "Квартира"),
                  validator: (String value) {
                    _orderData.apartmentNumber = value;
                    return null;
                  },
                  onChanged: (String value) {
                    _orderData.apartmentNumber = value;
                  },
                ))
              ],
            )
          ],
        ));
  }

  Widget _chequeWidget(int index) {
    return Form(
        key: _formKeys[index],
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Адреса: ${_addressString()}",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Divider(height: 20, thickness: 1, indent: 10, endIndent: 10),
              Container(
                  //constraints: BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _orderData.basketItems.length,
                      itemBuilder: _basketItemCard)),
              Divider(height: 20, thickness: 1, indent: 10, endIndent: 10),
              _promocodeWidget(),
              SizedBox(height: 7),
              Row(
                children: [
                  Text("До сплати: ",
                      style: Theme.of(context).textTheme.subtitle1),
                  Spacer(),
                  Expanded(
                      child: Text(_findTotalPrice().toString() + " грн.",
                          style: Theme.of(context).textTheme.headline6))
                ],
              )
            ]));
  }

  Widget _basketItemCard(BuildContext context, int index) {
    BasketItem item = _orderData.basketItems[index];
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

  String _addressString() {
    return "${_orderData.street} ${_orderData.house}" +
        ((_orderData.apartmentNumber == null ||
                _orderData.apartmentNumber.isEmpty)
            ? ""
            : ", кв. ${_orderData.apartmentNumber.toString()}");
  }

  Widget _promocodeWidget() {
    if (_orderData.promocode == null) {
      return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
            child: TextFormField(
          decoration: InputDecoration(labelText: "Промокод"),
          onChanged: (String value) => _promocodeInput = value,
        )),
        RaisedButton(
            child: Text("Ок"),
            onPressed: () async {
              _orderData.promocode = await _checkPromocodeAsync();
              if (_orderData.promocode != null) setState(() {});
            })
      ]);
    }
    return Row(
      children: [
        Icon(Icons.done_outline, color: Colors.green),
        SizedBox(width: 10),
        Expanded(
            child: Text(
                "Промокод на знижку ${_orderData.promocode.discountPercent}% активовано"))
      ],
    );
  }

  Widget _paymentWidget(int index) {
    var paymentTypes = PaymentType.values;
    return Form(
        key: _formKeys[index],
        child: FormField<void>(
          builder: (FormFieldState<void> state) => Column(children: [
            Row(children: [
              Radio<PaymentType>(
                  value: PaymentType.Visa,
                  groupValue: _orderData.paymentType,
                  onChanged:
                      _orderData.paymentValid ? null : _onPaymentTypeChanged),
              Image.asset("Icons/visa_icon.png", width: 70),
            ]),
            Row(
              children: [
                Radio<PaymentType>(
                    value: PaymentType.Cash,
                    groupValue: _orderData.paymentType,
                    onChanged:
                        _orderData.paymentValid ? null : _onPaymentTypeChanged),
                Image.asset("Icons/cash_icon.png", width: 70)
              ],
            ),
          ]),
          validator: (paymentType) =>
              _orderData.paymentType == null ? "Виберіть тип оплати" : null,
        ));
  }

  void _onPaymentTypeChanged(PaymentType value) {
    if (_orderData.paymentType == value || _orderData.paymentValid) {
      return;
    }
    switch (value) {
      case PaymentType.Cash:
        setState(() => _orderData.paymentType = value);
        break;
      case PaymentType.Visa:
        setState(() {
          _orderData.paymentType = value;
          _orderData.paymentValid = true;
        });
        break;
    }
  }

  double _findTotalPrice() {
    double sum = 0;
    for (var item in _orderData.basketItems) {
      sum += item.product.price * item.amount;
    }
    if (_orderData.promocode != null) {
      sum -= (sum * (_orderData.promocode.discountPercent / 100));
    }
    return sum;
  }

  Future<Promocode> _checkPromocodeAsync() async {
    const PROMOCODE_QUERY = """
    SELECT * FROM promocode WHERE value LIKE ? AND active = TRUE 
    AND promocode_id NOT IN 
    (SELECT DISTINCT promocode_id FROM delivery_order 
      WHERE user_id = ? AND promocode_id IS NOT NULL);
    """;
    // TODO: specify real user id
    Results results = await DatabaseConnector.getQueryResultsAsync(
        PROMOCODE_QUERY, [_promocodeInput, 1]);
    if (results.length == 1) {
      var row = results.toList(growable: false)[0];
      return Promocode(
          id: row["promocode_id"], discountPercent: row["discount_percent"]);
    }
    return null;
  }

  Future<int> _createOrderAsync() async {
    MySqlConnection connection =
        await DatabaseConnector.createConnectionAsync();
    const INSERT_QUERY = """
    INSERT INTO delivery_order (user_id, date, need_payment, street, house, apartment_number, promocode_id) 
    VALUES (?, ?, ?, ?, ?, ?, ?);
    """;
    // TODO: specify real user id
    Results results = await DatabaseConnector.getQueryResultsAsync(
            INSERT_QUERY,
            [
              1,
              DateTime.now().toString(),
              true,
              _orderData.street,
              _orderData.house,
              _orderData.apartmentNumber == null
                  ? null
                  : _orderData.apartmentNumber,
              _orderData.promocode != null ? _orderData.promocode.id : null
            ],
            connection: connection)
        .then((res) async {
      const ID_QUERY = "SELECT LAST_INSERT_ID();";
      return await DatabaseConnector.getQueryResultsAsync(ID_QUERY, [],
          connection: connection);
    });
    connection.close();
    var resultsList = results.toList(growable: false)[0];
    int id = resultsList[0];
    return id;
  }

  Future<bool> _moveBasketToOrderAsync() async {
    MySqlConnection connection =
        await DatabaseConnector.createConnectionAsync();
    const INSERT_QUERY = """
    INSERT INTO order_products (order_id, product_id, amount, price) 
    VALUES (?, ?, ?, ?);
    """;
    var insertResults = await connection.queryMulti(
        INSERT_QUERY,
        List.generate(_orderData.basketItems.length, (int index) {
          var item = _orderData.basketItems[index];
          return [
            _orderData.orderId,
            item.product.id,
            item.amount,
            item.product.price
          ];
        }));
    connection.close();
    const DELETE_QUERY = """
    DELETE FROM basket_products WHERE user_id = ?
    """;
    // TODO: specify real user id
    var deleteResults =
        await DatabaseConnector.getQueryResultsAsync(DELETE_QUERY, [1]);
    return true;
  }
}
