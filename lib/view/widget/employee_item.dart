import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/model/employee_model.dart';
import 'package:zenbaba_funiture/view/Pages/employee_activities_page.dart';
import 'package:zenbaba_funiture/view/Pages/employee_detail_page.dart';

class EmployeeItem extends StatelessWidget {
  final EmployeeModel employeeModel;
  const EmployeeItem({super.key, required this.employeeModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Row(
            children: [
              FutureBuilder(
                future: displayImage(employeeModel.imgUrl!, employeeModel.id!,
                    FirebaseConstants.employees),
                builder: (context, ds) {
                  return InkWell(
                    onTap: () {
                      Get.to(
                        () => EmployeeActivityPage(
                          employeeModel: employeeModel,
                        ),
                      );
                    },
                    child: Ink(
                      child: CircleAvatar(
                        backgroundImage:
                            ds.data != null ? FileImage(ds.data!) : null,
                        radius: 35,
                        child: ds.data == null
                            ? CircularProgressIndicator(
                                color: primaryColor,
                              )
                            : ds.data!.path == ""
                                ? const Icon(
                                    Icons.signal_wifi_off_sharp,
                                    size: 29,
                                  )
                                : null,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                width: 30,
              ),
              InkWell(
                onTap: () {
                  Get.to(
                    () => EmployeeDetailsPage(
                      employeeModel: employeeModel,
                    ),
                  );
                },
                child: Ink(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeModel.name,
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        employeeModel.position,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        employeeModel.type,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Divider(
            color: textColor,
            thickness: 1.3,
          ),
        )
      ],
    );
  }
}
