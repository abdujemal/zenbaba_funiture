import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../data/model/cutomer_model.dart';
import '../../data/model/order_model.dart';
import '../../data/model/product_model.dart';
import '../controller/main_controller.dart';
import '../widget/custom_btn.dart';
import '../widget/my_dropdown.dart';
import '../widget/order_dialog.dart';
import '../widget/order_product_card.dart';
import '../widget/sl_input.dart';

class AddOrder extends StatefulWidget {
  final OrderModel? orderModel;
  const AddOrder({super.key, this.orderModel});

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  var custumerNameTc = TextEditingController(text: "  ");

  var phoneNumberTc = TextEditingController();

  MainConntroller mainConntroller = Get.find<MainConntroller>();

  List<ProductModel> products = [
    ProductModel(
        id: "1",
        name: "Custom",
        sku: " ",
        category: ProductCategory.Custom,
        description: " ",
        images: [],
        price: 0,
        tags: []),
  ];

  int numOfProduct = 1;

  String startDate = '';

  String endDate = "";

  String selectedProductImage = "";

  String deliveryState = DeliveryOption.delivery;

  var seferTc = TextEditingController();

  var goLocationTc = TextEditingController();

  var productSkuTc = TextEditingController();

  var productNameTc = TextEditingController();

  var productPriceTc = TextEditingController();

  var selectedProduct = ProductModel(
      tags: [],
      id: "1",
      name: "Custom",
      sku: " ",
      category: ProductCategory.Custom,
      description: " ",
      images: [],
      price: 0);

  var selectedGender = Gender.Male;

  var selectedSource = CustomerSource.customer;

  var selectedKK = KK.AddisKetema;

  var selectedPaymentMethod = PaymentMethod.CBE;

  var orderState = OrderStatus.Pending;

  bool isCustomerExist = false;

  bool isPickup = false;

  var orderFormKey = GlobalKey<FormState>();

  var productDescriptionTc = TextEditingController();

  File? file;

