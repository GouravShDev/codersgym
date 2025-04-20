import 'package:codersgym/features/articles/domain/model/discussion_sort_option.dart';
import 'package:flutter/material.dart';

class DiscussionSortOptionDropdown extends StatefulWidget {
  final void Function(DiscussionSortOption) onSortChanged;

  const DiscussionSortOptionDropdown({
    super.key,
    required this.onSortChanged,
  });

  @override
  State<DiscussionSortOptionDropdown> createState() =>
      _DiscussionSortOptionDropdownState();
}

class _DiscussionSortOptionDropdownState
    extends State<DiscussionSortOptionDropdown> {
  DiscussionSortOption _selectedSortOption =
      DiscussionSortOption.mostVotes; // Default

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputDecorationTheme = theme.inputDecorationTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
            color: inputDecorationTheme.enabledBorder?.borderSide.color ??
                theme.dividerColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DiscussionSortOption>(
          borderRadius: BorderRadius.circular(8),
          icon: const Icon(
            Icons.arrow_drop_down,
          ),
          iconSize: 24,
          dropdownColor: theme.colorScheme.surface,
          value: _selectedSortOption,
          items: DiscussionSortOption.options
              .map<DropdownMenuItem<DiscussionSortOption>>(
                  (DiscussionSortOption value) {
            return DropdownMenuItem<DiscussionSortOption>(
              value: value,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(value.icon),
                  const SizedBox(width: 8),
                  Text(
                    value.label,
                    style: theme.textTheme.labelLarge?.copyWith(fontSize: 14),
                  )
                ],
              ),
            );
          }).toList(),
          onChanged: (DiscussionSortOption? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedSortOption = newValue;
              });
              widget.onSortChanged(newValue);
            }
          },
        ),
      ),
    );
  }
}
