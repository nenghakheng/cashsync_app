import 'package:cashsyncapp/pages/auth/local_widgets/login.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(context), body: LoginScreen());
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(centerTitle: true, forceMaterialTransparency: true);
  }
}
