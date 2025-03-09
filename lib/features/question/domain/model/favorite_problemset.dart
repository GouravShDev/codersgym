class FavoriteProblemset {
  final String? coverUrl;
  final String? coverEmoji;
  final String? coverBackgroundColor;
  final bool hasCurrentQuestion;
  final bool isPublicFavorite;
  final String? lastQuestionAddedAt;
  final String name;
  final String slug;
  final String favoriteType;

  FavoriteProblemset({
    required this.coverUrl,
    required this.coverEmoji,
    required this.coverBackgroundColor,
    required this.hasCurrentQuestion,
    required this.isPublicFavorite,
    required this.lastQuestionAddedAt,
    required this.name,
    required this.slug,
    required this.favoriteType,
  });
}
