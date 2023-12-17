import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:zenbaba_funiture/data/model/employee_model.dart';
import 'package:zenbaba_funiture/view/controller/main_controller.dart';
import 'package:zenbaba_funiture/view/widget/custom_btn.dart';
import 'package:zenbaba_funiture/view/widget/sl_input.dart';
import 'package:zenbaba_funiture/view/widget/special_dropdown.dart';

import '../../constants.dart';

class AddEmployeePage extends StatefulWidget {
  final EmployeeModel? employeeModel;
  const AddEmployeePage({super.key, this.employeeModel});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  TextEditingController nameTc = TextEditingController();
  TextEditingController ageTc = TextEditingController();
  TextEditingController phoneTc = TextEditingController();
  TextEditingController paymentTc = TextEditingController();
  TextEditingController locationTc = TextEditingController();

  String selectedType = EmployeeType.fullTime;
  String selectedSalaryType = SalaryType.monthly;

  String selectedPosition = EmployeePosition.woodWorker;

  GlobalKey<FormState> addEmployeeState = GlobalKey<FormState>();

  MainConntroller mainConntroller = Get.find<MainConntroller>();

  var selectedFile;

  String? imageUrl;

  String startDate = DateTime.now().toString();

  @override
  void dispose() {
    super.dispose();
    nameTc.dispose();
    ageTc.dispose();
    phoneTc.dispose();
    paymentTc.dispose();
    locationTc.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.employeeModel != null) {
      imageUrl = widget.employeeModel!.imgUrl;

      nameTc.text = widget.employeeModel!.name;
      ageTc.text = widget.employeeModel!.age;
      phoneTc.text = widget.employeeModel!.phoneNo;
      paymentTc.text = widget.employeeModel!.payment;
      locationTc.text = widget.employeeModel!.location;
      startDate = widget.employeeModel!.startFromDate;
      selectedType = widget.employeeModel!.type;
      selectedPosition = widget.employeeModel!.position;
      selectedSalaryType = widget.employeeModel!.salaryType;
    }
  }

  inputDate() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "Started Working from",
              style: TextStyle(color: textColor),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          DateTimePicker(
            initialValue: startDate,
            validator: (value) {
              if (value!.isEmpty) {
                return "This Feild is required.";
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              suffix: const Icon(Icons.calendar_month),
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
            // readOnly: widget.employeeModel != null,
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
            widget.employeeModel != null ? "Update employee" : "New employee"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: addEmployeeState,
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  selectedFile = null;
                  if (kIsWeb) {
                    final filex = await ImagePickerWeb.getImageAsBytes();
                    if (filex != null) {
                      setState(() {
                        selectedFile = filex;
                      });
                    } else {
                      toast("Image is not picked", ToastType.error);
                    }
                  } else {
                    final filex = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 25,
                    );
                    if (filex != null) {
                      setState(() {
                        selectedFile = File(filex.path);
                      });
                    } else {
                      toast("Image is not picked", ToastType.error);
                    }
                  }
                },
                child: selectedFile == null
                    ? imageUrl != null
                        ? FutureBuilder(
                            future: displayImage(
                              imageUrl!,
                              widget.employeeModel!.id!,
                              FirebaseConstants.employees,
                            ),
                            builder: (context, ds) {
                              return ds.data != null
                                  ? Image.file(
                                      ds.data!,
                                      width: 120,
                                      height: 120,
                                    )
                                  : kIsWeb
                                      ? CachedNetworkImage(
                                          imageUrl: imageUrl!,
                                          width: 120,
                                          height: 120,
                                        )
                                      : CircularProgressIndicator(
                                          color: primaryColor,
                                        );
                            },
                          )
                        : Ink(
                            child: Icon(
                              Icons.account_circle,
                              size: 120,
                              color: textColor,
                            ),
                          )
                    : kIsWeb
                        ? Image.memory(
                            selectedFile,
                            width: 120,
                            height: 120,
                          )
                        : Image.file(
                            selectedFile!,
                            width: 120,
                            height: 120,
                          ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: Row(
                  children: [
                    Expanded(
                      child: SLInput(
                        margin: 0,
                        title: "Name",
                        hint: "Seid Ahmed",
                        isOutlined: true,
                        keyboardType: TextInputType.text,
                        controller: nameTc,
                        inputColor: Colors.white,
                        otherColor: textColor,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SLInput(
                      margin: 0,
                      width: 100,
                      title: "Age",
                      hint: "",
                      isOutlined: true,
                      keyboardType: TextInputType.number,
                      controller: ageTc,
                      inputColor: Colors.white,
                      otherColor: textColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SLInput(
                title: "Phone",
                hint: "0911121314",
                isOutlined: true,
                keyboardType: TextInputType.phone,
                controller: phoneTc,
                inputColor: Colors.white,
                otherColor: textColor,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),
                child: Row(
                  children: List.generate(
                    EmployeeType.list.length,
                    (index) => Row(
                      children: [
                        Radio(
                          value: EmployeeType.list[index],
                          groupValue: selectedType,
                          activeColor: textColor,
                          hoverColor: textColor,
                          toggleable: true,
                          autofocus: true,
                          onChanged: (v) {
                            setState(() {
                              selectedType = v.toString();
                            });
                          },
                        ),
                        Text(
                          EmployeeType.list[index],
                          style: TextStyle(
                            color: textColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SpecialDropdown(
                title: 'position',
                value: selectedPosition,
                width: double.infinity,
                list: EmployeePosition.list,
                onChange: (v) {
                  setState(() {
                    selectedPosition = v;
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              if (selectedType != EmployeeType.contract)
                SLInput(
                  title: "Payment",
                  hint: "3000 br",
                  isOutlined: true,
                  keyboardType: TextInputType.text,
                  controller: paymentTc,
                  inputColor: Colors.white,
                  otherColor: textColor,
                ),
              if (selectedType == EmployeeType.fullTime)
                const SizedBox(
                  height: 15,
                ),
              if (selectedType == EmployeeType.fullTime)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  child: Row(
                    children: List.generate(
                      EmployeeType.list.length,
                      (index) => Row(
                        children: [
                          Radio(
                            value: SalaryType.list[index],
                            groupValue: selectedSalaryType,
                            activeColor: textColor,
                            hoverColor: textColor,
                            toggleable: true,
                            autofocus: true,
                            onChanged: (v) {
                              setState(() {
                                selectedSalaryType = v.toString();
                              });
                            },
                          ),
                          Text(
                            SalaryType.list[index],
                            style: TextStyle(
                              color: textColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              SLInput(
                title: "Location",
                hint: "grar",
                isOutlined: true,
                keyboardType: TextInputType.text,
                controller: locationTc,
                inputColor: Colors.white,
                otherColor: textColor,
              ),
              const SizedBox(
                height: 15,
              ),
              inputDate(),
              const SizedBox(
                height: 35,
              ),
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: mainConntroller.employeeStatus.value.isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomBtn(
                                btnState: Btn.filled,
                                color: primaryColor,
                                onTap: () {
                                  if (paymentTc.text.isEmpty &&
                                      selectedType == EmployeeType.contract) {
                                    paymentTc.text = " ";
                                  }
                                  if (addEmployeeState.currentState!
                                      .validate()) {
                                    if (widget.employeeModel == null) {
                                      // if (selectedFile != null) {
                                      mainConntroller.addUpdateEmployee(
                                        EmployeeModel(
                                          id: null,
                                          imgUrl: null,
                                          name: nameTc.text,
                                          phoneNo: phoneTc.text,
                                          age: ageTc.text,
                                          location: locationTc.text,
                                          position: selectedPosition,
                                          type: selectedType,
                                          payment: paymentTc.text,
                                          salaryType: selectedSalaryType,
                                          startFromDate: startDate,
                                        ),
                                        selectedFile,
                                      );
                                      // } else {
                                      //   toast("Image is not selected.",
                                      //       ToastType.error);
                                      // }
                                    } else {
                                      mainConntroller.addUpdateEmployee(
                                        widget.employeeModel!.copyWith(
                                          name: nameTc.text,
                                          phoneNo: phoneTc.text,
                                          age: ageTc.text,
                                          location: locationTc.text,
                                          position: selectedPosition,
                                          type: selectedType,
                                          payment: paymentTc.text,
                                          salaryType: selectedSalaryType,
                                          startFromDate: startDate,
                                        ),
                                        selectedFile,
                                        isUpdate: true,
                                      );
                                    }
                                  }
                                },
                                tColor: backgroundColor,
                                text: "Save",
                              ),
                            ),
                            if (widget.employeeModel != null)
                              const SizedBox(
                                width: 30,
                              ),
                            if (widget.employeeModel != null)
                              Expanded(
                                child: CustomBtn(
                                  btnState: Btn.filled,
                                  color: Colors.red,
                                  tColor: Colors.white,
                                  onTap: () {
                                    mainConntroller.delete(
                                      FirebaseConstants.employees,
                                      widget.employeeModel!.id!,
                                      widget.employeeModel!.id!,
                                      true,
                                      [widget.employeeModel!.imgUrl!],
                                    );
                                  },
                                  text: "Delete",
                                ),
                              )
                          ],
                        ),
                );
              }),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
