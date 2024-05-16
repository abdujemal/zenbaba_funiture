import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/model/employee_model.dart';
import 'package:zenbaba_funiture/view/Pages/employee_activities_page.dart';
import 'package:zenbaba_funiture/view/controller/l_s_controller.dart';

import '../Pages/employee_detail_page.dart';

class EmployeeItem extends StatelessWidget {
  final EmployeeModel employeeModel;
  const EmployeeItem({super.key, required this.employeeModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (Get.find<LSController>().currentUser.value.priority !=
            UserPriority.AdminView) {
          Get.to(
            () => EmployeeActivityPage(
              employeeModel: employeeModel,
            ),
          );
        }
      },
      leading: FutureBuilder(
        future: displayImage(employeeModel.imgUrl!, employeeModel.id!,
            FirebaseConstants.employees),
        builder: (context, ds) {
          return InkWell(
            onTap: () {
              Get.to(
                () => EmployeeDetailsPage(
                  employeeModel: employeeModel,
                ),
              );
            },
            child: Ink(
              child: ds.data != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(ds.data!),
                      radius: 30,
                      child: ds.data!.path == ""
                          ? const Icon(
                              Icons.signal_wifi_off_sharp,
                              size: 29,
                            )
                          : null,
                    )
                  : kIsWeb
                      ? CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            employeeModel.imgUrl!,
                          ),
                          radius: 30,
                        )
                      : const CircleAvatar(
                          radius: 30,
                        ),
            ),
          );
        },
      ),
      title: Text(
        employeeModel.name,
        style: TextStyle(
          color: whiteColor,
          fontSize: 17,
        ),
      ),
      subtitle: Text(
        employeeModel.type,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        employeeModel.position,
        style: TextStyle(
          color: primaryColor,
          fontSize: 15,
        ),
      ),
    );
  }
}
