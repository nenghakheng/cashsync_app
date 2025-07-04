import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, this.title, this.onPressed, this.icon});

  final String? title;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5063BF),
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: ConfigConstant.circlarRadius3,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, color: Colors.white),
          if (icon != null) const SizedBox(width: 8),
          Text(
            title ?? 'Button',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
