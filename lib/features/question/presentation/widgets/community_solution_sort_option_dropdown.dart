import 'package:codersgym/features/question/data/entity/community_solution_sort_option.dart';
import 'package:flutter/material.dart';
import 'dart:math' show pi;

class CommunitySolutionSortOptionDropdown extends StatefulWidget {
  final Function(CommunitySolutionSortOption) onSortChanged;
  final CommunitySolutionSortOption initialSort;
  final double? iconSize;
  final double? dropdownIconSize;
  final double? fontSize;
  final BorderRadius? borderRadius;
  final EdgeInsets? contentPadding;

  const CommunitySolutionSortOptionDropdown({
    super.key,
    required this.onSortChanged,
    required this.initialSort,
    this.iconSize = 20,
    this.dropdownIconSize = 12,
    this.fontSize = 12,
    this.borderRadius,
    this.contentPadding,
  });

  @override
  State<CommunitySolutionSortOptionDropdown> createState() =>
      _CommunitySolutionSortOptionDropdownState();
}

class _CommunitySolutionSortOptionDropdownState
    extends State<CommunitySolutionSortOptionDropdown> {
  late CommunitySolutionSortOption sortOption;
  late final List<CommunitySolutionSortOption> sortOptions;

  @override
  void initState() {
    super.initState();
    sortOption = widget.initialSort;
    sortOptions = defaultCommunitySolutionSortOptions;
  }

  CommunitySolutionSortOption get currentSortOption {
    return sortOptions.firstWhere(
      (option) => option == sortOption,
      orElse: () => sortOptions.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(10.0);

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 54),
      child: IntrinsicWidth(
        child: Theme(
          // Override the default dropdown theme
          data: theme.copyWith(
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: theme.cardColor,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: borderRadius,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: borderRadius,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: borderRadius,
              ),
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          child: DropdownButtonFormField<CommunitySolutionSortOption>(
            value: sortOption,
            isDense: true,
            isExpanded: false,
            icon: _buildDropdownIcon(theme),
            decoration: const InputDecoration(),
            borderRadius: borderRadius,
            padding: EdgeInsets.zero,
            style: theme.textTheme.titleMedium,
            selectedItemBuilder: (context) => _buildSelectedItems(),
            items: _buildDropdownItems(),
            onChanged: _handleSortChange,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownIcon(ThemeData theme) {
    return Transform(
      alignment: Alignment.centerRight,
      transform: Matrix4.identity()
        ..rotateZ(-270 * (pi / 180))
        ..scale(1.8)
        ..translate(4.0, 4.0),
      child: Icon(
        Icons.sort_sharp,
        color: theme.hintColor,
        size: widget.dropdownIconSize,
      ),
    );
  }

  List<Widget> _buildSelectedItems() {
    return sortOptions.map<Widget>((option) {
      return Center(
        child: Icon(
          option.icon,
          color: option.color,
          size: widget.iconSize,
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<CommunitySolutionSortOption>> _buildDropdownItems() {
    return sortOptions.map((option) {
      return DropdownMenuItem<CommunitySolutionSortOption>(
        value: option,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              option.icon,
              color: option.color,
              size: widget.iconSize! *
                  0.8, // Slightly smaller than the selected icon
            ),
            const SizedBox(width: 8),
            Text(
              option.label,
              style: TextStyle(fontSize: widget.fontSize),
            ),
          ],
        ),
      );
    }).toList();
  }

  void _handleSortChange(CommunitySolutionSortOption? newValue) {
    if (newValue != null && newValue != sortOption) {
      setState(() {
        sortOption = newValue;
        widget.onSortChanged(newValue);
      });
    }
  }
}
