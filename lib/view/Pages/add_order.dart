import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker_web/image_picker_web.dart'; // TODO: free up every thing to load web
import 'package:textfield_tags/textfield_tags.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenbaba_funiture/view/Pages/add_product.dart';
import 'package:zenbaba_funiture/view/widget/special_dropdown.dart';

import '../../constants.dart';
import '../../data/model/cutomer_model.dart';
import '../../data/model/order_model.dart';
import '../../data/model/product_model.dart';
import '../controller/main_controller.dart';
import '../widget/custom_btn.dart';
import '../widget/order_dialog.dart';
import '../widget/order_product_card.dart';
import '../widget/sl_input.dart';
// import '../widget/sl_input.dart';

// TODO: bankaccount should be recomanded

class AddOrder extends StatefulWidget {
  final OrderModel? orderModel;
  const AddOrder({super.key, this.orderModel});

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  List<ProductModel> products = [
    ProductModel(
        id: "1",
        name: "Custom",
        sku: " ",
        category: ProductCategory.Custom,
        description: " ",
        images: const [],
        price: 0,
        tags: const [],
        size: " ",
        rawMaterials: const [],
        rawMaterialIds: const [],
        labourCost: 0,
        overhead: 0,
        profit: 0,
        pdfLink: null),
  ];

  int numOfProduct = 1;

  String startDate = '';

  String endDate = "";

  String selectedProductImage = "";

  String deliveryState = DeliveryOption.delivery;

  String selectedCategory = ProductCategory.ShoeShelf;

  String orderState = OrderStatus.Pending;

  final TextEditingController _seferTc = TextEditingController();
  final TextEditingController _custumerNameTc =
      TextEditingController(text: "  ");
  final TextEditingController _phoneNumberTc = TextEditingController();
  final TextEditingController _goLocationTc = TextEditingController();
  final TextEditingController _productSkuTc = TextEditingController();
  final TextEditingController _deliveryPriceTc = TextEditingController();
  final TextEditingController _productNameTc = TextEditingController();
  final TextEditingController _productPriceTc = TextEditingController();
  final TextEditingController _productDescriptionTc = TextEditingController();
  final TextEditingController _payedPriceTc = TextEditingController();
  final TextEditingController _colorTc = TextEditingController();
  final TextEditingController _sizeTc = TextEditingController();
  final TextEditingController _bankAccountTc = TextEditingController();

  TextfieldTagsController<String> tagsController =
      TextfieldTagsController<String>();

  bool isCustomerExist = false;

  ProductModel selectedProduct = ProductModel(
      id: "1",
      name: "Custom",
      sku: " ",
      category: ProductCategory.Custom,
      description: " ",
      images: const [],
      price: 0,
      tags: const [],
      size: " ",
      rawMaterials: const [],
      rawMaterialIds: const [],
      labourCost: 0,
      overhead: 0,
      profit: 0,
      pdfLink: null);

  String selectedGender = Gender.Male;

  String selectedSource = CustomerSource.customer;

  String selectedKK = KK.AddisKetema;

  String selectedPaymentMethod = PaymentMethod.CBE;

  CustomerModel? selectedCustomer;

  List selectedImages = [];

  bool isPickup = false;

  Color productColor = Colors.white;

  GlobalKey<FormState> orderFormKey = GlobalKey<FormState>();

  File? file;

  bool isNewProduct = false;

  bool isNewCustomer = false;

  bool withReciept = false;

