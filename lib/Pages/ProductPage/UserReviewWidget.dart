import 'package:flutter/material.dart';
import 'package:fooday_mobile_app/DatabaseConnector.dart';
import 'package:fooday_mobile_app/Pages/ProductPage/EditReviewDialog.dart';
import 'package:fooday_mobile_app/UserDataStorage.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter_simple_rating_bar/flutter_simple_rating_bar.dart';
import '../../Models/ProductItem.dart';
import 'MyReview.dart';

class UserReviewWidget extends StatefulWidget {
  ProductItem _product;
  Function() _onUpdate;

  UserReviewWidget(this._product, this._onUpdate);

  @override
  State<StatefulWidget> createState() =>
      _UserReviewWidgetState(_product, _onUpdate);
}

class _UserReviewWidgetState extends State<UserReviewWidget> {
  final MAX_STARS_COUNT = 5;
  ProductItem _product;
  Function() _onUpdate;
  Future<bool> _reviewAllowedFuture;
  Future<MyReview> _myReviewFuture;
  bool _reviewAllowed;
  MyReview _myReview;

  _UserReviewWidgetState(this._product, this._onUpdate);

  @override
  Widget build(BuildContext context) {
    _reviewAllowedFuture = _getReviewingPermissionAsync();
    return FutureBuilder(
        future: _reviewAllowedFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return Center(child: Text("Не вдалось завантажити ваш відгук"));
            }
            _reviewAllowed = snapshot.data;
            if (_reviewAllowed) {
              return _reviewAllowedWidget();
            }
            return Container();
          }
          return Container();
        });
  }

  Widget _reviewAllowedWidget() {
    _myReviewFuture = _getMyReviewAsync();
    return Column(
      children: [
        FutureBuilder(
          future: _myReviewFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return Center(child: Text("Не вдалось завантажити ваш відгук"));
              }
              _myReview = snapshot.data;
              return Card(
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: _myReview.exists
                          ? _existingReviewWidget()
                          : _nonexistentReviewWidget()));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        SizedBox(height: 15)
      ],
    );
  }

  Widget _existingReviewWidget() {
    final double STAR_SIZE = 40;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Ваш відгук",
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center),
        SizedBox(height: 10),
        Center(
            child: RatingBar(
          starCount: MAX_STARS_COUNT,
          size: STAR_SIZE,
          icon: Icon(Icons.star, size: STAR_SIZE, color: Colors.grey),
          isIndicator: true,
          rating: _myReview.stars.toDouble(),
          color: Colors.yellow,
          allowHalfRating: false,
        )),
        SizedBox(height: 10),
        Text(_myReview.text != null ? _myReview.text : "",
            style: Theme.of(context).textTheme.bodyText2),
        SizedBox(height: 5),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          TextButton(child: Text("Змінити"), onPressed: _onDialogPressed),
          TextButton(child: Text("Видалити"), onPressed: () {
            setState(() {
              _deleteMyReview();
              _onUpdate();
            });
          })
        ])
      ],
    );
  }

  void _onDialogPressed() async {
    bool isChanged = await showDialog(
        context: context,
        builder: (BuildContext context) => EditReviewDialog(_myReview));
    if (isChanged) {
      await _pushMyReview();
      setState(() {
        _onUpdate();
      });
    }
  }

  Widget _nonexistentReviewWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Ваш відгук",
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center),
        SizedBox(height: 10),
        Center(
            child: ElevatedButton(
                child: Text("Залишити відгук"), onPressed: _onDialogPressed))
      ],
    );
  }

  void _pushMyReview() async {
    final UPDATE_MY_REVIEW_QUERY = """
    UPDATE product_review SET stars = ?, review = ? 
    WHERE product_id = ? AND user_id = ?;
    """;
    final INSERT_MY_REVIEW_QUERY = """
    INSERT INTO product_review (stars, review, product_id, user_id) 
    VALUES (?, ?, ?, ?);
    """;

    int userId = await UserDataStorage().getIdAsync();
    await DatabaseConnector.getQueryResultsAsync(
        _myReview.exists ? UPDATE_MY_REVIEW_QUERY : INSERT_MY_REVIEW_QUERY,
        [_myReview.stars, _myReview.text, _product.id, userId]);
    setState(() {
      _onUpdate();
    });
  }

  void _deleteMyReview() async {
    final DELTE_MY_REVIEW_QUERY = """
    DELETE FROM product_review WHERE product_id = ? AND user_id = ?;
    """;
    int userId = await UserDataStorage().getIdAsync();
    await DatabaseConnector.getQueryResultsAsync(
        DELTE_MY_REVIEW_QUERY, [_product.id, userId]);
  }

  Future<bool> _getReviewingPermissionAsync() async {
    // TODO: finish method
    return true;
  }

  Future<MyReview> _getMyReviewAsync() async {
    final MY_REVIEW_QUERY = """
    SELECT stars, review FROM product_review 
    WHERE user_id = ? AND product_id = ?;
    """;
    Results results = await DatabaseConnector.getQueryResultsAsync(
        MY_REVIEW_QUERY, [1, _product.id]);
    return _queryResultsToReviewAsync(results);
  }

  Future<MyReview> _queryResultsToReviewAsync(Results results) async {
    var rowList = results.toList(growable: false);
    if (rowList.length != 1) {
      return MyReview(false, null, null);
    }
    var row = rowList[0];
    Blob reviewBlob = row["review"];
    return MyReview(
        true, row["stars"], reviewBlob != null ? reviewBlob.toString() : null);
  }
}
