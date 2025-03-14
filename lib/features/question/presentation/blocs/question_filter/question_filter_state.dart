part of 'question_filter_cubit.dart';

class QuestionFilterState extends Equatable {
  final ProblemSortOption? sortOption;
  final String? difficulty;
  final Set<TopicTags>? topicTags;
  final bool hideSolved;

  const QuestionFilterState({
    this.sortOption,
    this.difficulty,
    this.topicTags,
    this.hideSolved = false,
  });

  QuestionFilterState copyWith({
    ProblemSortOption? sortOption,
    String? difficulty,
    Set<TopicTags>? topicTags,
    bool? hideSolved,
  }) {
    return QuestionFilterState(
      sortOption: sortOption ?? this.sortOption,
      difficulty: difficulty ?? this.difficulty,
      topicTags: topicTags ?? this.topicTags,
      hideSolved: hideSolved ?? this.hideSolved,
    );
  }

  @override
  List<Object?> get props => [
        sortOption,
        difficulty,
        topicTags,
        hideSolved,
      ];
}
