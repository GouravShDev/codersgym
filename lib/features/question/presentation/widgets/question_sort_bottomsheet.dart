import 'dart:developer';

import 'package:codersgym/features/question/domain/model/problem_sort_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuestionSortBottomsheet extends HookWidget {
  const QuestionSortBottomsheet({
    super.key,
    this.initialValue,
  });
  final ProblemSortOption? initialValue;
  @override
  Widget build(BuildContext context) {
    final selectedSortOption = useState<ProblemSortOption?>(initialValue);
    final isAscending = useState<bool>(true);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(initialValue);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sort by",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      selectedSortOption.value = null;
                    },
                    child: Text(
                      "Reset",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  )
                ],
              ),
            ),
            _buildSortOption(
              context,
              'ID',
              Icons.numbers,
              selectedSortOption.value,
              ProblemSortOption.idAsc,
              ProblemSortOption.idDesc,
              selectedSortOption,
              isAscending,
            ),
            _buildSortOption(
              context,
              'Acceptance',
              Icons.percent,
              selectedSortOption.value,
              ProblemSortOption.acceptanceRateAsc,
              ProblemSortOption.acceptanceRateDesc,
              selectedSortOption,
              isAscending,
            ),
            _buildSortOption(
              context,
              'Difficulty',
              Icons.bar_chart,
              selectedSortOption.value,
              ProblemSortOption.difficultyAsc,
              ProblemSortOption.difficultyDesc,
              selectedSortOption,
              isAscending,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, initialValue);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, selectedSortOption.value);
                  },
                  child: const Text("Apply"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String label,
    IconData icon,
    ProblemSortOption? selectedOption,
    ProblemSortOption ascOption,
    ProblemSortOption descOption,
    ValueNotifier<ProblemSortOption?> selectedSortOption,
    ValueNotifier<bool> isAscending,
  ) {
    bool isSelected =
        selectedOption == ascOption || selectedOption == descOption;

    return ListTile(
      leading: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(label),
      trailing: isSelected
          ? Icon(
              isAscending.value ? Icons.arrow_upward : Icons.arrow_downward,
            )
          : null,
      onTap: () {
        if (selectedOption == ascOption) {
          selectedSortOption.value = descOption;
          isAscending.value = false;
        } else {
          selectedSortOption.value = ascOption;
          isAscending.value = true;
        }
      },
    );
  }
}
