import 'package:flutter/material.dart';

class CodeEditorBackConfirmationDialog extends StatelessWidget {
  const CodeEditorBackConfirmationDialog({super.key});

  static Future<bool?> show(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => const CodeEditorBackConfirmationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warning'),
      content: const Text(
          'Your code will be reset if you go back. Do you want to continue?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // Stay on the page
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true), // Allow going back
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
