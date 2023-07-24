import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/widget/update_user.dart';

import '../../constants.dart';
import '../../data/model/user_model.dart';

class UserCard extends StatefulWidget {
  final UserModel userModel;
  const UserCard({super.key, required this.userModel});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  File? imageFile;
  @override
  void initState() {
    super.initState();
    setImageFile();
  }

  setImageFile() async {
    imageFile = await displayImage(widget.userModel.image!,
        widget.userModel.id!, FirebaseConstants.users);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.bottomSheet(UpdateUserDialog(userModel: widget.userModel));
      },
      title: Text(widget.userModel.name),
      leading: CircleAvatar(
        radius: 29,
        backgroundImage: imageFile != null && imageFile!.path != ""
            ? FileImage(imageFile!)
            : null,
        backgroundColor: backgroundColor,
        child: Center(
            child: imageFile == null
                ? CircularProgressIndicator(
                    color: primaryColor,
                  )
                : imageFile!.path == ""
                    ? const Icon(
                        Icons.signal_wifi_off_sharp,
                        size: 29,
                      )
                    : const SizedBox()),
      ),
      subtitle: Text(widget.userModel.email),
      trailing: Text(widget.userModel.priority),
    );
  }
}
