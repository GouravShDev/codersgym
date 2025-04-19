import 'package:flutter/material.dart';

class DiscussionSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String) onChanged;

  const DiscussionSearchBar({
    super.key,
    required this.searchController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "Search discussions...",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}