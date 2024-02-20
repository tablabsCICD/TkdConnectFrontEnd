import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/utils/colors.dart';

typedef void RatingChangeCallback(int rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final int rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;

  StarRating({this.starCount = 5, this.rating = 0,  this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: ThemeColor.theme_blue,
        size: 40,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? ThemeColor.theme_blue,
        size: 40,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Colors.amber,
        size: 40,
      );
    }
    return new InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged!(index + 1),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}