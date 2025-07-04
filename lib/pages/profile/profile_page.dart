import 'package:cashsyncapp/commons/navigate_button.dart';
import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/user_model.dart';
import 'package:cashsyncapp/pages/profile/local_widgets/profile_picture.dart';
import 'package:cashsyncapp/pages/profile/local_widgets/progile_info.dart';
import 'package:cashsyncapp/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool? isEdit = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrentUserProvider(),
      child: Scaffold(appBar: _buildAppBar(context), body: _buildBody(context)),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      forceMaterialTransparency: true,
      title: const Text(
        "Profile",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leadingWidth: 130,
      leading: _buildBackButton(context),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return NavigateButton(
      icon: Icon(
        Icons.arrow_back,
        size: ConfigConstant.iconSize2,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    final CurrentUserProvider currentUserProvider =
        Provider.of<CurrentUserProvider>(context);
    final UserModel? user = currentUserProvider.currentUser;

    return Center(
      child: Column(
        children: [
          ProfilePicture(isEdit: !isEdit!),
          ConfigConstant.sizedBoxH3,
          ProfileInfo(user: user, isReadOnly: !isEdit!),
          ConfigConstant.sizedBoxH6,
          _buildEditButton(context),
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          // Toggle the edit state
          isEdit = !isEdit!;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5063BF),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: ConfigConstant.circlarRadius3,
        ),
      ),
      child: Text(
        "Edit Profile",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
