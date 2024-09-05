// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/_internal/file_picker_web.dart'; //TODO: free up every thing to load web
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart'; //TODO: free up every thing to load web;
import 'package:textfield_tags/textfield_tags.dart';
import 'package:zenbaba_funiture/data/model/item_model.dart';
import 'package:zenbaba_funiture/view/widget/add_raw_material.dart';
import 'package:zenbaba_funiture/view/widget/additional_files_selector.dart';
import 'package:zenbaba_funiture/view/widget/raw_material_item.dart';

import 'package:zenbaba_funiture/view/widget/special_dropdown.dart';

import '../../constants.dart';
import '../../data/model/product_model.dart';
import '../controller/main_controller.dart';
import '../widget/custom_btn.dart';
import '../widget/sl_input.dart';

class AddProduct extends StatefulWidget {
  final ProductModel? productModel;
  final bool isDuplicate;
  final String? category;
  final bool returnIfAdded;
  const AddProduct({
    super.key,
    this.productModel,
    this.category,
    this.returnIfAdded = false,
    this.isDuplicate = false,
  });

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController productNameTc = TextEditingController();

  TextEditingController productSkuTc = TextEditingController();

  String selectedCategory = ProductCategory.BadyBed;

  TextEditingController productPriceTc = TextEditingController();

  TextEditingController sizeTc = TextEditingController();

  TextEditingController overheadTc = TextEditingController(text: "0");
  TextEditingController labourTc = TextEditingController(text: "0");
  TextEditingController profitTc = TextEditingController(text: "0");

  TextEditingController productDescriptionTc = TextEditingController();

  TextfieldTagsController<String> _controller =
      TextfieldTagsController<String>();

  List<String> initialTags = [];

  MainConntroller mainConntroller = Get.find<MainConntroller>();

  var productFormState = GlobalKey<FormState>();

  List selectedImages = [];

  List selectedFiles = [];

  List<String> urlImages = [];

  List<File> imageFromUrls = [];

  List<RawMaterial> rawMaterials = [];

  List<String> rawMaterialIds = [];

  List<ItemModel> items = [];

  List<String> tableHeader = [
    "Raw Material",
    "Qty",
    "Total Price",
  ];

  Map consts = {
    "contingency": 0,
    "general and adminstration": 0,
    "selling and distribution": 0,
    "total overhead": 0,
  };

  // List<String>

  // List<>

  var _distanceToField;

