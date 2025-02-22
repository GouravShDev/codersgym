import 'dart:math';

import 'package:codersgym/features/question/data/entity/community_solution_sort_option.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:codersgym/features/question/presentation/widgets/community_solution_sort_option_dropdown.dart';
import 'package:codersgym/features/question/presentation/widgets/community_solution_tags_selection_button.dart';
import 'package:flutter/material.dart';

class SolutionFilterSearchBar extends StatefulWidget {
  final Set<SolutionTag> initialKnowledgeTags;
  final Set<SolutionTag> availableKnowledgeTags;
  final Set<SolutionTag> initialLanguageTags;
  final Set<SolutionTag> availableLanguageTags;
  final String initialSearchQuery;
  final CommunitySolutionSortOption initialSortOption;
  final Function({
    required Set<SolutionTag> topicTags,
    required Set<SolutionTag> languageTags,
    required String searchQuery,
    required CommunitySolutionSortOption sortOption,
  }) onFiltersChanged;

  const SolutionFilterSearchBar({
    super.key,
    required this.availableKnowledgeTags,
    required this.availableLanguageTags,
    this.initialKnowledgeTags = const {},
    this.initialLanguageTags = const {},
    this.initialSearchQuery = '',
    required this.initialSortOption,
    required this.onFiltersChanged,
  });

  @override
  _SolutionFilterSearchBarState createState() =>
      _SolutionFilterSearchBarState();
}

class _SolutionFilterSearchBarState extends State<SolutionFilterSearchBar> {
  late ValueNotifier<Set<SolutionTag>> selectedKnowledgeTags;
  late ValueNotifier<Set<SolutionTag>> selectedLanguageTags;
  late String searchQuery;
  late CommunitySolutionSortOption sortOption;

  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    selectedKnowledgeTags =
        ValueNotifier(Set.from(widget.initialKnowledgeTags));
    selectedLanguageTags = ValueNotifier(Set.from(widget.initialLanguageTags));
    searchQuery = widget.initialSearchQuery;
    sortOption = widget.initialSortOption;
    _searchController = TextEditingController(text: widget.initialSearchQuery);

    // Add listeners to value notifiers
    selectedKnowledgeTags.addListener(_notifyFiltersChanged);
    selectedLanguageTags.addListener(_notifyFiltersChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    selectedKnowledgeTags.dispose();
    selectedLanguageTags.dispose();
    super.dispose();
  }

  void _notifyFiltersChanged() {
    widget.onFiltersChanged(
      topicTags: selectedKnowledgeTags.value,
      languageTags: selectedLanguageTags.value,
      searchQuery: searchQuery,
      sortOption: sortOption,
    );
  }

  void _handleTagsSelected(
      Set<SolutionTag> languageTags, Set<SolutionTag> knowledgeTags) {
    selectedKnowledgeTags.value = knowledgeTags;
    selectedLanguageTags.value = languageTags;
  }

  void _handleSortChanged(CommunitySolutionSortOption newSortOption) {
    setState(() {
      sortOption = newSortOption;
      _notifyFiltersChanged();
    });
  }

  Widget _buildSelectedTagsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ValueListenableBuilder<Set<SolutionTag>>(
        valueListenable: selectedKnowledgeTags,
        builder: (context, knowledgeTags, _) {
          return ValueListenableBuilder<Set<SolutionTag>>(
            valueListenable: selectedLanguageTags,
            builder: (context, languageTags, __) {
              if (knowledgeTags.isEmpty && languageTags.isEmpty) {
                return const SizedBox.shrink();
              }

              final combinedTags = _interleaveTags(
                  knowledgeTags.toList(), languageTags.toList());

              return Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                child: Row(
                  children: combinedTags
                      .map((tag) =>
                          _buildTagChip(tag, languageTags.contains(tag)))
                      .toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<SolutionTag> _interleaveTags(
      List<SolutionTag> knowledgeList, List<SolutionTag> languageList) {
    final combinedTags = <SolutionTag>[];
    final maxLength = max(knowledgeList.length, languageList.length);

    for (int i = 0; i < maxLength; i++) {
      if (i < languageList.length) combinedTags.add(languageList[i]);
      if (i < knowledgeList.length) combinedTags.add(knowledgeList[i]);
    }

    return combinedTags;
  }

  Widget _buildTagChip(SolutionTag tag, bool isLanguageTag) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Chip(
        label: Text(
          tag.name ?? '',
          style: const TextStyle(fontSize: 11),
        ),
        deleteIcon: const Icon(Icons.close, size: 14),
        onDeleted: () {
          if (isLanguageTag) {
            selectedLanguageTags.value = Set.from(selectedLanguageTags.value)
              ..remove(tag);
          } else {
            selectedKnowledgeTags.value = Set.from(selectedKnowledgeTags.value)
              ..remove(tag);
          }
        },
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                      _notifyFiltersChanged();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              ValueListenableBuilder<Set<SolutionTag>>(
                valueListenable: selectedKnowledgeTags,
                builder: (context, knowledgeTags, _) {
                  return ValueListenableBuilder<Set<SolutionTag>>(
                      valueListenable: selectedLanguageTags,
                      builder: (context, languageTags, __) {
                        return CommunitySolutionTagsSelectionButton(
                          key: ValueKey(
                            selectedKnowledgeTags.value.length +
                                selectedLanguageTags.value.length,
                          ),
                          initialKnowledgeTags: selectedKnowledgeTags.value,
                          initialLanguageTags: selectedLanguageTags.value,
                          knowledgeTags: widget.availableKnowledgeTags,
                          languageTags: widget.availableLanguageTags,
                          onTagsSelected: _handleTagsSelected,
                        );
                      });
                },
              ),
              const SizedBox(width: 8),
              CommunitySolutionSortOptionDropdown(
                initialSort: widget.initialSortOption,
                onSortChanged: _handleSortChanged,
              ),
            ],
          ),
        ),
        _buildSelectedTagsRow(),
      ],
    );
  }
}
