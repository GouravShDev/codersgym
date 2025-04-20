import 'package:codersgym/features/articles/domain/model/discussion_sort_option.dart';
import 'package:codersgym/features/common/widgets/app_sort_option_dropdown.dart';
import 'package:flutter/material.dart';

class DiscussionSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String)? onChanged;
  final DiscussionSortOption? initialSortOption;
  final void Function(DiscussionSortOption) onSortOptionChanged;

  const DiscussionSearchBar({
    super.key,
    required this.searchController,
    required this.initialSortOption,
    this.onChanged,
    required this.onSortOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: "Search discussions...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: ValueListenableBuilder(
                    valueListenable: searchController,
                    builder: (context, _, __) {
                      return searchController.text.isNotEmpty
                          ? InkWell(
                              onTap: () => searchController.clear(),
                              child: Icon(
                                Icons.clear_rounded,
                                color: Theme.of(context).hintColor,
                              ),
                            )
                          : const SizedBox.shrink();
                    }),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          AppSortOptionDropdown<DiscussionSortOption>(
            onSortChanged: onSortOptionChanged,
            initialSort: initialSortOption,
            sortOptions: DiscussionSortOption.options,
          )
        ],
      ),
    );
  }
}
