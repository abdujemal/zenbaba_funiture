import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../data/model/cutomer_model.dart';
import '../controller/main_controller.dart';
import '../widget/custom_btn.dart';
import '../widget/my_dropdown.dart';
import '../widget/sl_input.dart';

class AddCutomer extends StatefulWidget {
  final CustomerModel? customerModel;
  const AddCutomer({super.key, this.customerModel});

  @override
  State<AddCutomer> createState() => _AddCutomerState();
}

class _AddCutomerState extends State<AddCutomer> {
  var nameTc = TextEditingController();

  String selectedGender = Gender.Male;

  var phoneTc = TextEditingController();

  var seferTc = TextEditingController();

  var selectedKK = KK.KolfeKeranyo;

  var locationTc = TextEditingController();

  var customerForm = GlobalKey<FormState>();

  MainConntroller mainConntroller = Get.find<MainConntroller>();

  var selectedSource = CustomerSource.faceBook;

  @override
  void dispose() {
    nameTc.dispose();
    phoneTc.dispose();
    seferTc.dispose();
    locationTc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.customerModel != null) {
      nameTc.text = widget.customerModel!.name;
      selectedGender = widget.customerModel!.gender;
      phoneTc.text = widget.customerModel!.phone;
      seferTc.text = widget.customerModel!.sefer;
      selectedKK = widget.customerModel!.kk;
      locationTc.text = widget.customerModel!.location;
      selectedSource = widget.customerModel!.source;
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
        title: title(
            widget.customerModel == null ? "New Customer" : "Customer Detail"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: customerForm,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SLInput(
                title: "Name",
                hint: 'Abebe',
                inputColor: whiteColor,
                otherColor: textColor,
                keyboardType: TextInputType.text,
                controller: nameTc,
                isOutlined: true,
              ),
              const SizedBox(
                height: 15,
              ),
              MyDropdown(
                value: selectedGender,
                width: double.infinity,
                list: Gender.list,
                title: "Gender",
                onChange: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              MyDropdown(
                value: selectedSource,
                width: double.infinity,
                list: CustomerSource.list,
                title: "Customer Source",
                onChange: (value) {
                  setState(() {
                    selectedSource = value!;
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              SLInput(
                title: "Phone",
                hint: '0912356789',
                inputColor: whiteColor,
                otherColor: textColor,
                keyboardType: TextInputType.phone,
                controller: phoneTc,
                isOutlined: true,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    MyDropdown(
                      value: selectedKK,
                      margin: 10,
                      list: KK.list,
                      title: "Kifle Ketema",
                      width: 200,
                      onChange: (value) {
                        setState(() {
                          selectedKK = value!;
                        });
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SLInput(
                title: "Location",
                hint: 'description',
                inputColor: whiteColor,
                otherColor: textColor,
                keyboardType: TextInputType.text,
                controller: locationTc,
                isOutlined: true,
              ),
              const SizedBox(
                height: 25,
              ),
              Obx(() {
                if (mainConntroller.customerStatus.value ==
                    RequestState.loading) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                  ));
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomBtn(
                      btnState: Btn.filled,
                      text: "Save",
                      color: primaryColor,
                      onTap: () {
                        if (customerForm.currentState!.validate()) {
                          if (widget.customerModel != null) {
                            mainConntroller.updateCustomer(
                              CustomerModel(
                                gender: selectedGender,
                                name: nameTc.text,
                                id: widget.customerModel!.id,
                                phone: phoneTc.text,
                                sefer: seferTc.text,
                                kk: selectedKK,
                                location: locationTc.text,
                                source: selectedSource,
                              ),
                            );
                          } else {
                            mainConntroller.addCustomer(
                              CustomerModel(
                                gender: selectedGender,
                                name: nameTc.text,
                                id: null,
                                phone: phoneTc.text,
                                sefer: seferTc.text,
                                kk: selectedKK,
                                location: locationTc.text,
                                source: selectedSource,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    widget.customerModel == null
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
                                text: "Delete",
                                color: textColor,
                                onTap: () {
                                  mainConntroller.delete(
                                      FirebaseConstants.customers,
                                      widget.customerModel!.id!,
                                      widget.customerModel!.name,
                                      false,
                                      null);
                                },
                              ),
                            ],
                          ),
                  ],
                );
              }),
              const SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}
