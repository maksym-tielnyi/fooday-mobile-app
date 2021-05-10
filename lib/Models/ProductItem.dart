import 'package:mysql1/mysql1.dart';

class ProductItem {
  int id;
  String name;
  String weight;
  double price;
  Blob imageBlob;
  String description;
  int calories;
  int proteins;
  int fats;
  int carbohydrates;

  ProductItem(this.id, this.name, this.weight, this.price, this.imageBlob,
      {this.description,
      this.calories,
      this.proteins,
      this.fats,
      this.carbohydrates});
}
