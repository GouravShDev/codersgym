part of 'favorite_quesions_list_bloc.dart';

class FavoriteQuesionsListState extends Equatable {
  final List<Question> questions;
  final bool isLoading;
  final Exception? error;
  final bool moreQuestionAvailable;
  const FavoriteQuesionsListState({
    required this.questions,
    required this.isLoading,
    required this.error,
    required this.moreQuestionAvailable,
  });

  factory FavoriteQuesionsListState.initial() {
    return const FavoriteQuesionsListState(
      questions: [],
      isLoading: false,
      error: null,
      moreQuestionAvailable: true,
    );
  }
  FavoriteQuesionsListState copyWith({
    List<Question>? questions,
    bool? isLoading,
    Exception? error,
    bool? moreQuestionAvailable,
  }) {
    return FavoriteQuesionsListState(
      questions: questions ?? this.questions,
      isLoading: isLoading ?? this.isLoading,
      error:
          error, // We want to ovveride error object when new state is emitted
      moreQuestionAvailable:
          moreQuestionAvailable ?? this.moreQuestionAvailable,
    );
  }

  @override
  List<Object?> get props =>
      [questions, isLoading, error, moreQuestionAvailable];

  factory FavoriteQuesionsListState.fromJson(Map<String, dynamic> json) {
    return FavoriteQuesionsListState(
      questions: (json['questions'] as List<dynamic>)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
      isLoading: false,
      error: null,
      moreQuestionAvailable: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}
