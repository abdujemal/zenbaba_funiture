import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/model/item_model.dart';
import 'package:zenbaba_funiture/view/Pages/add_item.dart';
import 'package:zenbaba_funiture/view/controller/l_s_controller.dart';
import 'package:zenbaba_funiture/view/widget/left_line.dart';

class ItemDetail extends StatefulWidget {
  final ItemModel itemModel;
  const ItemDetail({super.key, required this.itemModel});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  LSController lsController = Get.find<LSController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Item#${widget.itemModel.id}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          lsController.currentUser.value.priority != UserPriority.AdminView
              ? IconButton(
                  onPressed: () {
                    Get.to(
                      () => AddItem(
                        itemModel: widget.itemModel,
                      ),
                    );
                  },
                  icon: SvgPicture.asset(
                    'assets/edit.svg',
                    color: whiteColor,
                    height: 20,
                    width: 20,
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            section(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Item detail",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: displayImage(
                    widget.itemModel.image!,
                    widget.itemModel.id!,
                    FirebaseConstants.items,
                  ),
                  builder: (context, ds) {
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: ds.data != null
                            ? ds.data!.path != ""
                                ? DecorationImage(
                                    image: FileImage(ds.data!),
                                  )
                                : null
                            : null,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                keyVal(
                  "Item",
                  widget.itemModel.name,
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  color: textColor,
                  thickness: 0.6,
                ),
                keyVal(
                  "Category",
                  widget.itemModel.category,
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  color: textColor,
                  thickness: 0.6,
                ),
                keyVal(
                  "Unit",
                  widget.itemModel.unit,
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  color: textColor,
                  thickness: 0.6,
                ),
                keyVal(
                  "Price Per Unit",
                  "${formatNumber(widget.itemModel.pricePerUnit.round())} br",
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  color: textColor,
                  thickness: 0.6,
                ),
                keyVal(
                  "Description",
                  widget.itemModel.description,
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            section(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Price timeline",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (widget.itemModel.timeLine.isEmpty)
                  const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text("No Price Time Line"),
                    ),
                  ),
                ...List.generate(
                  widget.itemModel.timeLine.length,
                  (index) => LeftLined(
                    circleColor: primaryColor,
                    onTap: () {},
                    showBottomBorder: false,
                    isLast: widget.itemModel.timeLine.length - 1 == index,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat("EEE / dd MMMM / yyyy").format(
                              DateTime.parse(
                                (widget.itemModel.timeLine[index].date),
                              ),
                            ),
                            style: TextStyle(
                              color: textColor,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                            ),
                            child: Text(
                              "${widget.itemModel.timeLine[index].price} br",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
