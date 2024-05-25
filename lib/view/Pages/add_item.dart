import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_web/image_picker_web.dart'; //TODO: free up every thing to load web
import 'package:zenbaba_funiture/view/widget/special_dropdown.dart';
import '../../constants.dart';
import '../../data/model/item_model.dart';
import '../../data/model/time_line_model.dart';
import '../controller/main_controller.dart';
import '../widget/custom_btn.dart';
import '../widget/sl_input.dart';

class AddItem extends StatefulWidget {
  final ItemModel? itemModel;
  const AddItem({super.key, this.itemModel});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  var itemNameTc = TextEditingController();

  var selectedCategory = ItemCategory.Accessories;

  MainConntroller mainConntroller = Get.find<MainConntroller>();

  var selectedUnit = Units.Pcs;

  var pricePerUnitTc = TextEditingController();

  var itemDescriptionTc = TextEditingController();

  var selectedImage;

  var itemFormState = GlobalKey<FormState>();

  var urlImage = "";

  File? imageFromUrl;

  @override
  void dispose() {
    itemNameTc.dispose();
    pricePerUnitTc.dispose();
    itemDescriptionTc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.itemModel != null) {
      itemNameTc.text = widget.itemModel!.name;
      selectedCategory = widget.itemModel!.category;
      selectedUnit = widget.itemModel!.unit;
      pricePerUnitTc.text = widget.itemModel!.pricePerUnit.toString();
      itemDescriptionTc.text = widget.itemModel!.description;
      urlImage = widget.itemModel!.image!;
      setImageFile();
    }
  }

  setImageFile() async {
    imageFromUrl = await displayImage(
      urlImage,
      widget.itemModel!.id!,
      FirebaseConstants.items,
    );

    if (mounted) {
      setState(() {});
    }
  }

  image() {
    if (selectedImage != null) {
      if (kIsWeb) {
        return Image.memory(
          selectedImage,
          height: 200,
          width: 200,
        );
      }
      return Image.file(
        selectedImage!,
        height: 200,
        width: 200,
      );
    } else if (urlImage != "") {
      return imageFromUrl != null
          ? imageFromUrl?.path == ""
              ? Container(
                  color: mainBgColor,
                  height: 200,
                  width: 200,
                  child: const Center(child: Text("No Network")),
                )
              : Image.file(
                  imageFromUrl!,
                  height: 200,
                  width: 200,
                )
          : kIsWeb
              ? CachedNetworkImage(
                  imageUrl: urlImage,
                  height: 200,
                  width: 200,
                )
              : Container(
                  color: mainBgColor,
                  height: 200,
                  width: 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                );
    } else {
      return const Icon(Icons.image, size: 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title(widget.itemModel != null
            ? "Item#${widget.itemModel!.id}"
            : "New Item"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            }),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: itemFormState,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    if (kIsWeb) {
                      // TODO: free up every thing to load web
                      
                      // Uint8List? xFile = await ImagePickerWeb.getImageAsBytes();

                      // if (xFile != null) {
                      //   setState(() {
                      //     selectedImage = xFile;
                      //   });
                      // } else {
                      //   toast("No Image is selected.", ToastType.error);
                      // }
                    } else {
                      XFile? xFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (xFile != null) {
                        setState(() {
                          selectedImage = File(xFile.path);
                        });
                      } else {
                        toast("No Image is selected.", ToastType.error);
                      }
                    }
                  },
                  child: Ink(child: image()),
                ),
                SLInput(
                  title: "Item Name",
                  hint: 'MDF',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.text,
                  controller: itemNameTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                SpecialDropdown<String>(
                  value: selectedCategory,
                  list: ItemCategory.list,
                  title: "Category",
                  onChange: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 15,
                ),
                SpecialDropdown<String>(
                  value: selectedUnit,
                  list: Units.list,
                  title: "Unit",
                  onChange: (value) {
                    setState(() {
                      selectedUnit = value!;
                    });
                  },
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 15,
                ),
                SLInput(
                  title: "Price per unit",
                  hint: '2000',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.number,
                  controller: pricePerUnitTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                SLInput(
                  title: "Description",
                  hint: 'Description',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.text,
                  controller: itemDescriptionTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 50,
                ),
                Obx(() {
                  return mainConntroller.itemStatus.value ==
                          RequestState.loading
                      ? CircularProgressIndicator(
                          color: primaryColor,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomBtn(
                              btnState: Btn.filled,
                              color: primaryColor,
                              onTap: () {
                                if (itemFormState.currentState!.validate()) {
                                  if (widget.itemModel != null) {
                                    List<TimeLineModel> timeLine =
                                        widget.itemModel!.timeLine;

                                    if (widget.itemModel!.pricePerUnit !=
                                        double.parse(pricePerUnitTc.text)) {
                                      // print("Not Equal price");
                                      timeLine.add(
                                        TimeLineModel(
                                          date: DateTime.now().toString(),
                                          price:
                                              double.parse(pricePerUnitTc.text),
                                        ),
                                      );
                                      print(timeLine
                                          .map((x) => x.toMap())
                                          .toList());
                                    }

                                    if (selectedImage != null) {
                                      mainConntroller.updateItem(
                                        selectedImage!,
                                        ItemModel(
                                            id: widget.itemModel!.id,
                                            image: null,
                                            name: itemNameTc.text,
                                            category: selectedCategory,
                                            unit: selectedUnit,
                                            pricePerUnit: double.parse(
                                                pricePerUnitTc.text),
                                            description: itemDescriptionTc.text,
                                            quantity: 0,
                                            timeLine: timeLine,
                                            lastUsedFor:
                                                widget.itemModel!.lastUsedFor),
                                      );
                                    } else {
                                      mainConntroller.updateItem(
                                        null,
                                        ItemModel(
                                            id: widget.itemModel!.id,
                                            image: urlImage,
                                            name: itemNameTc.text,
                                            category: selectedCategory,
                                            unit: selectedUnit,
                                            pricePerUnit: double.parse(
                                                pricePerUnitTc.text),
                                            description: itemDescriptionTc.text,
                                            quantity: 0,
                                            timeLine: timeLine,
                                            lastUsedFor:
                                                widget.itemModel!.lastUsedFor),
                                      );
                                    }
                                  } else {
                                    mainConntroller.addItem(
                                      selectedImage,
                                      ItemModel(
                                        id: null,
                                        image:
                                            selectedImage == null ? "" : null,
                                        name: itemNameTc.text,
                                        category: selectedCategory,
                                        unit: selectedUnit,
                                        pricePerUnit:
                                            double.parse(pricePerUnitTc.text),
                                        description: itemDescriptionTc.text,
                                        quantity: 0,
                                        lastUsedFor: "",
                                        timeLine: [
                                          TimeLineModel(
                                            date: DateTime.now().toString(),
                                            price: double.parse(
                                                pricePerUnitTc.text),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              text: "Save",
                            ),
                            widget.itemModel == null
                                ? const SizedBox()
                                : Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text("or"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      CustomBtn(
                                          btnState: Btn.outlined,
                                          color: textColor,
                                          onTap: () {
                                            mainConntroller.delete(
                                                FirebaseConstants.items,
                                                widget.itemModel!.id!,
                                                widget.itemModel!.id!,
                                                true,
                                                [widget.itemModel!.image!]);
                                          },
                                          text: "Delete")
                                    ],
                                  )
                          ],
                        );
                }),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