  List<String> fileNames = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width - 46;
  }

  @override
  void initState() {
    super.initState();
    getConsts().then((value) {
      print(value);
      consts = value;
      setState(() {});
    });

    items = mainConntroller.items;
    if (widget.productModel != null) {
      urlImages = widget.productModel!.images.map((e) => e as String).toList();
      productNameTc.text = widget.productModel!.name;
      productSkuTc.text = widget.productModel!.sku;
      selectedCategory = widget.productModel!.category;
      productPriceTc.text = widget.productModel!.price.toString();
      productDescriptionTc.text = widget.productModel!.description;
      labourTc.text = widget.productModel!.labourCost?.toString() ?? "0";
      overheadTc.text = widget.productModel!.overhead?.toString() ?? "0";
      profitTc.text = widget.productModel!.profit?.toString() ?? "0";
      sizeTc.text = widget.productModel!.size;
      initialTags = widget.productModel!.tags.map((e) => e as String).toList();
      rawMaterials = widget.productModel!.rawMaterials;
      rawMaterialIds = widget.productModel!.rawMaterialIds;
      print(widget.productModel!.toMap());
      setImageFile();

      if (widget.isDuplicate && widget.productModel?.relatedFiles != null) {
        downloadFilesWeb(widget.productModel!.relatedFiles!).then((unit8Lists) {
          selectedFiles = unit8Lists;
          setState(() {});
        });
      }

      if (widget.isDuplicate) {
        getSku(widget.productModel!.category).then((sku) {
          setState(() {
            productSkuTc.text = sku;
          });
        });
      }
    }

    if (widget.category != null) {
      selectedCategory = widget.category!;

      if (widget.productModel == null) {
        getSku(widget.category!).then((sku) {
          setState(() {
            productSkuTc.text = sku;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    productNameTc.dispose();
    productSkuTc.dispose();
    productPriceTc.dispose();
    sizeTc.dispose();
    productDescriptionTc.dispose();
    _controller.dispose();
    super.dispose();
  }

  setImageFile() async {
    imageFromUrls = [];
    int i = 0;
    for (String url in urlImages) {
      if (kIsWeb) {
        Uint8List file = await downloadFileWeb(url);
        // if (file != null) {
        selectedImages.add(file);
        print("Worked");
        // }
      } else {
        File? file = await displayImage(
          url,
          "${widget.productModel!.sku}$i",
          "${FirebaseConstants.products}/${widget.productModel!.sku}",
        );
        if (file != null) {
          imageFromUrls.add(file);
        }
      }
      i++;
    }

    if (mounted) {
      setState(() {});
    }
  }

  image() {
    if (selectedImages.isNotEmpty) {
      return SizedBox(
        height: 200,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: selectedImages.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: kIsWeb
                  ? Image.memory(
                      selectedImages[index],
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      selectedImages[index],
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
            );
          },
        ),
      );
    } else if (urlImages.isNotEmpty) {
      return SizedBox(
        height: 200,
        child: imageFromUrls.isEmpty
            ? kIsWeb
                ? ListView.builder(
                    itemCount: widget.productModel!.images.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: widget.productModel!.images[index],
                        height: 200,
                        width: 200,
                      );
                    },
                  )
                : Container(
                    color: mainBgColor,
                    height: 200,
                    width: 200,
                    child: const Center(child: Text("Loading")),
                  )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: imageFromUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Image.file(
                      imageFromUrls[index],
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  );
                }),
      );
    } else {
      return const Icon(Icons.image, size: 100);
    }
  }

  inputtags() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              'tags',
              style: TextStyle(color: textColor),
            ),
          ),
          TextFieldTags<String>(
            textfieldTagsController: _controller,
            textSeparators: const [','],
            initialTags: initialTags,
            letterCase: LetterCase.normal,
            validator: (tag) {
              if (_controller.getTags!.contains(tag)) {
                return 'you already entered that';
              }
              return null;
            },
            inputFieldBuilder: (BuildContext context,
                    InputFieldValues<String> textFieldTagValues) =>
                Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: textFieldTagValues.textEditingController,
                focusNode: textFieldTagValues.focusNode,
                decoration: InputDecoration(
                  isDense: true,
                  fillColor: mainBgColor,
                  filled: true,
                  hintStyle: TextStyle(color: textColor),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  hintText: _controller.getTags?.isNotEmpty == true
                      ? "Enter tag..."
                      : "",
                  errorText: textFieldTagValues.error,
                  prefixIconConstraints:
                      BoxConstraints(maxWidth: _distanceToField * 0.60),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        _controller.clearTags();
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                  prefixIcon: textFieldTagValues.tags.isNotEmpty
                      ? SingleChildScrollView(
                          controller: textFieldTagValues.tagScrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: _controller.getTags!.map((String tag) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                color: primaryColor,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 5.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Text(
                                      '#$tag',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      print("$tag selected");
                                    },
                                  ),
                                  const SizedBox(width: 4.0),
                                  InkWell(
                                    child: const Icon(
                                      Icons.cancel,
                                      size: 14.0,
                                      color: Color.fromARGB(255, 233, 233, 233),
                                    ),
                                    onTap: () {
                                      _controller.onTagDelete(tag);
                                    },
                                  )
                                ],
                              ),
                            );
                          }).toList()),
                        )
                      : null,
                ),
                onChanged: textFieldTagValues.onChanged,
                onSubmitted: textFieldTagValues.onSubmitted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (int.tryParse(profitTc.text.isEmpty ? "0" : profitTc.text) != 0) {
      productPriceTc.text = sellingPrice(consts, overheadTc.text, labourTc.text,
              profitTc.text, rawMaterials)
          .toStringAsFixed(2);
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title(widget.productModel != null
            ? widget.isDuplicate
                ? "New Product (duplicate)"
                : "Product Detail"
            : "New Product"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            }),
        actions: [
          IconButton(
            onPressed: () async {
              getConsts().then((value) {
                print(value);
                consts = value;
                setState(() {});
              });
              await mainConntroller.getItems();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getConsts().then((value) {
            print(value);
            consts = value;
            setState(() {});
          });
          await mainConntroller.getItems();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: productFormState,
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

                        List<Uint8List>? xFiles =
                            await ImagePickerWeb.getMultiImagesAsBytes();
                        selectedImages = [];
                        if (xFiles?.isNotEmpty ?? false) {
                          for (Uint8List xFile in xFiles!) {
                            selectedImages.add(xFile);
                          }
                          setState(() {});
                        } else {
                          toast("No image is selected.", ToastType.error);
                        }
                      } else {
                        List<XFile> xFiles = await ImagePicker()
                            .pickMultiImage(imageQuality: 25);
                        selectedImages = [];
                        if (xFiles.isNotEmpty) {
                          for (XFile xFile in xFiles) {
                            selectedImages.add(File(xFile.path));
                          }
                          setState(() {});
                        } else {
                          toast("No image is selected.", ToastType.error);
                        }
                      }
                    },
                    child: Ink(
                      child: image(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AdditionalFilesSelector(
                    names: fileNames,
                    files: selectedFiles,
                    relatedFiles: widget.productModel?.relatedFiles,
                    onTap: () async {
                      if (kIsWeb) {
                        //TODO: free up every thing to load web

                        final result = await FilePickerWeb.platform.pickFiles(
                          allowMultiple: true,
                          allowCompression: false,
                        );
                        if (result != null) {
                          selectedFiles =
                              result.files.map((e) => e.bytes).toList();
                          fileNames = result.files.map((e) => e.name).toList();
                          setState(() {});
                          // } else {
                          // toast(
                          //     "Please selected .pdf file.", ToastType.error);
                          // }
                        } else {
                          toast("Some thing wrong.", ToastType.error);
                        }
                      } else {
                        print("Works.....");
                        final result = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          allowCompression: false,
                        );
                        if (result != null) {
                          selectedFiles =
                              result.files.map((e) => e.path).toList();
                          fileNames = result.files
                              .map((e) => e.path?.split("/").last ?? "Unknown")
                              .toList();
                          setState(() {});
                        } else {
                          toast("Some thing wrong.", ToastType.error);
                        }
                      }
                    },
                  ),
                  SLInput(
                    title: "Product name",
                    hint: 'Corner Shelf',
                    inputColor: whiteColor,
                    otherColor: textColor,
                    keyboardType: TextInputType.text,
                    controller: productNameTc,
                    isOutlined: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SLInput(
                    title: "SKU",
                    hint: 'ZF0101',
                    inputColor: whiteColor,
                    otherColor: textColor,
                    keyboardType: TextInputType.text,
                    controller: productSkuTc,
                    isOutlined: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SLInput(
                    title: "Size",
                    hint: '120m',
                    inputColor: whiteColor,
                    otherColor: textColor,
                    keyboardType: TextInputType.text,
                    controller: sizeTc,
                    isOutlined: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SLInput(
                    title: "Description",
                    hint: 'add description',
                    inputColor: whiteColor,
                    otherColor: textColor,
                    keyboardType: TextInputType.multiline,
                    controller: productDescriptionTc,
                    isOutlined: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SpecialDropdown(
                    value: selectedCategory,
                    list: ProductCategory.list,
                    title: "Category",
                    onChange: (value) {
                      getSku(value).then((sku) {
                        setState(() {
                          productSkuTc.text = sku;
                        });
                      });
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                    width: double.infinity,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 23 + 15),
                        child: Text(
                          "Material Cost",
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: mainBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // height: 400,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 23,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(tableHeader.length + 1,
                                  (index) {
                                if (tableHeader.length == index) {
                                  return const SizedBox(width: 20);
                                }
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      tableHeader[index],
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            ...List.generate(
                              rawMaterials.length,
                              (index) => RawMaterialItem(
                                rawMaterial: rawMaterials[index],
                                onUpdate: () {
                                  bool available = items.any(
                                    (e) => e.name == rawMaterials[index].name,
                                  );
                                  if (available) {
                                    Get.bottomSheet(
                                      AddRawMaterial(
                                        items: items,
                                        rawMaterial: rawMaterials[index],
                                        onSave: (RawMaterial rawMaterial) {
                                          rawMaterials[index] = rawMaterial;
                                          rawMaterialIds[index] =
                                              rawMaterial.id;
                                          setState(() {});
                                          Get.back();
                                        },
                                      ),
                                    );
                                  } else {
                                    toast(
                                      "The Item is no longer available.",
                                      ToastType.error,
                                    );
                                  }
                                },
                                onDelete: () {
                                  rawMaterials.remove(rawMaterials[index]);
                                  rawMaterialIds.remove(rawMaterials[index].id);
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child:
                                  Text("Total: ${materialCost(rawMaterials)}"),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                child: const Text("Add"),
                                onPressed: () {
                                  Get.bottomSheet(
                                    AddRawMaterial(
                                      items: items,
                                      onSave: (RawMaterial rawMaterial) {
                                        rawMaterials.add(rawMaterial);
                                        rawMaterialIds.add(rawMaterial.id);
                                        setState(() {});
                                        Get.back();
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SLInput(
                          title: "Labour cost",
                          hint: '1000',
                          inputColor: whiteColor,
                          otherColor: textColor,
                          keyboardType: TextInputType.number,
                          controller: labourTc,
                          margin: 0,
                          isOutlined: true,
                          width: 100,
                          onChanged: (v) {
                            setState(() {});
                          },
                        ),
                        SLInput(
                          title: "Overhead",
                          hint: '10',
                          inputColor: whiteColor,
                          otherColor: textColor,
                          keyboardType: TextInputType.number,
                          controller: overheadTc,
                          margin: 0,
                          isOutlined: true,
                          width: 100,
                          onChanged: (v) {
                            setState(() {});
                          },
                        ),
                        SLInput(
                          title: "Profit(%)",
                          hint: '50',
                          margin: 0,
                          inputColor: whiteColor,
                          otherColor: textColor,
                          keyboardType: TextInputType.number,
                          controller: profitTc,
                          isOutlined: true,
                          width: 100,
                          onChanged: (v) {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 23 + 15),
                        child: Text(
                          "Manufacturing Cost",
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                          color: mainBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // height: 400,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 23,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("\u2211 overhead"),
                                  Text(
                                      "${totalOverhead(consts, overheadTc.text)}"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("total productn"),
                                  Text(totalProductionCost(
                                    consts,
                                    overheadTc.text,
                                    labourTc.text,
                                    rawMaterials,
                                  ).toStringAsFixed(2)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("general and admin"),
                                  Text(
                                      "${consts["general and adminstration"]}%"),
                                  Text(generalAdministration(
                                    consts,
                                    overheadTc.text,
                                    labourTc.text,
                                    rawMaterials,
                                  ).toStringAsFixed(2))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("selling and distributn"),
                                  Text(
                                      "${consts["selling and distribution"]}%"),
                                  Text(sellingDistribution(
                                    consts,
                                    overheadTc.text,
                                    labourTc.text,
                                    rawMaterials,
                                  ).toStringAsFixed(2))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "\u2211 cost and expention",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(totalCostAndExpention(
                                    consts,
                                    overheadTc.text,
                                    labourTc.text,
                                    rawMaterials,
                                  ).toStringAsFixed(2))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("contingency"),
                                  Text("${consts["contingency"]}%"),
                                  Text(contengency(
                                    consts,
                                    overheadTc.text,
                                    labourTc.text,
                                    rawMaterials,
                                  ).toStringAsFixed(2))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Manufacturn Cost",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(manufacturingCost(
                                    consts,
                                    overheadTc.text,
                                    labourTc.text,
                                    rawMaterials,
                                  ).toStringAsFixed(2))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Profit",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(profit(
                                    consts,
                                    overheadTc.text,
                                    labourTc.text,
                                    profitTc.text,
                                    rawMaterials,
                                  ).toStringAsFixed(2))
                                ],
                              ),
                            ]),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SLInput(
                    title: "Price",
                    hint: '3000',
                    inputColor: whiteColor,
                    otherColor: textColor,
                    keyboardType: TextInputType.number,
                    controller: productPriceTc,
                    isOutlined: true,
                    // readOnly: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  inputtags(),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () {
                      return mainConntroller.productStatus.value ==
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
                                  text: 'Save',
                                  onTap: () async {
                                    if (productFormState.currentState!
                                        .validate()) {
                                      if (_controller.getTags?.isNotEmpty ==
                                          true) {
                                        if (widget.productModel == null) {
                                          // if (selectedImages.isNotEmpty) {
                                          final model = ProductModel(
                                            id: null,
                                            relatedFiles: null,
                                            name: productNameTc.text,
                                            sku: productSkuTc.text,
                                            category: selectedCategory,
                                            description:
                                                productDescriptionTc.text,
                                            images: const [],
                                            price: double.parse(
                                                productPriceTc.text),
                                            tags: _controller.getTags!,
                                            size: sizeTc.text,
                                            rawMaterials: rawMaterials,
                                            rawMaterialIds: rawMaterials
                                                .map((e) => e.id)
                                                .toList(),
                                            labourCost:
                                                double.parse(labourTc.text),
                                            overhead:
                                                double.parse(overheadTc.text),
                                            profit: double.parse(profitTc.text),
                                          );
                                          if (widget.returnIfAdded) {
                                            String? id = await mainConntroller
                                                .addProductRid(
                                                    model,
                                                    selectedImages,
                                                    selectedFiles,
                                                    fileNames,
                                                    goBack:
                                                        !widget.returnIfAdded);
                                            if (mounted && id != null) {
                                              Navigator.pop(
                                                context,
                                                model.copyWith(id: id),
                                              );
                                            }
                                          } else {
                                            await mainConntroller.addProduct(
                                              model,
                                              selectedImages,
                                              selectedFiles,
                                              fileNames,
                                            );
                                          }
                                        } else {
                                          if (widget.isDuplicate) {
                                            mainConntroller.addProduct(
                                              ProductModel(
                                                id: null,
                                                relatedFiles: null,
                                                name: productNameTc.text,
                                                sku: productSkuTc.text,
                                                category: selectedCategory,
                                                description:
                                                    productDescriptionTc.text,
                                                images: const [],
                                                price: double.parse(
                                                    productPriceTc.text),
                                                tags: _controller.getTags!,
                                                size: sizeTc.text,
                                                rawMaterials: rawMaterials,
                                                rawMaterialIds: rawMaterials
                                                    .map((e) => e.id)
                                                    .toList(),
                                                labourCost:
                                                    double.parse(labourTc.text),
                                                overhead: double.parse(
                                                    overheadTc.text),
                                                profit:
                                                    double.parse(profitTc.text),
                                              ),
                                              selectedImages.isEmpty
                                                  ? imageFromUrls
                                                  : selectedImages,
                                              selectedFiles,
                                              fileNames,
                                            );
                                          } else {
                                            print("works");
                                            mainConntroller.updateProduct(
                                              widget.productModel!.copyWith(
                                                id: widget.productModel!.id,
                                                name: productNameTc.text,
                                                sku: productSkuTc.text,
                                                category: selectedCategory,
                                                description:
                                                    productDescriptionTc.text,
                                                images:
                                                    widget.productModel!.images,
                                                price: double.parse(
                                                    productPriceTc.text),
                                                tags: _controller.getTags!,
                                                size: sizeTc.text,
                                                rawMaterials: rawMaterials,
                                                rawMaterialIds: rawMaterials
                                                    .map((e) => e.id)
                                                    .toList(),
                                                labourCost:
                                                    double.parse(labourTc.text),
                                                overhead: double.parse(
                                                    overheadTc.text),
                                                profit:
                                                    double.parse(profitTc.text),
                                              ),
                                              selectedImages.isEmpty
                                                  ? imageFromUrls
                                                  : selectedImages,
                                              selectedFiles,
                                              fileNames,
                                            );
                                          }
                                        }
                                      } else {
                                        toast("tags is empty", ToastType.error);
                                      }
                                    }
                                  },
                                ),
                                widget.productModel != null
                                    ? Row(
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
                                              if (widget.productModel != null) {
                                                mainConntroller.delete(
                                                  FirebaseConstants.products,
                                                  widget.productModel!.id!,
                                                  widget.productModel!.sku,
                                                  true,
                                                  [
                                                    ...widget
                                                        .productModel!.images,
                                                    ...widget.productModel!
                                                            .relatedFiles ??
                                                        [],
                                                  ]
                                                      .map((e) => e as String)
                                                      .toList(),
                                                );
                                              }
                                            },
                                            text: "Delete",
                                          )
                                        ],
                                      )
                                    : const SizedBox(),
                              ],
                            );
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
