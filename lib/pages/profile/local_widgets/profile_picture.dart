import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, this.imageUrl, this.isEdit = false});

  final String? imageUrl;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        imageUrl == null &&
                isEdit // Check if imageUrl is null and isEdit is true
            ? Column(
              children: [
                ConfigConstant.sizedBoxH5,
                Text(
                  "Please set profile picture",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade400),
                ),
              ],
            )
            : const SizedBox.shrink(),
        ConfigConstant.sizedBoxH5,
        CircleAvatar(
          radius: ConfigConstant.profileRadius3,
          backgroundColor: Color(0xFF5063BF),
          backgroundImage:
              imageUrl != null
                  ? NetworkImage(imageUrl!)
                  : const AssetImage('assets/images/default_profile.png')
                      as ImageProvider,
          child:
              imageUrl == null
                  ? const Icon(
                    Icons.person,
                    size: ConfigConstant.iconSize4,
                    color: Colors.white,
                  )
                  : null,
        ),
      ],
    );
  }
}
