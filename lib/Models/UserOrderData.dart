import 'BasketItem.dart';

class UserOrderData {
  int orderId;
  List<BasketItem> basketItems;
  String street;
  String house;
  String apartmentNumber;
  PaymentType paymentType = PaymentType.Cash;
  Promocode promocode;
  bool paymentValid = false;

  UserOrderData(this.basketItems,
      {this.street = "", this.house = "", this.apartmentNumber});
}

enum PaymentType { Cash, Visa }

class Promocode {
  int id;
  int discountPercent;

  Promocode({this.id, this.discountPercent});
}
