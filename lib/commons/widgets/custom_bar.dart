import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      actionsPadding: EdgeInsets.only(right: ConfigConstant.padding3),
      automaticallyImplyLeading: false,
      leading: Builder(
        // Add this Builder widget
        builder: (BuildContext context) {
          // This context has access to the Scaffold
          return Container(
            margin: EdgeInsets.only(left: ConfigConstant.padding3),
            child: IconButton(
              padding: EdgeInsets.only(right: ConfigConstant.padding3),
              iconSize: ConfigConstant.iconSize3,
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Now this works
              },
            ),
          );
        },
      ),
      // Center the title area (can be empty or contain content)
      title: const SizedBox(),
      centerTitle: true,
      // Place notification icon on the right side
      actions: [
        IconButton(
          iconSize: ConfigConstant.iconSize3,
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
      ],
    );
  }
}
