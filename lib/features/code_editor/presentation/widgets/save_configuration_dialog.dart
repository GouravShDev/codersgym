import 'package:codersgym/features/code_editor/presentation/blocs/customize_coding_experience/customize_coding_experience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveConfigurationDialog extends StatelessWidget {
  const SaveConfigurationDialog({
    super.key,
    required this.onSave,
  });
  final Function() onSave;

  static Future<bool?> show(
    BuildContext context, {
    required Function() onSave,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => SaveConfigurationDialog(
        onSave: onSave,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warning'),
      content: const Text(
          'You have unsaved changes. Do you want to save your configuration before proceeding?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Discard'),
        ),
        TextButton(
          onPressed: () {
            onSave();
            Navigator.of(context).pop(true);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
