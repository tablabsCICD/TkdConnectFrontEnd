import 'package:flutter/material.dart';
import 'package:tkd_connect/utils/colors.dart';

typedef RatingChangeCallback = void Function(int rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final int rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;

  const StarRating({super.key, this.starCount = 5, this.rating = 0,  this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: ThemeColor.theme_blue,
        size: 40,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color ?? ThemeColor.theme_blue,
        size: 40,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color ?? Colors.amber,
        size: 40,
      );
    }
    return InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged!(index + 1),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: List.generate(starCount, (index) => buildStar(context, index)));
  }
}