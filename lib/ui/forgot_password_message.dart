import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ForgotPasswordMessage extends StatelessWidget {
  const ForgotPasswordMessage({
    required this.sendPasswordResetEmailText,
    super.key,
    this.sendPasswordResetEmailAction,
  });

  final String sendPasswordResetEmailText;
  final void Function()? sendPasswordResetEmailAction;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: sendPasswordResetEmailText,
            style: theme.textTheme.bodyLarge?.copyWith(
              decoration: TextDecoration.underline,
              color: theme.colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = sendPasswordResetEmailAction,
          ),
        ],
      ),
    );
  }
}
