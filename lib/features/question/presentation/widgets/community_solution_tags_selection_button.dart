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

  Future<void> _showTagSelectionSheet(
    BuildContext context,
    ValueNotifier<Set<SolutionTag>> selectedLanguageTags,
    ValueNotifier<Set<SolutionTag>> selectedKnowledgeTags,
  ) async {
    final result = await showModalBottomSheet<
        ({Set<SolutionTag> languageTags, Set<SolutionTag> knowledgeTags})>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return TagSelectionBottomSheet(
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
      onTap: () => _showTagSelectionSheet(
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

class TagSelectionBottomSheet extends StatefulWidget {
  final Set<SolutionTag> knowledgeTags;
  final Set<SolutionTag> languageTags;
  final Set<SolutionTag> selectedLanguageTags;
  final Set<SolutionTag> selectedKnowledgeTags;

  const TagSelectionBottomSheet({
    super.key,
    required this.knowledgeTags,
    required this.languageTags,
    required this.selectedLanguageTags,
    required this.selectedKnowledgeTags,
  });

  @override
  TagSelectionBottomSheetState createState() => TagSelectionBottomSheetState();
}

class TagSelectionBottomSheetState extends State<TagSelectionBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Set<SolutionTag> _tempSelectedLanguageTags;
  late Set<SolutionTag> _tempSelectedKnowledgeTags;
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    _tempSelectedLanguageTags =
        Set<SolutionTag>.from(widget.selectedLanguageTags);
    _tempSelectedKnowledgeTags =
        Set<SolutionTag>.from(widget.selectedKnowledgeTags);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<SolutionTag> _filterTags(Set<SolutionTag> tags) {
    if (_searchQuery.isEmpty) return tags.toList();
    return tags
        .where((tag) =>
            tag.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
            false)
        .toList();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search tags...',
            prefixIcon: const Icon(Icons.search, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Widget _buildTagsGrid(List<SolutionTag> tags, Set<SolutionTag> selectedTags,
      Function(SolutionTag) onToggle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: tags
            .map((tag) =>
                _buildTagChip(tag, selectedTags.contains(tag), onToggle))
            .toList(),
      ),
    );
  }

  Widget _buildTagChip(
      SolutionTag tag, bool isSelected, Function(SolutionTag) onToggle) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => onToggle(tag),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.1)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? theme.primaryColor : theme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tag.name ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? theme.primaryColor
                    : theme.textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.primaryColor
                    : theme.dividerColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                tag.count.toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  color: isSelected ? theme.colorScheme.onPrimary : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          TabBar(
            controller: _tabController,
            labelStyle: theme.textTheme.labelMedium,
            splashBorderRadius:
                const BorderRadius.vertical(top: const Radius.circular(20)),
            dividerHeight: 0,
            tabs: const [
              Tab(text: 'Topics'),
              Tab(text: 'Languages'),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          _buildSearchBar(),
          const SizedBox(
            height: 8,
          ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: _buildTagsGrid(
                      _filterTags(widget.knowledgeTags),
                      _tempSelectedKnowledgeTags,
                      _toggleKnowledgeTag,
                    ),
                  ),
                  SingleChildScrollView(
                    child: _buildTagsGrid(
                      _filterTags(widget.languageTags),
                      _tempSelectedLanguageTags,
                      _toggleLanguageTag,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(
                        (
                          languageTags: _tempSelectedLanguageTags,
                          knowledgeTags: _tempSelectedKnowledgeTags,
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
}
