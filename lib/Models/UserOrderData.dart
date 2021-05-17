import 'BasketItem.dart';

class UserOrderData {
  int orderId;
  List<BasketItem> basketItems;
  String street;
  String house;
  String apartmentNumber;
  PaymentType paymentType = PaymentType.Cash;
  Promocode promocode;
  bool paymentValid;
  bool isDone;
  double price;
  DateTime creationDate;
  int courierId;

  UserOrderData(this.basketItems,
      {this.orderId,
      this.street = "",
      this.house = "",
      this.apartmentNumber,
      this.isDone = false,
      this.paymentValid = false,
      this.price,
      this.creationDate,
      this.courierId,
      this.promocode});
}

enum PaymentType { Cash, Visa }

class Promocode {
  int id;
  int discountPercent;

  Promocode({this.id, this.discountPercent});
}
