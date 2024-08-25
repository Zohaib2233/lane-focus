import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/controller/profile_controller/profile_controller.dart';

import '../../core/utils/snackbar.dart';

class PasswordDialog extends StatelessWidget {
  final void Function(String password) onConfirm;

  PasswordDialog({
    Key? key,

    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find<ProfileController>();
    return AlertDialog(
      title: Text('Delete Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Please enter your password to delete your account.'),
          SizedBox(height: 10),
          TextField(
            controller: profileController.delPassword,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final password =profileController.delPassword.text.trim();
            if (password.isNotEmpty) {
              profileController.deleteUserAccount(context);

            } else {
              // Show an error message or handle empty password case
              CustomSnackBars.instance.showFailureSnackbar(
                  title: 'Error', message: 'Password cannot be empty');
            }
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}


