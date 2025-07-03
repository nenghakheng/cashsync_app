import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthFormHeader extends StatelessWidget {
  const AuthFormHeader({super.key, this.onSignUp});

  final bool? onSignUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/cashsynclogo.svg', height: 65, width: 65),
          ],
        ),
        ConfigConstant.sizedBoxH2,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              onSignUp == true ? 'Sign Up' : 'Log In',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
