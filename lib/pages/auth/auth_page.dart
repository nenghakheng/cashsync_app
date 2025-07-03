import 'package:cashsyncapp/pages/auth/local_widgets/login_screen.dart';
import 'package:cashsyncapp/pages/auth/local_widgets/signup_screen.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginScreen = true;

  void toggleAuthScreen() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, forceMaterialTransparency: true),
      body:
          showLoginScreen
              ? LoginScreen(onToggleView: toggleAuthScreen)
              : SignUpScreen(onToggleView: toggleAuthScreen),
    );
  }
}
