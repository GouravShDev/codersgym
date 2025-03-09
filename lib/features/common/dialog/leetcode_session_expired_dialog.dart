import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeetcodeSessionExpiredDialog extends StatelessWidget {
  const LeetcodeSessionExpiredDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LeetcodeSessionExpiredDialog(),
    );
  }

  Future<void> _launchLeetCodeLogin(BuildContext context) async {
    context.read<AuthBloc>().add(AuthLogout());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: 28),
            const SizedBox(width: 8),
            Text(
              'Session Expired',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your LeetCode session has expired. To continue coding,',
              style: textTheme.bodyLarge,
            ),
            Text(
              'Please log in via Leetcode again',
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Don\'t worry! Your recent work has been saved automatically.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Later"),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.launch, size: 18),
            onPressed: () => _launchLeetCodeLogin(context),
            label: Text(
              'Log In',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
