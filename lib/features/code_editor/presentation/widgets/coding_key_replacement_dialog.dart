import 'package:codersgym/core/utils/string_extension.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_key_config.dart';
import 'package:flutter/material.dart';

class CodingKeyReplacementDialog extends StatefulWidget {
  final String currentKey;

  const CodingKeyReplacementDialog({
    super.key,
    required this.currentKey,
  });

  @override
  CodingKeyReplacementDialogState createState() =>
      CodingKeyReplacementDialogState();

  // Method to show the dialog
  static Future<String?> show(BuildContext context, String currentKey,
      List<String> currentConfiguration) {
    return showDialog<String>(
      context: context,
      builder: (context) => CodingKeyReplacementDialog(
        currentKey: currentKey,
      ),
    );
  }
}

class CodingKeyReplacementDialogState
    extends State<CodingKeyReplacementDialog> {
  CodingKeyConfig? _selectedKey;
  late List<CodingKeyConfig> _availableKeys;

  @override
  void initState() {
    super.initState();

    // Get all available keys that are not already in the current configuration
    _availableKeys = CodingKeyConfig.lookupMap.values
        .map(
          (e) => e.call(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Replace ${_getKeyLabel(widget.currentKey)}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<CodingKeyConfig>(
            decoration: const InputDecoration(
              labelText: 'Select Replacement Key',
              border: OutlineInputBorder(),
            ),
            value: _selectedKey,
            isExpanded: true,
            hint: const Text('Choose a key'),
            items: _availableKeys.map((CodingKeyConfig item) {
              return DropdownMenuItem<CodingKeyConfig>(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      switch (item) {
                        CodingTextKeyConfig() => Text(
                            item.label,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        CodingIconKeyConfig() => Icon(
                            item.icon,
                            size: 16,
                          ),
                      },
                      Text(
                        item.id.capitalizeFirstLetter(),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            onChanged: (CodingKeyConfig? newValue) {
              setState(() {
                _selectedKey = newValue;
              });
            },
          ),
          if (_selectedKey != null) ...[
            const SizedBox(height: 16),
            Text(
              _selectedKey!.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: _selectedKey != null
              ? () => Navigator.of(context).pop(_selectedKey!.id)
              : null,
          child: const Text('Replace'),
        ),
      ],
    );
  }

  // Helper method to get a more readable label for each key
  String _getKeyLabel(String key) {
    // Remove 'CodingKeyConfig' from the end of the key name
    return key.replaceAll('CodingKeyConfig', '');
  }
}
