import 'package:flutter/material.dart';
import 'dart:math' show pi;

abstract class ISortOption {
  String get label;
  IconData get icon;
  Color get color;
}

class AppSortOptionDropdown<T extends ISortOption> extends StatefulWidget {
  final Function(T) onSortChanged;
  final T? initialSort;
  final List<T> sortOptions;
  final double? iconSize;
  final double? dropdownIconSize;
  final double? fontSize;
  final BorderRadius? borderRadius;
  final EdgeInsets? contentPadding;

  const AppSortOptionDropdown({
    super.key,
    required this.onSortChanged,
    required this.initialSort,
    required this.sortOptions,
    this.iconSize = 20,
    this.dropdownIconSize = 12,
    this.fontSize = 12,
    this.borderRadius,
    this.contentPadding,
  });

  @override
  State<AppSortOptionDropdown<T>> createState() =>
      _AppSortOptionDropdownState<T>();
}

class _AppSortOptionDropdownState<T extends ISortOption>
    extends State<AppSortOptionDropdown<T>> {
  late T? sortOption;

  @override
  void initState() {
    super.initState();
    sortOption = widget.initialSort;
  }

  T get currentSortOption {
    return widget.sortOptions.firstWhere(
      (option) => option == sortOption,
      orElse: () => widget.sortOptions.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(10.0);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 54,
      ),
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
          child: DropdownButtonFormField<T>(
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
    return widget.sortOptions.map<Widget>((option) {
      return Center(
        child: Icon(
          option.icon,
          color: option.color,
          size: widget.iconSize,
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<T>> _buildDropdownItems() {
    return widget.sortOptions.map((option) {
      return DropdownMenuItem<T>(
        value: option,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              option.icon,
              color: option.color,
              size: widget.iconSize! * 0.8,
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

  void _handleSortChange(T? newValue) {
    if (newValue != null && newValue != sortOption) {
      setState(() {
        sortOption = newValue;
        widget.onSortChanged(newValue);
      });
    }
  }
}
