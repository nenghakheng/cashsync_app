import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CashSync')),
      body: const Center(child: Text('Welcome to the CashSync App!')),
    );
  }
}
