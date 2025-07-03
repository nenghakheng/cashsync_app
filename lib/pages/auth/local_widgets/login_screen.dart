import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/pages/auth/local_widgets/alternative_auth_prompt.dart';
import 'package:cashsyncapp/pages/auth/local_widgets/auth_form_actions.dart';
import 'package:cashsyncapp/pages/auth/local_widgets/auth_form_header.dart';
import 'package:cashsyncapp/pages/auth/local_widgets/credentials_form.dart';
import 'package:cashsyncapp/viewModels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onToggleView;
  const LoginScreen({super.key, required this.onToggleView});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access AuthViewModel from context
    final authViewModel = Provider.of<AuthViewModel>(context);

    // If loading, show progress indicator
    if (authViewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: buildBody(
          context,
          _formKey,
          _emailController,
          _passwordController,
        ),
      ),
    );
  }

  Widget buildBody(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          AuthFormHeader(),
          // Credential Form
          CredentialForm(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            obscurePassword: _obscurePassword,
          ),
          // Auth Form Actions
          ConfigConstant.sizedBoxH7,
          AuthFormActions(
            formKey: formKey,
            emailController: emailController,
            passwordController: passwordController,
          ),
          ConfigConstant.sizedBoxH5,
          // Alternative Auth Prompt
          AlternativeAuthPrompt(
            onSignUp: false,
            onToggleView: widget.onToggleView, // Use the toggle function
          ),
        ],
      ),
    );
  }
}
