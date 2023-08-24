

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/Pages/search_page.dart';

import '../../constants.dart';
import '../controller/main_controller.dart';
import '../widget/customer_card.dart';
import 'add_cutomer.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Customers"),
        leading: IconButton(
            icon: SvgPicture.asset(
              'assets/menu icon.svg',
              color: whiteColor,
              height: 21,
            ),
            onPressed: () {
              mainConntroller.z.value.open!();
            }),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const AddCutomer());
            },
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              mainConntroller.getCustomers();
            },
            icon: const Icon(
              Icons.refresh_rounded,
              size: 30,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          mainConntroller.getCustomers(quantity: 5, end: 10);
          Get.to(
            () => SearchPage(
              path: FirebaseConstants.customers,
            ),
          );
        },
        child: const Icon(
          Icons.search,
          size: 30,
        ),
      ),
      body: Obx(() {
        
        if (mainConntroller.getCustomersStatus.value == RequestState.loading) {
          return Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }
        if (mainConntroller.customers.isEmpty) {
          return const Center(
            child: Text("No Customers"),
          );
        }
        return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: mainConntroller.customers.length+1,
            itemBuilder: (context, index) {
              try {
                return CustomerCard(
                    customerModel: mainConntroller.customers[index]);
              } catch (e) {
                return const SizedBox(
                  height: 60,
                );
              }
            });
      }),
    );
  }
}
