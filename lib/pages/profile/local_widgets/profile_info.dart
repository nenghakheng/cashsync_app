import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    super.key,
    this.user,
    this.isReadOnly = true,
    this.profileFormKey,
    this.profileEmailController,
    this.profileNameController,
  });

  final UserModel? user;
  final bool isReadOnly;
  final GlobalKey<FormState>? profileFormKey;
  final TextEditingController? profileEmailController;
  final TextEditingController? profileNameController;

  @override
  Widget build(BuildContext context) {
    if (profileEmailController != null &&
        user?.email != null &&
        profileEmailController!.text.isEmpty) {
      profileEmailController!.text = user!.email!;
    }

    if (profileNameController != null &&
        user?.name != null &&
        profileNameController!.text.isEmpty) {
      profileNameController!.text = user!.name!;
    }

    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: profileFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmailInput(context),
            ConfigConstant.sizedBoxH4,
            _buildNameInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email Address", style: Theme.of(context).textTheme.bodyLarge),
        TextFormField(
          controller: profileEmailController, // Use the passed controller
          keyboardType: TextInputType.emailAddress,
          readOnly: isReadOnly, // Make it read-only if not in edit mode
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            hintText: "example@xyz.com",
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNameInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name", style: Theme.of(context).textTheme.bodyLarge),
        TextFormField(
          controller: profileNameController, // Use the passed controller
          readOnly: isReadOnly, // Make it read-only if not in edit mode
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            hintText: "Enter your name",
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
      ],
    );
  }
}
