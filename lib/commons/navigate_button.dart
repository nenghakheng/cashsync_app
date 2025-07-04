import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:flutter/material.dart';

class NavigateButton extends StatelessWidget {
  const NavigateButton({super.key, this.onPressed, this.icon});

  final VoidCallback? onPressed;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 38, right: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF5063BF),
        borderRadius: ConfigConstant.circlarRadius3,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: ConfigConstant.circlarRadius3,
          onTap: onPressed,
          child: Center(
            child:
                icon ??
                const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
