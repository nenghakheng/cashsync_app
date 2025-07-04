import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key, this.user, this.isReadOnly = true});

  final UserModel? user;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmailInput(context, user?.email),
          ConfigConstant.sizedBoxH4,
          _buildNameInput(context, user?.name),
        ],
      ),
    );
  }

  Widget _buildEmailInput(BuildContext context, String? email) {
    final TextEditingController emailController = TextEditingController(
      text: email,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email Address", style: Theme.of(context).textTheme.bodyLarge),
        TextFormField(
          controller: emailController,
          readOnly: isReadOnly, // Make it read-only since we're just displaying
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            hintText: "example@xyz.com",
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }

  Widget _buildNameInput(BuildContext context, String? name) {
    final TextEditingController nameController = TextEditingController(
      text: name,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name", style: Theme.of(context).textTheme.bodyLarge),
        TextFormField(
          controller: nameController,
          readOnly: isReadOnly, // Make it read-only since we're just displaying
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            hintText: "Enter your name",
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }
}
