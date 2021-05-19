import 'package:flutter/material.dart';
import 'package:flutter_simple_rating_bar/flutter_simple_rating_bar.dart';
import 'MyReview.dart';

class EditReviewDialog extends StatefulWidget {
  MyReview _myReview;
  Function() _onChanged;

  EditReviewDialog(this._myReview);

  @override
  State<StatefulWidget> createState() => _EditReviewDialogState(_myReview);
}

class _EditReviewDialogState extends State<EditReviewDialog> {
  final MAX_STARS_COUNT = 5;

  MyReview _myReviewOld;
  MyReview _myReviewChanged;
  bool _changesDone = false;

  _EditReviewDialogState(
    this._myReviewOld,
  ) {
    _myReviewChanged = !_myReviewOld.exists
        ? MyReview(false, 0, null)
        : MyReview(_myReviewOld.exists, _myReviewOld.stars, _myReviewOld.text);
  }

  @override
  Widget build(BuildContext context) {
    final double STAR_SIZE = 40;

    return AlertDialog(
      title: Text("Ваш відгук:"),
      contentPadding: EdgeInsets.all(10),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar(
              starCount: MAX_STARS_COUNT,
              size: STAR_SIZE,
              icon: Icon(Icons.star, size: STAR_SIZE, color: Colors.grey),
              isIndicator: false,
              rating: _myReviewChanged.stars.toDouble(),
              color: Colors.yellow,
              allowHalfRating: false,
              onRatingCallback:
                  (double value, ValueNotifier<bool> isIndicator) {
                setState(() {
                  _myReviewChanged.stars = value.toInt();
                  if (value != _myReviewOld.stars) {
                    _changesDone = true;
                  }
                });
              },
            ),
            // TODO: fix TextFormField overflow
            TextFormField(
                maxLines: null,
                maxLength: 1000,
                initialValue: _myReviewChanged.text,
                onChanged: (String value) {
                  setState(() {
                    _myReviewChanged.text = value.isNotEmpty ? value : null;
                    _changesDone = true;
                  });
                })
          ]),
      actions: [
        TextButton(
            child: Text("Відмінити"),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
          child: Text("Зберегти"),
          onPressed: _changesDone && _myReviewChanged.stars != 0
              ? () {
                  _myReviewOld.exists = _myReviewOld.exists;
                  _myReviewOld.stars = _myReviewChanged.stars;
                  _myReviewOld.text = _myReviewChanged.text;
                  Navigator.pop(context, true);
                }
              : null,
        )
      ],
    );
  }
}
