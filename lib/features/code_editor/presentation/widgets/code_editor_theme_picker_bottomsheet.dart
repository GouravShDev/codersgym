import 'package:codersgym/core/theme/app_code_editor_theme.dart';
import 'package:codersgym/core/utils/string_extension.dart';
import 'package:flutter/material.dart';

class CodeEditorThemePickerBottomsheet extends StatelessWidget {
  const CodeEditorThemePickerBottomsheet({
    super.key,
    required this.onThemeSelected,
    required this.currentThemeId,
    required this.isDarkBackgroundEnabled,
    required this.onDarkBackgroundToggle,
    this.scrollController,
  });
  final Function(AppCodeEditorTheme theme) onThemeSelected;
  final Function() onDarkBackgroundToggle;
  final String currentThemeId;
  final bool isDarkBackgroundEnabled;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        // vertical: 24,
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Choose a Theme',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 14),

          // Background toggle and Reset button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildToggleOption(
                context: context,
                title: 'Dark Background',
                value: isDarkBackgroundEnabled,
                onChanged: (value) => onDarkBackgroundToggle(),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text("Reset"),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Themes grid
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              controller: scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: AppCodeEditorTheme.allCodeEditorThemes.length,
              itemBuilder: (context, index) {
                final theme = AppCodeEditorTheme.allCodeEditorThemes[index];
                final isSelected = theme.id == currentThemeId;

                return _buildThemeCard(
                  context: context,
                  theme: theme,
                  isSelected: isSelected,
                  onTap: () => onThemeSelected(theme),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required BuildContext context,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(width: 8),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildThemeCard({
    required BuildContext context,
    required AppCodeEditorTheme theme,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final themeColor =
        theme.data['title']?.color ?? Theme.of(context).primaryColor;
    final background = isDarkBackgroundEnabled
        ? Theme.of(context).primaryColorDark.withValues(alpha: 0.3)
        : theme.data['root']?.backgroundColor;
    final textColor = theme.data['title']?.color ??
        Theme.of(context).textTheme.titleMedium?.color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected ? themeColor : Colors.grey.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
            color: background,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Theme color indicator
              Container(
                width: 32,
                height: 8,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              // Theme name
              Text(
                theme.id.convertToTitleCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: textColor,
                ),
              ),

              // Selected indicator
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: background,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
