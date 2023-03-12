import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class NoAccountSignUpMessage extends StatelessWidget {
  const NoAccountSignUpMessage({
    required this.firstPartText,
    required this.signUpText,
    super.key,
    this.signUpAction,
  });

  final String firstPartText;
  final String signUpText;
  final void Function()? signUpAction;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: firstPartText,
            style: theme.textTheme.bodyLarge,
          ),
          TextSpan(
            text: signUpText,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()..onTap = signUpAction,
          ),
        ],
      ),
    );
  }
}
