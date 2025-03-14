import 'package:codersgym/core/theme/app_theme.dart';
import 'package:codersgym/features/question/data/local/question_topics.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicTagsSelectionDialogButton extends HookWidget {
  const TopicTagsSelectionDialogButton({
    super.key,
    this.initialValue,
    required this.onTopicTagsSelected,
  });
  final Set<TopicTags>? initialValue;
  final Function(Set<TopicTags> selectedTags) onTopicTagsSelected;

  void _showTagSelectionDialog(
      BuildContext context, ValueNotifier<Set<TopicTags>?> selectedTags) async {
    Set<TopicTags>? result = await showDialog<Set<TopicTags>>(
      context: context,
      builder: (BuildContext context) {
        return TopicTagSelectionDialog(
          allTags: allTopicTags,
          selectedTags: selectedTags.value,
        );
      },
    );
    if (result != null) {
      selectedTags.value = result;
      onTopicTagsSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTags = useState<Set<TopicTags>?>(initialValue);
    final currentTags = selectedTags.value;
    return InkWell(
      onTap: () => _showTagSelectionDialog(context, selectedTags),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          children: [
            Icon(
              Icons.label_outline,
              size: 18,
              color: currentTags?.isNotEmpty ?? false
                  ? Theme.of(context).primaryColor
                  : null,
            ),
            const SizedBox(width: 6),
            Text(
              'Topics ${currentTags?.isNotEmpty ?? false ? "(${currentTags!.length})" : ''}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopicTagSelectionDialog extends StatefulWidget {
  final List<TopicTags> allTags;
  final Set<TopicTags>? selectedTags;

  const TopicTagSelectionDialog({
    super.key,
    required this.allTags,
    required this.selectedTags,
  });

  @override
  TopicTagSelectionDialogState createState() => TopicTagSelectionDialogState();
}

class TopicTagSelectionDialogState extends State<TopicTagSelectionDialog> {
  late TextEditingController _searchController;
  late Set<TopicTags> _tempSelectedTags;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _tempSelectedTags = Set<TopicTags>.from(widget.selectedTags ?? {});
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TopicTags> filteredTags = widget.allTags
        .where(
          (tag) =>
              (tag.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                  false) ||
              _tempSelectedTags.contains(tag),
        )
        .toList();

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Theme(
            data: leetcodeTheme,
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search tags...',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Wrap(
                    spacing: 8, // Space between chips
                    runSpacing: 8, // Space between lines
                    children: filteredTags.map((tag) {
                      final isSelected = _tempSelectedTags.contains(tag);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _tempSelectedTags.remove(tag);
                            } else {
                              _tempSelectedTags.add(tag);
                            }
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).focusColor,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Theme.of(context).cardColor,
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            tag.name ?? '',
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_tempSelectedTags);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
