import 'package:mysql1/mysql1.dart';

class ProductListItem {
  int id;
  String name;
  String weight;
  double price;
  Blob imageBlob;

  ProductListItem(
      int id, String name, String weight, double price, Blob imageBytes) {
    this.id = id;
    this.name = name;
    this.weight = weight;
    this.price = price;
    this.imageBlob = imageBytes;
  }
}