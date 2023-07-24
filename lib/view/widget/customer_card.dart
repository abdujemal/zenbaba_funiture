import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../data/model/cutomer_model.dart';
import '../Pages/add_cutomer.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customerModel;
  const CustomerCard({super.key, required this.customerModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(
          () => AddCutomer(
            customerModel: customerModel,
          ),
        );
      },
      leading: CircleAvatar(
          backgroundColor: primaryColor,
          child: customerModel.gender == Gender.Male
              ? const Icon(Icons.male)
              : const Icon(Icons.female)),
      title: Text(customerModel.name),
      subtitle: Text("${customerModel.sefer}, ${customerModel.kk}"),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                launchUrl(Uri.parse("tel://${customerModel.phone}"));
              },
              icon: const Icon(Icons.call),
            ),
            IconButton(
              onPressed: () {
                if (customerModel.location != " ") {
                  launchUrl(Uri.parse(customerModel.location));
                }
              },
              icon: const Icon(Icons.map),
            )
          ],
        ),
      ),
    );
  }
}