  TextEditingController payedPriceTc = TextEditingController();

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
      custumerNameTc.text = widget.orderModel!.customerName;
      selectedGender = widget.orderModel!.customerGender;
      phoneNumberTc.text = widget.orderModel!.phoneNumber;
      numOfProduct = widget.orderModel!.quantity;
      productNameTc.text = widget.orderModel!.productName;
      productPriceTc.text = widget.orderModel!.productPrice.toString();
      payedPriceTc.text = widget.orderModel!.payedPrice.toString();
      productSkuTc.text = widget.orderModel!.productSku;
      selectedSource = widget.orderModel!.customerSource;
      startDate = widget.orderModel!.orderedDate;
      endDate = widget.orderModel!.finishedDate;
      deliveryState = widget.orderModel!.deliveryOption;
      seferTc.text = widget.orderModel!.sefer;
      selectedKK = widget.orderModel!.kk;
      goLocationTc.text = widget.orderModel!.location;
      selectedPaymentMethod = widget.orderModel!.paymentMethod;
      selectedProductImage = widget.orderModel!.imgUrl;
      productDescriptionTc.text = widget.orderModel!.productDescription;
    }

    if (widget.orderModel != null) {
      setImageFile();
    }
  }

  setImageFile() async {
    if (widget.orderModel!.imgUrl != "") {
      file = await displayImage(widget.orderModel!.imgUrl,
          '${widget.orderModel!.productSku}0', FirebaseConstants.products);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    custumerNameTc.dispose();
    phoneNumberTc.dispose();
    productPriceTc.dispose();
    productSkuTc.dispose();
    seferTc.dispose();
    goLocationTc.dispose();
    productDescriptionTc.dispose();
    super.dispose();
  }

  customerField() {
    return RawAutocomplete<CustomerModel>(
      initialValue: TextEditingValue(text: custumerNameTc.text),
      displayStringForOption: (option) {
        return option.name;
      },
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text == '') {
          return const Iterable<CustomerModel>.empty();
        } else {
          if (mainConntroller.getCustomersStatus.value !=
              RequestState.loading) {
            await mainConntroller.searchCustomers(
                "name", textEditingValue.text, 5);

            return mainConntroller.customers;
          } else {
            return const Iterable<CustomerModel>.empty();
          }
        }
      },
      onSelected: (CustomerModel customerModel) {
        custumerNameTc.text = customerModel.name;
        selectedGender = customerModel.gender;
        selectedKK = customerModel.kk;
        selectedSource = customerModel.source;
        goLocationTc.text = customerModel.location;
        seferTc.text = customerModel.sefer;
        phoneNumberTc.text = customerModel.phone;
        isCustomerExist = true;
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
            custumerNameTc.text = val;
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
                              padding: EdgeInsets.symmetric(horizontal: 23),
                              child: Card(
                                child: Container(
                                  color: mainBgColor,
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
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
      controller: productNameTc,
      isOutlined: true,
      onChanged: (val) {
        if (val.isNotEmpty) {
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: textColor, width: 1),
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
                                    onTap: () {
                                      productNameTc.text = element.name;
                                      productPriceTc.text =
                                          element.price.toString();
                                      productSkuTc.text = element.sku;
                                      selectedProductImage = element.images[0];
                                      payedPriceTc.text = '0';
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
                  suffix: const Icon(Icons.event),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: whiteColor),
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
                  suffix: const Icon(Icons.event),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: whiteColor),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title:
              title(widget.orderModel != null ? "Order Detail" : "New Order"),
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
                      barrierColor: const Color.fromARGB(200, 0, 0, 0));
                },
                icon: const Icon(Icons.qr_code),
              ),
          ]),
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
                        : const SizedBox()
                    : const SizedBox(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    OrderStatus.list.length,
                    (index) {
                      return SizedBox(
                        width: 160,
                        child: RadioListTile(
                          activeColor: whiteColor,
                          title: Text(OrderStatus.list[index]),
                          value: OrderStatus.list[index],
                          groupValue: orderState,
                          onChanged: (val) {
                            setState(() {
                              orderState = val.toString();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                customerField(),
                const SizedBox(
                  height: 15,
                ),
                MyDropdown(
                  value: selectedGender,
                  list: Gender.list,
                  title: "Gender",
                  width: double.infinity,
                  onChange: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                SLInput(
                  title: "Phone number",
                  hint: '092345656',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.text,
                  controller: phoneNumberTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                productsAndQuantity(),
                const SizedBox(
                  height: 15,
                ),
                SLInput(
                  title: "Product Descrpition",
                  hint: 'Description',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.multiline,
                  controller: productDescriptionTc,
                  isOutlined: true,
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
                  controller: productPriceTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                SLInput(
                  title: "Advance Payment",
                  hint: '10000',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.number,
                  controller: payedPriceTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                SLInput(
                  title: "Product sku",
                  hint: '5678',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.text,
                  controller: productSkuTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                MyDropdown(
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
                inputDates(),
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
                                seferTc.text = " ";
                                goLocationTc.text = " ";
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
                const SizedBox(
                  height: 15,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isPickup ? 0 : 23),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isPickup)
                        SLInput(
                          width: 100,
                          title: "Sefer",
                          hint: 'Arabsa',
                          inputColor: whiteColor,
                          otherColor: textColor,
                          keyboardType: TextInputType.text,
                          controller: seferTc,
                          isOutlined: true,
                          margin: 10,
                        ),
                      Expanded(
                        child: MyDropdown(
                          value: selectedKK,
                          margin: isPickup ? null : 10,
                          list: KK.list,
                          title: "Kifle Ketema",
                          width: isPickup ? double.infinity : 200,
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
                if (!isPickup)
                  SLInput(
                    title: "",
                    hint: 'Google location',
                    inputColor: whiteColor,
                    otherColor: textColor,
                    keyboardType: TextInputType.text,
                    controller: goLocationTc,
                    isOutlined: true,
                  ),
                const SizedBox(
                  height: 15,
                ),
                MyDropdown(
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
                  height: 40,
                ),
                // mainConntroller.orderStatus.value == RequestState.loading
                //     ? CircularProgressIndicator(
                //         color: primaryColor,
                //       )
                //     : const SizedBox(),
                const SizedBox(
                  height: 15,
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
                                text: 'Save',
                                onTap: () async {
                                  if (orderFormKey.currentState!.validate()) {
                                    if (widget.orderModel == null) {
                                      if (!isCustomerExist) {
                                        await mainConntroller.addCustomer(
                                          CustomerModel(
                                            source: selectedSource,
                                            gender: selectedGender,
                                            name: custumerNameTc.text,
                                            id: null,
                                            phone: phoneNumberTc.text,
                                            sefer: seferTc.text,
                                            kk: selectedKK,
                                            location: goLocationTc.text,
                                          ),
                                        );
                                      }
                                      await mainConntroller.addOrder(
                                        OrderModel(
                                            id: null,
                                            customerName: custumerNameTc.text,
                                            phoneNumber: phoneNumberTc.text,
                                            productName: productNameTc.text,
                                            productPrice: double.parse(
                                                productPriceTc.text),
                                            payedPrice:
                                                double.parse(payedPriceTc.text),
                                            productSku: productSkuTc.text,
                                            quantity: numOfProduct,
                                            orderedDate: startDate,
                                            finishedDate: endDate,
                                            status: orderState,
                                            sefer: seferTc.text,
                                            customerSource: selectedSource,
                                            kk: selectedKK,
                                            location: goLocationTc.text,
                                            paymentMethod:
                                                selectedPaymentMethod,
                                            deliveryOption: deliveryState,
                                            customerGender: selectedGender,
                                            imgUrl: selectedProductImage,
                                            productDescription:
                                                productDescriptionTc.text),
                                      );
                                    } else {
                                      await mainConntroller.updateOrder(
                                          OrderModel(
                                            id: widget.orderModel!.id,
                                            customerName: custumerNameTc.text,
                                            phoneNumber: phoneNumberTc.text,
                                            productName: productNameTc.text,
                                            productPrice: double.parse(
                                                productPriceTc.text),
                                            payedPrice:
                                                double.parse(payedPriceTc.text),
                                            productSku: productSkuTc.text,
                                            quantity: numOfProduct,
                                            orderedDate: startDate,
                                            finishedDate: endDate,
                                            status: orderState,
                                            sefer: seferTc.text,
                                            customerSource: selectedSource,
                                            kk: selectedKK,
                                            location: goLocationTc.text,
                                            paymentMethod:
                                                selectedPaymentMethod,
                                            deliveryOption: deliveryState,
                                            customerGender: selectedGender,
                                            imgUrl: selectedProductImage,
                                            productDescription:
                                                productDescriptionTc.text,
                                          ),
                                          widget.orderModel!.status);
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
                                                    null);
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
