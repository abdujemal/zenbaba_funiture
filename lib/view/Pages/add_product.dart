import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:zenbaba_funiture/view/widget/special_dropdown.dart';

import '../../constants.dart';
import '../../data/model/product_model.dart';
import '../controller/main_controller.dart';
import '../widget/custom_btn.dart';
import '../widget/my_dropdown.dart';
import '../widget/sl_input.dart';

class AddProduct extends StatefulWidget {
  final ProductModel? productModel;
  final String? category;
  const AddProduct({super.key, this.productModel, this.category});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController productNameTc = TextEditingController();

  TextEditingController productSkuTc = TextEditingController();

  String selectedCategory = ProductCategory.BadyBed;

  TextEditingController productPriceTc = TextEditingController();

  TextEditingController sizeTc = TextEditingController();

  TextEditingController productDescriptionTc = TextEditingController();

  TextfieldTagsController _controller = TextfieldTagsController();

  List<String> initialTags = [];

  MainConntroller mainConntroller = Get.find<MainConntroller>();

  var productFormState = GlobalKey<FormState>();

  List<File> selectedImages = [];

  List<String> urlImages = [];

  List<File?> imageFromUrls = [];

  var _distanceToField;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width - 46;
  }

  @override
  void initState() {
    super.initState();
    if (widget.productModel != null) {
      urlImages = widget.productModel!.images.map((e) => e as String).toList();
      productNameTc.text = widget.productModel!.name;
      productSkuTc.text = widget.productModel!.sku;
      selectedCategory = widget.productModel!.category;
      productPriceTc.text = widget.productModel!.price.toString();
      productDescriptionTc.text = widget.productModel!.description;
      sizeTc.text = widget.productModel!.size;
      initialTags = widget.productModel!.tags.map((e) => e as String).toList();
      setImageFile();
    }

    if (widget.category != null) {
      selectedCategory = widget.category!;
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
      File? file = await displayImage(
        url,
        "${widget.productModel!.sku}$i",
        "${FirebaseConstants.products}/${widget.productModel!.sku}",
      );
      imageFromUrls.add(file);
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
                child: Image.file(
                  selectedImages[index],
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ));
          },
        ),
      );
    } else if (urlImages.isNotEmpty) {
      return SizedBox(
        height: 200,
        child: imageFromUrls.isEmpty
            ? Center(
                child: Container(
                  color: mainBgColor,
                  height: 200,
                  width: 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                ),
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
                    child: imageFromUrls[index] != null
                        ? Image.file(
                            imageFromUrls[index]!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: mainBgColor,
                            height: 200,
                            width: 200,
                            child: const Center(child: Text("No Network")),
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
          TextFieldTags(
            textfieldTagsController: _controller,
            textSeparators: const [','],
            initialTags: initialTags,
            letterCase: LetterCase.normal,
            validator: (String tag) {
              if (_controller.getTags!.contains(tag)) {
                return 'you already entered that';
              }
              return null;
            },
            inputfieldBuilder:
                (context, tec, fn, error, onChanged, onSubmitted) {
              return ((context, sc, tags, onTagDelete) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: tec,
                    focusNode: fn,
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
                      hintText: _controller.hasTags ? '' : "Enter tag...",
                      errorText: error,
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
                      prefixIcon: tags.isNotEmpty
                          ? SingleChildScrollView(
                              controller: sc,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: tags.map((String tag) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                    color: primaryColor,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        child: Text(
                                          '#$tag',
                                          style: const TextStyle(
                                              color: Colors.white),
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
                                          color: Color.fromARGB(
                                              255, 233, 233, 233),
                                        ),
                                        onTap: () {
                                          onTagDelete(tag);
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }).toList()),
                            )
                          : null,
                    ),
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title(
            widget.productModel != null ? "Product Detail" : "New Product"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            }),
      ),
      body: SingleChildScrollView(
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
                    List<XFile> xFiles =
                        await ImagePicker().pickMultiImage(imageQuality: 25);
                    selectedImages = [];
                    if (xFiles.isNotEmpty) {
                      for (XFile xFile in xFiles) {
                        selectedImages.add(File(xFile.path));
                      }
                      setState(() {});
                    } else {
                      toast("No image is selected.", ToastType.error);
                    }
                  },
                  child: Ink(
                    child: image(),
                  ),
                ),
                const SizedBox(
                  height: 15,
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
                SpecialDropdown(
                  value: selectedCategory,
                  list: ProductCategory.list,
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
                SLInput(
                  title: "Price",
                  hint: '3000',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.number,
                  controller: productPriceTc,
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
                                    if (_controller.hasTags) {
                                      if (widget.productModel == null) {
                                        if (selectedImages.isNotEmpty) {
                                          mainConntroller.addProduct(
                                              ProductModel(
                                                id: null,
                                                name: productNameTc.text,
                                                sku: productSkuTc.text,
                                                category: selectedCategory,
                                                description:
                                                    productDescriptionTc.text,
                                                images: [],
                                                price: double.parse(
                                                    productPriceTc.text),
                                                tags: _controller.getTags!,
                                                size: sizeTc.text,
                                              ),
                                              selectedImages);
                                        } else {
                                          toast(
                                            "Please select the images.",
                                            ToastType.error,
                                          );
                                        }
                                      } else {
                                        mainConntroller.updateProduct(
                                            ProductModel(
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
                                            ),
                                            selectedImages);
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
                                                  widget.productModel!.images
                                                      .length,
                                                );
                                              }
                                            },
                                            text: "Delete")
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
    );
  }
}
