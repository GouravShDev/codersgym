import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/code_editor_language_dropdown.dart';
import 'package:flutter/material.dart';

class PreferencesBottomSheet extends StatefulWidget {
  const PreferencesBottomSheet({
    super.key,
    required this.onPreferenceChanged,
    this.hideKeyboard = false,
    this.tabSize = 2,
    this.showSuggestions = true,
    this.fontSize = 16,
    required this.language,
  });

  final bool hideKeyboard;
  final int tabSize;
  final bool showSuggestions;
  final int fontSize;
  final ProgrammingLanguage language;
  final Function({
    bool? hideKeyboard,
    int? tabSize,
    bool? showSuggestions,
    int? fontSize,
    ProgrammingLanguage? language,
  }) onPreferenceChanged;

  @override
  State<PreferencesBottomSheet> createState() => _PreferencesBottomSheetState();
}

class _PreferencesBottomSheetState extends State<PreferencesBottomSheet> {
  late bool _hideKeyboard;
  late int _tabSize;
  late bool _showSuggestions;
  late int _fontSize;
  late ProgrammingLanguage _language;
  @override
  void initState() {
    super.initState();
    _hideKeyboard = widget.hideKeyboard;
    _tabSize = widget.tabSize;
    _showSuggestions = widget.showSuggestions;
    _fontSize = widget.fontSize;
    _language = widget.language;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.74,
      maxChildSize: 0.74,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Preferences",
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Language: ",
                          style: textTheme.titleSmall?.copyWith(),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: CodeEditorLanguageDropDown(
                            currentLanguage: _language,
                            showWarning: false,
                            onLanguageChange: (language) {
                              setState(() {
                                _language = language;
                              });
                              widget.onPreferenceChanged(
                                language: _language,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).dividerColor.withOpacity(0.3),
            ),
            const SizedBox(
              height: 4,
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Font Size",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "$_fontSize",
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Slider(
                    value: _fontSize.toDouble(),
                    min: 12,
                    max: 20,
                    divisions: 8,
                    label: _fontSize.toStringAsFixed(0),
                    onChanged: (val) {
                      setState(
                        () => _fontSize = val.toInt(),
                      );

                      widget.onPreferenceChanged(fontSize: _fontSize);
                    },
                  ),
                  // Hide Keyboard Option
                  _buildSwitchTile(
                    title: "Hide Keyboard",
                    subtitle: "Useful when using external keyboard",
                    value: _hideKeyboard,
                    onChanged: (value) {
                      setState(() {
                        _hideKeyboard = value;
                        widget.onPreferenceChanged(hideKeyboard: value);
                      });
                    },
                  ),

                  const SizedBox(height: 8),

                  // Tab Size Option
                  _buildTabSizeSelector(theme),

                  const SizedBox(height: 8),

                  // Show Suggestions Option
                  _buildSwitchTile(
                    title: "Show Suggestions",
                    subtitle: "Display code completion suggestions",
                    value: _showSuggestions,
                    onChanged: (value) {
                      setState(() {
                        _showSuggestions = value;
                        widget.onPreferenceChanged(showSuggestions: value);
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color:
                            theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: theme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSizeSelector(ThemeData theme) {
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tab Size",
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Number of spaces for each tab",
          style: textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [2, 4, 8].map((size) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _tabSize = size;
                      widget.onPreferenceChanged(tabSize: size);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _tabSize == size
                        ? theme.primaryColor
                        : theme.primaryColor.withOpacity(0.2),
                    foregroundColor:
                        _tabSize == size ? Colors.white : theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text("$size"),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
