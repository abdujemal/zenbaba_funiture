import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/model/review_model.dart';

class ReviewItem extends StatelessWidget {
  final ReviewModel reviewModel;
  final bool showName;
  final double ph, pv;
  const ReviewItem({
    super.key,
    required this.reviewModel,
    required this.showName,
    this.ph = 10,
    this.pv = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ph, vertical: pv),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          if (showName)
            Text(
              reviewModel.customerName,
              style: const TextStyle(fontSize: 17),
            ),
          if (showName)
            const SizedBox(
              height: 5,
            ),
          RatingBarIndicator(
            rating: reviewModel.ratings,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            reviewModel.messege,
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(
            height: 3,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              DateFormat("EEE / dd - MMMM")
                  .format(DateTime.parse(reviewModel.date)),
              style: TextStyle(
                color: whiteColor.withAlpha(190),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
