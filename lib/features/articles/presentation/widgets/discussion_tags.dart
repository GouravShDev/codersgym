import 'package:codersgym/features/common/data/models/tag.dart';
import 'package:flutter/material.dart';

class DiscussionTags extends StatefulWidget {
  final List<Tag> initialTags;
  final ValueChanged<Tag?> onTagSelected;

  const DiscussionTags({
    super.key,
    required this.initialTags,
    required this.onTagSelected,
  });

  @override
  State<DiscussionTags> createState() => _DiscussionTagsState();
}

class _DiscussionTagsState extends State<DiscussionTags> {
  Tag? _selectedTag;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.initialTags.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tag = widget.initialTags[index];
          final isSelected = tag == _selectedTag;
          return ChoiceChip(
            label: Text(tag.name ?? ''),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedTag = selected ? tag : null;
              });
              widget.onTagSelected(_selectedTag);
            },
            // You can customize the appearance here
          );
        },
      ),
    );
  }
}
