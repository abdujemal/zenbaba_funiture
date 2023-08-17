import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/model/review_model.dart';
import 'package:zenbaba_funiture/view/widget/custom_btn.dart';
import 'package:zenbaba_funiture/view/widget/sl_input.dart';

class AddReviewSheet extends StatefulWidget {
  final String customerId;
  final String customerName;
  final String orderId;
  const AddReviewSheet({
    super.key,
    required this.customerId,
    required this.orderId,
    required this.customerName,
  });

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  TextEditingController commentTc = TextEditingController();

  double ratings = 2.5;

  @override
  void dispose() {
    commentTc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: section(
        children: [
          const Center(
            child: Text(
              "Add Review",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SLInput(
            title: "Comment",
            hint: "what do you think",
            keyboardType: TextInputType.text,
            controller: commentTc,
            inputColor: whiteColor,
            otherColor: textColor,
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
              child: RatingBar.builder(
            initialRating: 2.5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              ratings = rating;
            },
          )),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: CustomBtn(
              btnState: Btn.filled,
              color: primaryColor,
              text: "Save",
              tColor: backgroundColor,
              onTap: () {
                FirebaseFirestore.instance
                    .collection(FirebaseConstants.reviews)
                    .add(
                      ReviewModel(
                        id: "",
                        orderId: widget.orderId,
                        customerId: widget.customerId,
                        customerName: widget.customerName,
                        ratings: ratings,
                        messege: commentTc.text,
                        date: DateTime.now().toString(),
                      ).toMap(),
                    )
                    .then((value) {
                  Get.back();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
