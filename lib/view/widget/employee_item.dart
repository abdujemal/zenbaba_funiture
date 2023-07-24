import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/model/employee_model.dart';
import 'package:zenbaba_funiture/view/Pages/add_emploee_page.dart';

class EmployeeItem extends StatelessWidget {
  final EmployeeModel employeeModel;
  const EmployeeItem({super.key, required this.employeeModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => AddEmployeePage(
              employeeModel: employeeModel,
            ));
      },
      child: Ink(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(employeeModel.imgUrl!),
                    radius: 35,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeModel.name,
                        style: const TextStyle(
                          color: Colors.white70,
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
        ),
      ),
    );
  }
}
