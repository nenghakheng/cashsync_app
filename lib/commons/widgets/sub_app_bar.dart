import 'package:flutter/material.dart';
import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/commons/widgets/navigate_button.dart';

class SubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final double leadingWidth;
  final List<Widget>? actions;

  const SubAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.leadingWidth = 130,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      forceMaterialTransparency: true,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leadingWidth: leadingWidth,
      leading: NavigateButton(
        icon: Icon(
          Icons.arrow_back,
          size: ConfigConstant.iconSize2,
          color: Colors.white,
        ),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
