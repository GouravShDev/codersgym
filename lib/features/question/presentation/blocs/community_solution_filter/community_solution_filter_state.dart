part of 'community_solution_filter_cubit.dart';

class CommunitySolutionFilterState extends Equatable {
  const CommunitySolutionFilterState({
    required this.searchQuery,
    required this.sortOption,
    required this.selectedTopicTags,
    required this.selectedLanguageTags,
    required this.availableLanguageTags,
    required this.availableTopicTags,
    required this.isTagsLoading,
    this.error,
  });
  final String searchQuery;
  final CommunitySolutionSortOption sortOption;
  final List<SolutionTag> selectedLanguageTags;
  final List<SolutionTag> selectedTopicTags;
  final List<SolutionTag> availableLanguageTags;
  final List<SolutionTag> availableTopicTags;
  final bool isTagsLoading;
  final Exception? error;

  factory CommunitySolutionFilterState.initial() {
    final defaultSortOption = defaultCommunitySolutionSortOptions.firstWhere(
      (option) => option.type == CommunitySolutionSortOptionType.votes,
    );
    return CommunitySolutionFilterState(
      searchQuery: '',
      sortOption: defaultSortOption,
      selectedLanguageTags: const [],
      selectedTopicTags: const [],
      isTagsLoading: true,
      availableLanguageTags: const [],
      availableTopicTags: const [],
    );
  }
  CommunitySolutionFilterState copyWith({
    String? searchQuery,
    CommunitySolutionSortOption? sortOption,
    List<SolutionTag>? selectedLanguageTags,
    List<SolutionTag>? selectedTopicTags,
    bool? isTagsLoading,
    List<SolutionTag>? availableLanguageTags,
    List<SolutionTag>? availableTopicTags,
    Exception? error,
  }) {
    return CommunitySolutionFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      selectedLanguageTags: selectedLanguageTags ?? this.selectedLanguageTags,
      selectedTopicTags: selectedTopicTags ?? this.selectedTopicTags,
      isTagsLoading: isTagsLoading ?? this.isTagsLoading,
      availableLanguageTags:
          availableLanguageTags ?? this.availableLanguageTags,
      availableTopicTags: availableTopicTags ?? this.availableTopicTags,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        searchQuery,
        sortOption,
        selectedLanguageTags,
        selectedTopicTags,
        isTagsLoading,
        availableLanguageTags,
        availableTopicTags,
        error,
      ];
}
