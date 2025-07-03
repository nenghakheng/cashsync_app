import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/pages/auth/local_widgets/credentials_form.dart';
import 'package:cashsyncapp/viewModels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
    // Access AuthViewModel from context
    final authViewModel = Provider.of<AuthViewModel>(context);

    // If loading, show progress indicator
    if (authViewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If user is authenticated, redirect to home page
    if (authViewModel.isAuthenticated) {
      // Use Future.microtask to navigate after the build is complete
      Future.microtask(() {
        Navigator.of(context).pushReplacementNamed('/home');
      });
    }

    return Scaffold(body: SingleChildScrollView(child: buildBody(context)));
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
                  // Navigate to sign up screen
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text('Sign up'),
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
    final authViewModel = Provider.of<AuthViewModel>(context);

    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          // Attempt login
          final success = await authViewModel.login(
            _emailController.text.trim(),
            _passwordController.text,
          );

          if (!success && mounted) {
            // Show error message if login failed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authViewModel.errorMessage ?? 'Login failed'),
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
        'Log in',
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
          onPressed: () async {
            final success = await authViewModel.googleLogin();

            if (!success && mounted) {
              // Show error message if Google login failed
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    authViewModel.errorMessage ?? 'Google login failed',
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
