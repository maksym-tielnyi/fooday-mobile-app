import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../Models/ProductItem.dart';

class ImagesCarouselView extends StatefulWidget {
  ProductItem _product;

  ImagesCarouselView(this._product);

  @override
  State<StatefulWidget> createState() => _ImagesCarouselViewState(_product);
}

class _ImagesCarouselViewState extends State<StatefulWidget> {
  ProductItem _product;
  Future<Blob> _imageBlobsFuture;

  _ImagesCarouselViewState(this._product) {
    _imageBlobsFuture = _getImagesBlobsAsync();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        options: CarouselOptions(
            height: 200,
            pageSnapping: true,
            viewportFraction: 1,
            // enlargeCenterPage: true,
            // enlargeStrategy: CenterPageEnlargeStrategy.height,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4)),
        items: [
          Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/800px-Image_created_with_a_mobile_phone.png"),
          Image.network(
              "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg")
        ]);
  }

  Future<Blob> _getImagesBlobsAsync() async {}
}
