import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenbaba_funiture/view/Pages/customer_details_page.dart';

import '../../constants.dart';
import '../../data/model/cutomer_model.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customerModel;
  const CustomerCard({super.key, required this.customerModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(
          () => CustomerDetailsPage(
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
      subtitle: Text(
        "${customerModel.sefer}, ${customerModel.kk}",
        style: TextStyle(
          color: textColor,
        ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                launchUrl(Uri.parse("tel://${customerModel.phone}"));
              },
              icon: Icon(
                Icons.call,
                color: textColor,
              ),
            ),
            IconButton(
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse(customerModel.location))) {
                    await launchUrl(Uri.parse(customerModel.location));
                  }
                },
                icon: SvgPicture.asset(
                  'assets/pickup.svg',
                  color: textColor,
                  height: 25,
                  width: 25,
                ))
          ],
        ),
      ),
    );
  }
}
