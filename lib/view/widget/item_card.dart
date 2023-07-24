import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../data/model/item_model.dart';
import '../Pages/add_item.dart';

class ItemCard extends StatefulWidget {
  final ItemModel itemModel;
  final void Function()? onTap;
  const ItemCard({super.key, required this.itemModel, this.onTap});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  File? file;
  @override
  void initState() {
    super.initState();
    setImageFile();
  }

  setImageFile() async {
    file = await displayImage(widget.itemModel.image!, widget.itemModel.name,
        FirebaseConstants.items);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(widget.onTap != null ? 10 : 0),
          child: InkWell(
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
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(200),
                        blurRadius: 10,
                        offset: const Offset(-2, 2))
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: file != null
                        ? file!.path == ""
                            ? Container(
                                width: 110,
                                height: 120,
                                color: mainBgColor,
                                child: const Center(
                                  child: Icon(
                                    Icons.wifi_off,
                                    size: 110,
                                  ),
                                ),
                              )
                            : Image.file(
                                file!,
                                width: 110,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                        : SizedBox(
                            width: 110,
                            height: 120,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.itemModel.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.itemModel.category,
                          style: TextStyle(color: textColor, fontSize: 14),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        widget.onTap == null
            ? const SizedBox()
            : Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: primaryColor, shape: BoxShape.circle),
                  child: Center(
                      child: Text(
                    '${widget.itemModel.quantity}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ))
      ],
    );
  }
}
