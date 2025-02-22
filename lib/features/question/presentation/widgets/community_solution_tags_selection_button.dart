import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CommunitySolutionTagsSelectionButton extends HookWidget {
  const CommunitySolutionTagsSelectionButton({
    super.key,
    required this.initialLanguageTags,
    required this.initialKnowledgeTags,
    required this.onTagsSelected,
    required this.knowledgeTags,
    required this.languageTags,
  });

  final Set<SolutionTag> initialKnowledgeTags;
  final Set<SolutionTag> initialLanguageTags;
  final Function(Set<SolutionTag> languageTags, Set<SolutionTag> knowledgeTags)
      onTagsSelected;
  final Set<SolutionTag> knowledgeTags;
  final Set<SolutionTag> languageTags;

  Future<void> _showTagSelectionDialog(
    BuildContext context,
    ValueNotifier<Set<SolutionTag>> selectedLanguageTags,
    ValueNotifier<Set<SolutionTag>> selectedKnowledgeTags,
  ) async {
    final result = await showDialog<
        ({Set<SolutionTag> languageTags, Set<SolutionTag> knowledgeTags})>(
      context: context,
      builder: (BuildContext context) {
        return TagSelectionDialog(
          knowledgeTags: knowledgeTags,
          languageTags: languageTags,
          selectedLanguageTags: selectedLanguageTags.value,
          selectedKnowledgeTags: selectedKnowledgeTags.value,
        );
      },
    );

    if (result != null) {
      selectedLanguageTags.value = result.languageTags;
      selectedKnowledgeTags.value = result.knowledgeTags;
      onTagsSelected(result.languageTags, result.knowledgeTags);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedLanguageTags =
        useState<Set<SolutionTag>>(initialLanguageTags);
    final selectedKnowledgeTags =
        useState<Set<SolutionTag>>(initialKnowledgeTags);
    final totalCount =
        selectedKnowledgeTags.value.length + selectedLanguageTags.value.length;

    return InkWell(
      onTap: () => _showTagSelectionDialog(
        context,
        selectedLanguageTags,
        selectedKnowledgeTags,
      ),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
        ),
        child: Icon(
          Icons.tag,
          size: 18,
          color: totalCount > 0 ? Theme.of(context).primaryColor : null,
        ),
      ),
    );
  }
}

class TagSelectionDialog extends StatefulWidget {
  final Set<SolutionTag> knowledgeTags;
  final Set<SolutionTag> languageTags;
  final Set<SolutionTag> selectedLanguageTags;
  final Set<SolutionTag> selectedKnowledgeTags;

  const TagSelectionDialog({
    super.key,
    required this.knowledgeTags,
    required this.languageTags,
    required this.selectedLanguageTags,
    required this.selectedKnowledgeTags,
  });

  @override
  TagSelectionDialogState createState() => TagSelectionDialogState();
}

class TagSelectionDialogState extends State<TagSelectionDialog> {
  late Set<SolutionTag> _tempSelectedLanguageTags;
  late Set<SolutionTag> _tempSelectedKnowledgeTags;

  @override
  void initState() {
    super.initState();
    _tempSelectedLanguageTags =
        Set<SolutionTag>.from(widget.selectedLanguageTags);
    _tempSelectedKnowledgeTags =
        Set<SolutionTag>.from(widget.selectedKnowledgeTags);
  }

  Widget _buildTagSection(String title, Set<SolutionTag> tags,
      Set<SolutionTag> selectedTags, Function(SolutionTag) onTagToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          width: double.maxFinite,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map((tag) =>
                    _buildTagChip(tag, selectedTags.contains(tag), onTagToggle))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTagChip(
      SolutionTag tag, bool isSelected, Function(SolutionTag) onToggle) {
    return GestureDetector(
      onTap: () => onToggle(tag),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tag.name ?? '',
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black26 : Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tag.count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleKnowledgeTag(SolutionTag tag) {
    setState(() {
      if (_tempSelectedKnowledgeTags.contains(tag)) {
        _tempSelectedKnowledgeTags.remove(tag);
      } else {
        _tempSelectedKnowledgeTags.add(tag);
      }
    });
  }

  void _toggleLanguageTag(SolutionTag tag) {
    setState(() {
      if (_tempSelectedLanguageTags.contains(tag)) {
        _tempSelectedLanguageTags.remove(tag);
      } else {
        _tempSelectedLanguageTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child:
            Text('Select Tags', style: Theme.of(context).textTheme.titleLarge),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTagSection(
                'Knowledge Areas',
                widget.knowledgeTags,
                _tempSelectedKnowledgeTags,
                _toggleKnowledgeTag,
              ),
              const Divider(height: 32, thickness: 1),
              _buildTagSection(
                'Programming Languages',
                widget.languageTags,
                _tempSelectedLanguageTags,
                _toggleLanguageTag,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(
            (
              languageTags: _tempSelectedLanguageTags,
              knowledgeTags: _tempSelectedKnowledgeTags,
            ),
          ),
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
