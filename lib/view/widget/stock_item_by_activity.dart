import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/model/item_history_model.dart';

class StockItemByActivity extends StatelessWidget {
  final ItemHistoryModel itemHistoryModel;
  final bool showDate;
  const StockItemByActivity(
      {super.key, required this.itemHistoryModel, required this.showDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDate)
          Padding(
            padding: const EdgeInsets.only(
              left: 32,
              top: 10,
              bottom: 15,
            ),
            child: Text(
              DateFormat("EEE / dd - MMMM").format(
                DateTime.parse(itemHistoryModel.date),
              ),
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(
            right: 18,
            left: 18,
            bottom: 15,
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: mainBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                // pardding: const EdgeInsets.all(9),
                child: Row(
                  children: [
                    FutureBuilder(
                      future: displayImage(
                        itemHistoryModel.itemImg,
                        itemHistoryModel.itemId,
                        FirebaseConstants.items,
                      ),
                      builder: (context, ds) {
                        return Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: ds.data != null
                                ? DecorationImage(
                                    image: FileImage(ds.data!),
                                    fit: BoxFit.cover,
                                  )
                                : kIsWeb
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          itemHistoryModel.itemImg,
                                        ),
                                      )
                                    : null,
                          ),
                          child: ds.data == null
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                              : null,
                        );
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemHistoryModel.itemName,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          itemHistoryModel.itemCategory,
                          style: TextStyle(fontSize: 14, color: textColor),
                        ),
                        Row(
                          children: [
                            Text(
                              "${itemHistoryModel.quantity}",
                              style: TextStyle(
                                fontSize: 14,
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              " ${itemHistoryModel.unit} ${itemHistoryModel.type}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  child: SvgPicture.asset(
                    itemHistoryModel.type == ItemHistoryType.buyed
                        ? 'assets/buy.svg'
                        : 'assets/used.svg',
                    color: backgroundColor,
                    height: 25,
                    width: 25,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
