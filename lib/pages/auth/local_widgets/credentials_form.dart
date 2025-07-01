import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:flutter/material.dart';

class CredentialForm extends StatefulWidget {
  const CredentialForm({
    super.key,
    required this.formKey,
    required this.obscurePassword,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final bool obscurePassword;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<CredentialForm> createState() => _CredentialFormState();
}

class _CredentialFormState extends State<CredentialForm> {
  late bool _obscurePassword;

  @override
  void initState() {
    super.initState();
    _obscurePassword = widget.obscurePassword;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Basic email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConfigConstant.sizedBoxH6,
          _buildEmailInput(),
          ConfigConstant.sizedBoxH2,
          // Password field
          _buildPasswordInput(),
        ],
      ),
    );
  }

  Widget _buildEmailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email Address", style: Theme.of(context).textTheme.bodyLarge),
        TextFormField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: "example@xyz.com",
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
          validator: (value) => _emailValidator(value),
        ),
      ],
    );
  }

  Widget _buildPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: Theme.of(context).textTheme.bodyLarge),
        TextFormField(
          controller: widget.passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            suffixIcon: _buildPasswordInputIcon(),
            hintText: "*********",
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: UnderlineInputBorder(),
          ),
          validator: (value) => _passwordValidator(value),
        ),
      ],
    );
  }

  Widget _buildPasswordInputIcon() {
    return IconButton(
      icon: Icon(
        widget.obscurePassword
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
      ),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
          print(_obscurePassword);
        });
      },
    );
  }
}
