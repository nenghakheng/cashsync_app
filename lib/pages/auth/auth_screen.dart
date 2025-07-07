import 'package:cashsyncapp/pages/auth/local_widgets/login_screen.dart';
import 'package:cashsyncapp/pages/auth/local_widgets/signup_screen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
