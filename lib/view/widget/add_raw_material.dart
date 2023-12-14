import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/model/item_model.dart';
import 'package:zenbaba_funiture/data/model/product_model.dart';
import 'package:zenbaba_funiture/view/widget/sl_btn.dart';
import 'package:zenbaba_funiture/view/widget/sl_input.dart';
import 'package:zenbaba_funiture/view/widget/special_dropdown.dart';

class AddRawMaterial extends StatefulWidget {
  final List<ItemModel> items;
  final RawMaterial? rawMaterial;
  final Function(RawMaterial rawMaterial) onSave;
  const AddRawMaterial({
    super.key,
    required this.items,
    required this.onSave,
    this.rawMaterial,
  });

  @override
  State<AddRawMaterial> createState() => _AddRawMaterialState();
}

class _AddRawMaterialState extends State<AddRawMaterial> {
  ItemModel? selectedItem;

  TextEditingController quantityTc = TextEditingController();
  @override
  void initState() {
    super.initState();
    selectedItem = widget.items.first;
    if (widget.rawMaterial != null) {
      selectedItem =
          widget.items.firstWhere((e) => e.name == widget.rawMaterial!.name);
      quantityTc.text = widget.rawMaterial!.quantity.toString();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      child: SizedBox(
        height: 300,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            selectedItem == null
                ? const Text("Item not found")
                : SpecialDropdown(
                    items: widget.items
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.name,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: Row(
                                children: [
                                  Flexible(
                                      flex: 3,
                                      child: Text(
                                        e.name,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      "${e.pricePerUnit}br",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    title: "Items",
                    value: selectedItem?.name,
                    width: double.infinity,
                    list: widget.items.map((e) => e.name).toList(),
                    onChange: (v) {
                      selectedItem =
                          widget.items.firstWhere((e) => e.name == v);
                      setState(() {});
                    },
                  ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: SLInput(
                    title: "Quantity",
                    hint: '5',
                    inputColor: whiteColor,
                    otherColor: textColor,
                    keyboardType: TextInputType.number,
                    controller: quantityTc,
                    isOutlined: true,
                    readOnly: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    selectedItem?.unit ?? "__",
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SLBtn(
              text: "Save",
              onTap: () {
                if (selectedItem != null && double.parse(quantityTc.text) > 0) {
                  widget.onSave(
                    RawMaterial(
                      name: selectedItem!.name,
                      unit: selectedItem!.unit,
                      unitPrice: selectedItem!.pricePerUnit,
                      quantity: double.parse(quantityTc.text),
                      totalPrice: selectedItem!.pricePerUnit *
                          double.parse(quantityTc.text),
                    ),
                  );
                } else {
                  Get.back();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
