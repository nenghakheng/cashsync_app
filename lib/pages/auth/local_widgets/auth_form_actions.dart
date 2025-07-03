import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/viewModels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AuthFormActions extends StatefulWidget {
  const AuthFormActions({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    this.confirmPasswordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? confirmPasswordController;

  // Form state based on confirmPassword
  bool get isSignUp => confirmPasswordController != null;

  @override
  State<AuthFormActions> createState() => _AuthFormActionsState();
}

class _AuthFormActionsState extends State<AuthFormActions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              buildLoginButton(context),
              ConfigConstant.sizedBoxH7,
              buildGoogleAuthSection(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLoginButton(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return ElevatedButton(
      onPressed: () async {
        if (widget.formKey.currentState!.validate()) {
          // Attempt login
          final success = await authViewModel.login(
            widget.emailController.text.trim(),
            widget.passwordController.text,
          );

          if (!success && mounted) {
            // Show error message if login failed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authViewModel.errorMessage ?? 'Auth failed'),
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5063BF),
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: ConfigConstant.circlarRadius3,
        ),
      ),
      child: Text(
        widget.isSignUp ? "Sign Up" : 'Log in',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildGoogleAuthSection(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Column(
      children: [
        // Wrap the Row in a Container with same horizontal padding as the login button
        SizedBox(
          width: 128 + 64 + 64, // Approximate button width plus padding
          child: Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
        ),

        ConfigConstant.sizedBoxH3,

        // Google sign in button
        ElevatedButton(
          onPressed: () async {
            final success = await authViewModel.googleLogin();

            if (!success && mounted) {
              // Show error message if Google login failed
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    authViewModel.errorMessage ??
                        'Google Authentication failed',
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ConfigConstant.radius3),
            ),
          ),
          child: SvgPicture.asset(
            'assets/googlelogo.svg', // Changed to SVG extension
            height: 32,
            width: 32,
            errorBuilder:
                (ctx, obj, _) => const Icon(Icons.g_mobiledata, size: 32),
          ),
        ),
      ],
    );
  }
}
