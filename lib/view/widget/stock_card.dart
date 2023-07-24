import 'dart:io';

import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../data/model/item_history_model.dart';

class StockCard extends StatelessWidget {
  final ItemHistoryModel itemHistoryModel;
  final File? image;
  final String name;
  const StockCard({
    super.key,
    required this.itemHistoryModel,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: image != null
                ? image!.path == ""
                    ? Container(
                        color: backgroundColor,
                        width: 60,
                        height: 60,
                        child: const Icon(
                          Icons.wifi_off_rounded,
                          size: 60,
                        ),
                      )
                    : Image.file(
                        image!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                : Container(
                    color: backgroundColor,
                    width: 60,
                    height: 60,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  ),
          ),
          const SizedBox(
            width: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 130,
                    child: Text(
                      name,
                      style: const TextStyle(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    itemHistoryModel.type,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "${itemHistoryModel.quantity} pcs",
                style: TextStyle(fontSize: 16, color: textColor),
              )
            ],
          )
        ],
      ),
    );
  }
}
