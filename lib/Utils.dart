import 'package:fooday_mobile_app/Models/UserOrderData.dart';

class Utils {
  static String dateTimeString(DateTime dt) =>
      "${dt.day}.${dt.month}.${dt.year} ${dt.hour}:${dt.minute}";

  static String addressString(UserOrderData order) =>
      "${order.street} ${order.house}" +
      ((order.apartmentNumber == null || order.apartmentNumber.isEmpty)
          ? ""
          : ", кв. ${order.apartmentNumber.toString()}");
}
