import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/DatabaseConnector.dart';
import 'package:mysql1/mysql1.dart';
import '../../Models/ProductItem.dart';
import '../../Models/ProductReview.dart';

class ProductRatingWidget extends StatefulWidget {
  ProductItem _product;

  ProductRatingWidget(this._product);

  @override
  State<StatefulWidget> createState() => _ProductRatingWidgetState(_product);
}

class _ProductRatingWidgetState extends State<ProductRatingWidget> {
  final MAX_STARS_COUNT = 5;
  ProductItem _product;

  Future<List<ProductReview>> _reviewsFuture;
  Future<_ReviewsStatistics> _reviewsStatisticsFuture;
  List<ProductReview> _reviews;
  _ReviewsStatistics _reviewStatistics;

  _ProductRatingWidgetState(this._product);

  @override
  Widget build(BuildContext context) {
    _reviewsFuture = _getProductReviews();
    _reviewsStatisticsFuture = _getReviewsStatistics();
    return FutureBuilder(
        future: Future.wait([_reviewsStatisticsFuture, _reviewsFuture]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data[0] == null || snapshot.data[1] == null) {
              return Center(child: Text("Не вдалося завантажити відгуки"));
            }
            _reviewStatistics = snapshot.data[0];
            _reviews = snapshot.data[1];
            if (_reviewStatistics.ratingsCount == 0) {
              return Text("Відгуки: ${_reviewStatistics.ratingsCount}",
                  style: Theme.of(context).textTheme.headline6);
            }
            return _ratingBlockWidget();
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Color _getRatingColor(double rating) {
    if (rating <= 2) {
      return Colors.red;
    } else if (rating <= 3) {
      return Colors.deepOrangeAccent;
    } else if (rating <= 4) {
      return Colors.lightGreen;
    }
    return Colors.green;
  }

  Widget _ratingBlockWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _ratingBlockHeaderRow(),
      SizedBox(height: 15),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _reviews.length,
              itemBuilder: (BuildContext context, int index) {
                return _userReviewWidget(_reviews[index]);
              }))
    ]);
  }

  Widget _ratingBlockHeaderRow() {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Text("Відгуки: ${_reviewStatistics.ratingsCount}",
          style: Theme.of(context).textTheme.headline6),
      Spacer(),
      Text(
          _reviewStatistics.averageRating.toString() +
              "/" +
              MAX_STARS_COUNT.toString(),
          style: Theme.of(context).textTheme.headline5.merge(TextStyle(
              color: _getRatingColor(_reviewStatistics.averageRating))))
    ]);
  }

  Widget _userReviewWidget(ProductReview review) {
    return Card(
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(review.userName,
                          style: Theme.of(context).textTheme.subtitle2)),
                  Text(
                    review.stars.toString(),
                    style: Theme.of(context).textTheme.headline6.merge(
                        TextStyle(
                            color: _getRatingColor(review.stars.toDouble()))),
                  ),
                  Icon(Icons.star, color: Colors.yellow)
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 30),
                  Expanded(child: Text(review.reviewText))
                ],
              )
            ],
          )),
    );
  }

  Future<_ReviewsStatistics> _getReviewsStatistics() async {
    MySqlConnection connection =
        await DatabaseConnector.createConnectionAsync();
    if (connection == null) {
      return null;
    }

    final RATING_STATISTICS_QUERY = """
    SELECT ROUND(AVG(stars), 1) as rating, COUNT(user_id) as reviews 
    FROM product_review WHERE product_id = ?;
    """;
    Results results = await DatabaseConnector.getQueryResultsAsync(
        RATING_STATISTICS_QUERY, [_product.id]);
    dynamic row = results.toList(growable: false)[0];
    return _ReviewsStatistics(row["rating"], row["reviews"]);
  }

  Future<List<ProductReview>> _getProductReviews() async {
    final RATING_QUERY = """
    SELECT user_id, username, stars, review 
    FROM product_review NATURAL JOIN user 
    WHERE product_id = ? AND user_id != ?
    """;
    Results results = await DatabaseConnector.getQueryResultsAsync(
      RATING_QUERY, [_product.id, 0]
    );
    return _queryResultsToProductReviews(results);
  }

  List<ProductReview> _queryResultsToProductReviews(Results results) {
    var resultsList = results.toList(growable: false);
    List<ProductReview> reviews = List();
    for (var row in resultsList) {
      Blob reviewBlob = row["review"];
      reviews.add(ProductReview(row["user_id"], row["username"], row["stars"],
          reviewBlob != null ? reviewBlob.toString() : ""));
    }
    return reviews;
  }
}

class _ReviewsStatistics {
  double averageRating;
  int ratingsCount;

  _ReviewsStatistics(this.averageRating, this.ratingsCount);
}
