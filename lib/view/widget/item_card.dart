import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/Pages/item_details.dart';

import '../../constants.dart';
import '../../data/model/item_model.dart';
import '../Pages/add_item.dart';

class ItemCard extends StatefulWidget {
  final ItemModel itemModel;
  final bool isStock;
  final bool isHome;
  final bool showBottomBorder;
  final void Function()? onTap;
  const ItemCard({
    super.key,
    required this.itemModel,
    this.onTap,
    this.showBottomBorder = true,
    this.isStock = true,
    this.isHome = false,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return !widget.isStock
        ? GestureDetector(
            onTap: widget.onTap ??
                () {
                  Get.to(
                    () => ItemDetail(
                      itemModel: widget.itemModel,
                    ),
                  );
                },
            child: LayoutBuilder(builder: (context, ct) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: widget.showBottomBorder
                        ? BorderSide(
                            color: textColor,
                            width: .7,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: Row(
                  children: [
                    FutureBuilder(
                      future: displayImage(
                        widget.itemModel.image!,
                        widget.itemModel.id!,
                        FirebaseConstants.items,
                      ),
                      builder: (context, ds) {
                        return Container(
                          width: widget.isHome ? 75 : 60,
                          height: widget.isHome ? 80 : 60,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(widget.isHome ? 20 : 30),
                            image: ds.data != null
                                ? DecorationImage(
                                    image: FileImage(ds.data!),
                                    fit: BoxFit.cover,
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
                    SizedBox(
                      width: widget.isHome ? 20 : 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.isHome
                            ? Text(
                                widget.itemModel.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              )
                            : SizedBox(
                                width: ct.maxWidth - 120,
                                child: Text(
                                  widget.itemModel.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                        widget.isHome
                            ? Text(
                                "Last used for ${widget.itemModel.lastUsedFor}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: textColor,
                                ),
                              )
                            : Text(
                                "${widget.itemModel.pricePerUnit.round()} birr",
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              )
                      ],
                    )
                  ],
                ),
              );
            }),
          )
        : Stack(
            children: [
              // Padding(
              // padding: EdgeInsets.all(
              //   widget.onTap != null ? 10 : 0,
              // ),
              // child:
              InkWell(
                onTap: widget.onTap ??
                    () {
                      Get.to(
                        () => AddItem(
                          itemModel: widget.itemModel,
                        ),
                      );
                    },
                child: Container(
                  width: 170,
                  decoration: BoxDecoration(
                    color: mainBgColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 10,
                        offset: const Offset(-2, 2),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                          future: displayImage(
                            widget.itemModel.image!,
                            widget.itemModel.id!,
                            FirebaseConstants.items,
                          ),
                          builder: (context, ds) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ds.data != null
                                    ? ds.data!.path == ""
                                        ? Container(
                                            width: 80,
                                            height: 80,
                                            color: mainBgColor,
                                            child: const Center(
                                              child: Icon(
                                                Icons.wifi_off,
                                                size: 110,
                                              ),
                                            ),
                                          )
                                        : Image.file(
                                            ds.data!,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          )
                                    : SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                              ),
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemModel.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.itemModel.category,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // ),
              widget.onTap == null
                  ? const SizedBox()
                  : Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: primaryColor, shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            '${widget.itemModel.quantity}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // fontSize: 20,
                              color: backgroundColor,
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          );
  }
}
