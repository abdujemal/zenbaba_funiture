
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../controller/main_controller.dart';
import '../widget/user_card.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Users"),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/menu icon.svg',
            color: whiteColor,
            height: 21,
          ),
          onPressed: () {
            mainConntroller.z.value.open!();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                mainConntroller.getUsers();
              },
              icon: const Icon(Icons.refresh_rounded))
        ],
      ),
      body: Obx(() {
        if (mainConntroller.getUsersStatus.value == RequestState.loading) {
          return Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }
        return ListView.builder(
            itemCount: mainConntroller.users.length,
            itemBuilder: (context, index) {
              return UserCard(
                userModel: mainConntroller.users[index],
              );
            });
      }),
    );
  }
}