  var _distanceToField;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width - 46;
  }

  @override
  void initState() {
    super.initState();

    // mainConntroller.getProducts();
    // mainConntroller.getCustomers();

    products.addAll(mainConntroller.products);
    // mainConntroller.products.map((product) {
    //   products.add(product);
    // });
    startDate = DateTime.now().toString().split(" ")[0];
    endDate = DateTime.now().toString().split(" ")[0];

    mainConntroller.searchCustomers('name', "", 1);

    if (widget.orderModel != null) {
      orderState = widget.orderModel!.status;
      _colorTc.text = widget.orderModel!.color;
      _sizeTc.text = widget.orderModel!.size;
      _custumerNameTc.text = widget.orderModel!.customerName;
      selectedGender = widget.orderModel!.customerGender;
      _phoneNumberTc.text = widget.orderModel!.phoneNumber;
      numOfProduct = widget.orderModel!.quantity;
      _productNameTc.text = widget.orderModel!.productName;
      _deliveryPriceTc.text = widget.orderModel!.deliveryPrice.toString();
      _productPriceTc.text = widget.orderModel!.productPrice.toString();
      _payedPriceTc.text = widget.orderModel!.payedPrice.toString();
      _productSkuTc.text = widget.orderModel!.productSku;
      selectedSource = widget.orderModel!.customerSource;
      startDate = widget.orderModel!.orderedDate;
      endDate = widget.orderModel!.finishedDate;
      deliveryState = widget.orderModel!.deliveryOption;
      _seferTc.text = widget.orderModel!.sefer;
      selectedKK = widget.orderModel!.kk;
      _goLocationTc.text = widget.orderModel!.location;
      selectedPaymentMethod = widget.orderModel!.paymentMethod;
      selectedProductImage = widget.orderModel!.imgUrl;
      _productDescriptionTc.text = widget.orderModel!.productDescription;
      _bankAccountTc.text = widget.orderModel!.bankAccount ?? "";
      withReciept = widget.orderModel!.withReciept;
    }

    if (widget.orderModel != null) {
      setImageFile();
    }
  }

  setImageFile() async {
    if (widget.orderModel!.imgUrl != "") {
      file = await displayImage(
          widget.orderModel!.imgUrl,
          '${widget.orderModel!.productSku}0',
          "${FirebaseConstants.products}/${widget.orderModel!.productSku}");
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _custumerNameTc.dispose();
    _phoneNumberTc.dispose();
    _productPriceTc.dispose();
    _productSkuTc.dispose();
    _seferTc.dispose();
    _goLocationTc.dispose();
    _productDescriptionTc.dispose();
    _productSkuTc.dispose();
    _deliveryPriceTc.dispose();
    _productNameTc.dispose();
    _payedPriceTc.dispose();
    _bankAccountTc.dispose();
    super.dispose();
  }

  customerField() {
    return RawAutocomplete<CustomerModel>(
      initialValue: TextEditingValue(text: _custumerNameTc.text),
      displayStringForOption: (option) {
        return option.name;
      },
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text == '') {
          return const Iterable<CustomerModel>.empty();
        } else if (!isNewCustomer) {
          if (mainConntroller.getCustomersStatus.value !=
              RequestState.loading) {
            await mainConntroller.searchCustomers(
                "name", textEditingValue.text, 5);

            return mainConntroller.customers;
          } else {
            return const Iterable<CustomerModel>.empty();
          }
        } else {
          return const Iterable<CustomerModel>.empty();
        }
      },
      onSelected: (CustomerModel customerModel) {
        _custumerNameTc.text = customerModel.name;
        selectedGender = customerModel.gender;
        selectedKK = customerModel.kk;
        selectedSource = customerModel.source;
        _goLocationTc.text = customerModel.location;
        _seferTc.text = customerModel.sefer;
        _phoneNumberTc.text = customerModel.phone;
        isCustomerExist = true;

        selectedCustomer = customerModel;
        setState(() {});
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return SLInput(
          title: "Customer Name",
          hint: 'Abebe chala',
          inputColor: whiteColor,
          otherColor: textColor,
          keyboardType: TextInputType.text,
          controller: textEditingController,
          isOutlined: true,
          focusNode: focusNode,
          onChanged: (val) {
            _custumerNameTc.text = val;
          },
        );
      },
      optionsViewBuilder: (BuildContext context,
          void Function(CustomerModel) onSelected,
          Iterable<CustomerModel> options) {
        return Material(
          color: backgroundColor,
          child: Obx(() {
            return mainConntroller.getCustomersStatus.value ==
                    RequestState.loading
                ? Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  )
                : SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                      child: Column(
                        children: options.map((opt) {
                          return InkWell(
                            onTap: () {
                              onSelected(opt);
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 23),
                              child: Card(
                                child: Container(
                                  color: mainBgColor,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  child: Text(opt.name),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
          }),
        );
      },
    );
  }

  inputProduct() {
    return SLInput(
      margin: 0,
      title: "Product name",
      hint: 'Door',
      inputColor: whiteColor,
      otherColor: textColor,
      keyboardType: TextInputType.text,
      controller: _productNameTc,
      isOutlined: true,
      onChanged: (val) {
        if (val.isNotEmpty && !isNewProduct) {
          if (mainConntroller.getCustomersStatus.value !=
              RequestState.loading) {
            mainConntroller.searchProducts('name', val, 5);
          }
        }
      },
    );
  }

  productsAndQuantity() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: inputProduct(),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: mainBgColor,
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Text('$numOfProduct'),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              numOfProduct++;
                            });
                          },
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: textColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                if (numOfProduct > 1) {
                                  numOfProduct--;
                                }
                              },
                            );
                          },
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if (!isNewProduct)
          Obx(
            () {
              return mainConntroller.getProductsStatus.value ==
                      RequestState.loading
                  ? SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: primaryColor,
                      )),
                    )
                  : SizedBox(
                      height: 82,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: mainConntroller.products
                              .map((element) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 5),
                                    child: InkWell(
                                      onLongPress: () {
                                        Get.to(
                                          AddProduct(
                                            productModel: element,
                                          ),
                                        );
                                      },
                                      onTap: () {
                                        _productNameTc.text = element.name;
                                        _productPriceTc.text =
                                            element.price.toString();
                                        _productSkuTc.text = element.sku;
                                        selectedProductImage =
                                            element.images[0];

                                        _sizeTc.text = element.size;
                                        _productDescriptionTc.text =
                                            element.description;

                                        setState(() {});
                                      },
                                      child: OrderProductCard(
                                        productModel: element,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    );
            },
          )
      ],
    );
  }

  image(VoidCallback onTap) {
    if (selectedImages.isNotEmpty) {
      return Container(
        height: 200,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 23),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: mainBgColor,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: selectedImages.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: kIsWeb
                            ? Image.memory(
                                selectedImages[index],
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                selectedImages[index],
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                      ));
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBtn(
                  btnState: Btn.outlined,
                  color: textColor,
                  onTap: onTap,
                  text: "Change",
                ),
                Text("${selectedImages.length} Images"),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 100,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 23),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: mainBgColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CustomBtn(
                btnState: Btn.filled,
                color: backgroundColor,
                onTap: onTap,
                text: "Attach img",
              ),
            ),
          ],
        ),
      );
    }
  }

  inputDates() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Start date from",
                  style: TextStyle(color: textColor),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DateTimePicker(
                initialValue: startDate,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  suffix: SvgPicture.asset(
                    'assets/calander icon.svg',
                    height: 30,
                    width: 30,
                    color: textColor,
                  ),
                  fillColor: mainBgColor,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                type: DateTimePickerType.date,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Date',
                dateMask: 'd MMM, yyyy',
                onChanged: (val) {
                  setState(() {
                    startDate = val;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "to",
                  style: TextStyle(color: textColor),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DateTimePicker(
                initialValue: endDate,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  suffix: SvgPicture.asset(
                    'assets/calander icon.svg',
                    height: 30,
                    width: 30,
                    color: textColor,
                  ),
                  fillColor: mainBgColor,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                type: DateTimePickerType.date,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Date',
                dateMask: 'd MMM, yyyy',
                onChanged: (val) {
                  endDate = val;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _openGoogleMaps() async {
    const url = 'https://maps.google.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

//  Future<void> _handleReturnedUrl() async {
//   final url = await getInitkjhialUrl();
//   // Parse the URL to extract the location data
//   // ...
// }

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
              textfieldTagsController: tagsController,
              textSeparators: const [','],
              letterCase: LetterCase.normal,
              validator: (String tag) {
                if (tagsController.getTags!.contains(tag)) {
                  return 'you already entered that';
                }

                return null;
              },
              inputFieldBuilder: (context, textFieldTagValues) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: textFieldTagValues.textEditingController,
                      focusNode: textFieldTagValues.focusNode,
                      validator: (value) {
                        if (tagsController.getTags?.isNotEmpty == true) {
                          return "This Feild is required";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        fillColor: mainBgColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: textFieldTagValues.tags.isNotEmpty == true
                            ? "Enter tag..."
                            : "",
                        hintStyle: TextStyle(color: textColor),
                        errorText: textFieldTagValues.error,
                        prefixIconConstraints:
                            BoxConstraints(maxWidth: _distanceToField * 0.60),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              tagsController.clearTags();
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
                                  children: textFieldTagValues.tags.map((String tag) {
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
                                              textFieldTagValues.onTagDelete(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : null,
                      ),
                      onChanged: textFieldTagValues.onChanged,
                      // onSubmitted: onSubmitted,
                    ),
                  ))
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
        title: title(widget.orderModel != null
            ? "Order #${widget.orderModel!.id}"
            : "New Order"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          if (widget.orderModel != null)
            IconButton(
              onPressed: () {
                Get.dialog(
                  OrderDialog(
                    orderModel: widget.orderModel!,
                  ),
                  barrierColor: const Color.fromARGB(200, 0, 0, 0),
                );
              },
              icon: const Icon(Icons.qr_code),
            ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: orderFormKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                file != null
                    ? file!.path != ""
                        ? Image.file(
                            file!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : kIsWeb
                            ? CachedNetworkImage(
                                imageUrl: widget.orderModel!.imgUrl,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : const SizedBox()
                    : const SizedBox(),
                const SizedBox(
                  height: 20,
                ),
                SpecialDropdown<String>(
                  title: "Status",
                  value: orderState,
                  width: double.infinity,
                  list: OrderStatus.list,
                  onChange: (v) {
                    setState(() {
                      orderState = v;
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CheckboxListTile(
                  value: isNewCustomer,
                  title: const Text("New Customer"),
                  activeColor: primaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 23),
                  onChanged: (val) {
                    setState(() {
                      isNewCustomer = val!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(
                  height: 15,
                ),
                customerField(),
                if (isNewCustomer)
                  const SizedBox(
                    height: 15,
                  ),
                if (isNewCustomer)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      Gender.list.length,
                      (index) => Row(
                        children: [
                          Radio(
                            activeColor: whiteColor,
                            value: Gender.list[index],
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                          ),
                          Text(Gender.list[index])
                        ],
                      ),
                    ),
                  ),
                if (isNewCustomer)
                  const SizedBox(
                    height: 15,
                  ),
                if (isNewCustomer)
                  SLInput(
                    title: "Phone number",
                    hint: '092345656',
                    inputColor: whiteColor,
                    otherColor: textColor,
                    keyboardType: TextInputType.text,
                    controller: _phoneNumberTc,
                    isOutlined: true,
                  ),
                const SizedBox(
                  height: 15,
                ),
                CheckboxListTile(
                  value: isNewProduct,
                  title: const Text("New Product"),
                  activeColor: primaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 23),
                  onChanged: (val) {
                    setState(() {
                      isNewProduct = val!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                if (isNewProduct)
                  image(
                    () async {
                      if (kIsWeb) {
                        // TODO: free up every thing to load web

                        // List<Uint8List>? xFiles =
                        //     await ImagePickerWeb.getMultiImagesAsBytes();
                        // selectedImages = [];
                        // if (xFiles?.isNotEmpty ?? false) {
                        //   for (var xFile in xFiles!) {
                        //     selectedImages.add(xFile);
                        //     setState(() {});
                        //   }
                        // } else {
                        //   setState(() {});
                        //   toast("No image is selected.", ToastType.error);
                        // }
                      } else {
                        List<XFile> xFiles = await ImagePicker()
                            .pickMultiImage(imageQuality: 10);
                        selectedImages = [];
                        if (xFiles.isNotEmpty) {
                          for (XFile xFile in xFiles) {
                            selectedImages.add(File(xFile.path));
                            setState(() {});
                          }
                        } else {
                          setState(() {});
                          toast("No image is selected.", ToastType.error);
                        }
                      }
                    },
                  ),
                if (isNewProduct)
                  const SizedBox(
                    height: 15,
                  ),
                productsAndQuantity(),
                if (isNewProduct)
                  const SizedBox(
                    height: 15,
                  ),
                if (isNewProduct)
                  SLInput(
                    title: "Product sku",
                    hint: '5678',
                    inputColor: whiteColor,
                    otherColor: textColor,
                    keyboardType: TextInputType.text,
                    controller: _productSkuTc,
                    isOutlined: true,
                  ),
                if (isNewProduct)
                  const SizedBox(
                    height: 15,
                  ),
                if (isNewProduct)
                  SpecialDropdown<String>(
                    title: "Product Category",
                    value: selectedCategory,
                    width: double.infinity,
                    list: ProductCategory.list,
                    onChange: (v) {
                      setState(() {
                        selectedCategory = v;
                      });
                    },
                  ),
                const SizedBox(
                  height: 15,
                ),
                SLInput(
                  title: "Color",
                  hint: 'white',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.text,
                  controller: _colorTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                SLInput(
                  title: "Size",
                  hint: '23 cm * 100 cm * 10',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.text,
                  controller: _sizeTc,
                  isOutlined: true,
                ),
                if (isNewProduct)
                  const SizedBox(
                    height: 15,
                  ),
                if (isNewProduct)
                  SLInput(
                    title: "Product Descrpition",
                    hint: 'Description',
                    inputColor: whiteColor,
                    otherColor: textColor,
                    keyboardType: TextInputType.multiline,
                    controller: _productDescriptionTc,
                    isOutlined: true,
                  ),
                const SizedBox(
                  height: 15,
                ),
                SpecialDropdown<String>(
                  value: selectedSource,
                  list: CustomerSource.list,
                  title: "Source",
                  width: double.infinity,
                  onChange: (value) {
                    setState(() {
                      selectedSource = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    DeliveryOption.list.length,
                    (index) {
                      return SizedBox(
                        width: 160,
                        child: RadioListTile(
                          activeColor: whiteColor,
                          title: Text(DeliveryOption.list[index]),
                          value: DeliveryOption.list[index],
                          groupValue: deliveryState,
                          onChanged: (val) {
                            setState(() {
                              if (val == DeliveryOption.pickUp) {
                                isPickup = true;
                                _seferTc.text = " ";
                                _goLocationTc.text = " ";
                              } else {
                                isPickup = false;
                              }
                              deliveryState = val.toString();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                inputDates(),
                if (isNewCustomer)
                  const SizedBox(
                    height: 15,
                  ),
                if (isNewCustomer)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isPickup ? 0 : 23),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!isPickup)
                          SLInput(
                            width: 100,
                            title: "Sefer",
                            hint: 'Arabsa',
                            inputColor: whiteColor,
                            otherColor: textColor,
                            keyboardType: TextInputType.text,
                            controller: _seferTc,
                            isOutlined: true,
                            margin: 0,
                          ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: SpecialDropdown<String>(
                            value: selectedKK,
                            margin: isPickup ? null : 0,
                            list: KK.list,
                            title: "Kifle Ketema",
                            width: double.infinity,
                            onChange: (value) {
                              setState(() {
                                selectedKK = value!;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                if (!isPickup && isNewCustomer)
                  SLInput(
                    title: "",
                    hint: 'Google location',
                    inputColor: whiteColor,
                    otherColor: textColor,
                    keyboardType: TextInputType.text,
                    controller: _goLocationTc,
                    isOutlined: true,
                  ),
                if (!isPickup && isNewCustomer)
                  const SizedBox(
                    height: 15,
                  ),
                if (!isPickup && isNewCustomer)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 23,
                      ),
                      child: InkWell(
                        onTap: () async {
                          await _openGoogleMaps();
                          // await _retrieveSelectedLocation();
                        },
                        child: Ink(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: greyColor,
                              ),
                              Text(
                                "Pick Location",
                                style: TextStyle(color: textColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 15,
                ),
                SLInput(
                  title: "Product price",
                  hint: '10000',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.number,
                  controller: _productPriceTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                if (isNewProduct) inputtags(),
                if (isNewProduct)
                  const SizedBox(
                    height: 8,
                  ),
                SLInput(
                  title: "Delivery price",
                  hint: '10000',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.number,
                  controller: _deliveryPriceTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                SLInput(
                  title: "PrePayment",
                  hint: '10000',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.number,
                  controller: _payedPriceTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                SpecialDropdown<String>(
                  value: selectedPaymentMethod,
                  list: PaymentMethod.list,
                  title: "Payment method",
                  width: double.infinity,
                  onChange: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                  ),
                  child: CheckboxListTile(
                    title: const Text("with Reciept"),
                    value: withReciept,
                    onChanged: (v) {
                      setState(() {
                        withReciept = v!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                !withReciept
                    ? SLInput(
                        validation: (val) {
                          return null;
                        },
                        title: "Bank Account (optional)",
                        hint: '1000033426548',
                        inputColor: whiteColor,
                        otherColor: textColor,
                        keyboardType: TextInputType.number,
                        controller: _bankAccountTc,
                        isOutlined: true,
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 40,
                ),
                Obx(
                  () {
                    return mainConntroller.orderStatus.value ==
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
                                tColor: mainBgColor,
                                text: 'Save',
                                onTap: () async {
                                  String? cid = selectedCustomer?.id;

                                  if (orderFormKey.currentState!.validate()) {
                                    if (widget.orderModel == null) {
                                      if (isNewCustomer) {
                                        cid = await mainConntroller.addCustomer(
                                          CustomerModel(
                                            source: selectedSource,
                                            gender: selectedGender,
                                            name: _custumerNameTc.text,
                                            id: null,
                                            phone: _phoneNumberTc.text,
                                            sefer: _seferTc.text,
                                            kk: selectedKK,
                                            location: _goLocationTc.text,
                                            date: DateTime.now()
                                                .toString()
                                                .split(" ")[0],
                                          ),
                                        );
                                      }
                                      if (isNewProduct) {
                                        if (selectedImages.isNotEmpty) {
                                          await mainConntroller.addProduct(
                                            ProductModel(
                                              id: null,
                                              pdfLink:
                                                  null, // but it is not implemented
                                              name: _productNameTc.text,
                                              sku: _productSkuTc.text,
                                              category: selectedCategory,
                                              description:
                                                  _productDescriptionTc.text,
                                              images: const [],
                                              price: double.parse(
                                                  _productPriceTc.text),
                                              tags: tagsController.getTags!,
                                              size: _sizeTc.text,
                                              rawMaterials: const [],
                                              rawMaterialIds: const [],
                                              labourCost: 0,
                                              overhead: 0,
                                              profit: 0,
                                            ),
                                            selectedImages,
                                            null, // TODO: not emplement yet
                                          );
                                        } else {
                                          toast("images are not selected",
                                              ToastType.error);
                                        }
                                      }
                                      await mainConntroller.addOrder(
                                        OrderModel(
                                          id: null,
                                          withReciept: withReciept,
                                          bankAccount:
                                              _bankAccountTc.text.isEmpty
                                                  ? null
                                                  : _bankAccountTc.text,
                                          customerId: cid,
                                          customerName: _custumerNameTc.text,
                                          phoneNumber: _phoneNumberTc.text,
                                          productName: _productNameTc.text,
                                          color: _colorTc.text,
                                          size: _sizeTc.text,
                                          productPrice: double.parse(
                                              _productPriceTc.text),
                                          payedPrice:
                                              double.parse(_payedPriceTc.text),
                                          deliveryPrice: double.parse(
                                              _deliveryPriceTc.text),
                                          productSku: _productSkuTc.text,
                                          quantity: numOfProduct,
                                          orderedDate: startDate,
                                          finishedDate: endDate,
                                          status: orderState,
                                          sefer: _seferTc.text,
                                          customerSource: selectedSource,
                                          kk: selectedKK,
                                          location: _payedPriceTc.text,
                                          paymentMethod: selectedPaymentMethod,
                                          deliveryOption: deliveryState,
                                          customerGender: selectedGender,
                                          imgUrl: selectedProductImage,
                                          productDescription:
                                              _productDescriptionTc.text,
                                          employees: const [],
                                          itemsUsed: const [],
                                        ),
                                      );
                                    } else {
                                      await mainConntroller.updateOrder(
                                        OrderModel(
                                          id: widget.orderModel!.id,
                                          withReciept: withReciept,
                                          bankAccount:
                                              _bankAccountTc.text.isEmpty
                                                  ? null
                                                  : _bankAccountTc.text,
                                          customerId:
                                              widget.orderModel!.customerId,
                                          deliveryPrice: double.parse(
                                              _deliveryPriceTc.text),
                                          customerName: _custumerNameTc.text,
                                          phoneNumber: _phoneNumberTc.text,
                                          productName: _productNameTc.text,
                                          color: _colorTc.text,
                                          size: _sizeTc.text,
                                          productPrice: double.parse(
                                              _productPriceTc.text),
                                          payedPrice:
                                              double.parse(_payedPriceTc.text),
                                          productSku: _productSkuTc.text,
                                          quantity: numOfProduct,
                                          orderedDate: startDate,
                                          finishedDate: endDate,
                                          status: orderState,
                                          sefer: _seferTc.text,
                                          customerSource: selectedSource,
                                          kk: selectedKK,
                                          location: _goLocationTc.text,
                                          paymentMethod: selectedPaymentMethod,
                                          deliveryOption: deliveryState,
                                          customerGender: selectedGender,
                                          imgUrl: selectedProductImage,
                                          productDescription:
                                              _productDescriptionTc.text,
                                          employees:
                                              widget.orderModel!.employees,
                                          itemsUsed:
                                              widget.orderModel!.itemsUsed,
                                        ),
                                        widget.orderModel!.status,
                                      );
                                    }
                                  }
                                },
                              ),
                              widget.orderModel != null
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
                                              if (widget.orderModel != null) {
                                                mainConntroller.delete(
                                                    FirebaseConstants.orders,
                                                    widget.orderModel!.id!,
                                                    widget.orderModel!
                                                        .productName,
                                                    false,
                                                    []);
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
