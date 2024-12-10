import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/routes/app_router.gr.dart';

class LeetcodeLoginDialog extends StatelessWidget {
  const LeetcodeLoginDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LeetcodeLoginDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login Required'),
      content:
          const Text('Please login with your LeetCode account to run code.'),
      actions: [
        TextButton(
          onPressed: () {
            context.router.pushAndPopUntil(
              const LoginRoute(),
              predicate: (route) => false,
            );
          },
          child: const Text('Go to Login'),
        ),
      ],
    );
  }
}
