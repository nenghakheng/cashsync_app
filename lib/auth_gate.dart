import 'package:cashsyncapp/pages/layout/bottom_navigation.dart';
import 'package:cashsyncapp/pages/auth/auth_screen.dart';
import 'package:cashsyncapp/viewModels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        // Show loading indicator while checking auth status
        if (authViewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Navigate based on authentication state
        if (authViewModel.isAuthenticated) {
          return const BottomNavigation();
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
