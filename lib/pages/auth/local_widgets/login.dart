import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/pages/auth/local_widgets/credentials_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
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
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          buildLoginIconAndTitle(context),
          // Credential Form
          CredentialForm(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            obscurePassword: _obscurePassword,
          ),
          // Login Button
          ConfigConstant.sizedBoxH7,
          Center(
            child: Column(
              children: [
                buildLoginButton(context),
                ConfigConstant.sizedBoxH7,
                buildGoogleAuthSection(context),
              ],
            ),
          ),
          ConfigConstant.sizedBoxH5,
          // Don't Have an account? Sign up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account? ',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to Sign Up screen
                  print('Navigate to Sign Up screen');
                },
                child: Text(
                  'Sign up',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Color(0xFF5063BF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLoginIconAndTitle(BuildContext context) {
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
              'Log in',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Handle login logic
          print('Email: ${_emailController.text}');
          print('Password: ${_passwordController.text}');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5063BF),
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: ConfigConstant.circlarRadius3,
        ),
      ),
      child: Text(
        'Log in',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildGoogleAuthSection(BuildContext context) {
    return Column(
      children: [
        // Wrap the Row in a Container with same horizontal padding as the login button
        Container(
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
          // Match the style/width of the login button
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ConfigConstant.radius3),
            ),
          ),
          onPressed:
              () => {
                // Handle Google sign-in logic
                print('Google Sign-In button pressed'),
              },
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
