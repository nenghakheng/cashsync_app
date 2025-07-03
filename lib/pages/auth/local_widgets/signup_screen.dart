import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/pages/auth/local_widgets/alternative_auth_prompt.dart';
import 'package:cashsyncapp/pages/auth/local_widgets/auth_form_actions.dart';
import 'package:cashsyncapp/pages/auth/local_widgets/auth_form_header.dart';
import 'package:cashsyncapp/pages/auth/local_widgets/credentials_form.dart';
import 'package:cashsyncapp/viewModels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onToggleView;
  const SignUpScreen({super.key, required this.onToggleView});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);

    if (authViewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              AuthFormHeader(onSignUp: true),
              CredentialForm(
                formKey: _formKey,
                obscurePassword: _obscurePassword,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
              ),
              ConfigConstant.sizedBoxH5,
              AuthFormActions(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
              ),
              AlternativeAuthPrompt(
                onSignUp: true,
                onToggleView: widget.onToggleView, // Use the toggle function
              ),
            ],
          ),
        ),
      ),
    );
  }
}
