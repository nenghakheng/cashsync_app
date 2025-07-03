import 'package:flutter/material.dart';

class AlternativeAuthPrompt extends StatelessWidget {
  final bool onSignUp;
  final VoidCallback onToggleView;

  const AlternativeAuthPrompt({
    super.key,
    this.onSignUp = false,
    required this.onToggleView,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          onSignUp ? 'Already have an account? ' : 'Don\'t have an account? ',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        TextButton(
          onPressed: onToggleView, // Use the toggle function
          child: Text(onSignUp ? 'Sign in' : 'Sign up'),
        ),
      ],
    );
  }
}
