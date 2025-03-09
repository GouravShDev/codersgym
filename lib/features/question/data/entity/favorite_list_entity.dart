import 'package:codersgym/features/question/domain/model/favorite_problemset.dart';

class FavoriteListEntity {
  final List<FavoritesEntity> favorites;
  final bool hasMore;
  final int totalLength;

  FavoriteListEntity({
    required this.favorites,
    required this.hasMore,
    required this.totalLength,
  });

  factory FavoriteListEntity.fromJson(Map<String, dynamic> json) {
    return FavoriteListEntity(
      favorites: (json['favorites'] as List)
          .map((item) => FavoritesEntity.fromJson(item))
          .toList(),
      hasMore: json['hasMore'] ?? false,
      totalLength: json['totalLength'] ?? 0,
    );
  }
}

class FavoritesEntity {
  final String? coverUrl;
  final String? coverEmoji;
  final String? coverBackgroundColor;
  final bool hasCurrentQuestion;
  final bool isPublicFavorite;
  final String? lastQuestionAddedAt;
  final String name;
  final String slug;
  final String favoriteType;

  FavoritesEntity({
    this.coverUrl,
    this.coverEmoji,
    this.coverBackgroundColor,
    required this.hasCurrentQuestion,
    required this.isPublicFavorite,
    this.lastQuestionAddedAt,
    required this.name,
    required this.slug,
    required this.favoriteType,
  });

  factory FavoritesEntity.fromJson(Map<String, dynamic> json) {
    return FavoritesEntity(
      coverUrl: json['coverUrl'],
      coverEmoji: json['coverEmoji'],
      coverBackgroundColor: json['coverBackgroundColor'],
      hasCurrentQuestion: json['hasCurrentQuestion'] ?? false,
      isPublicFavorite: json['isPublicFavorite'] ?? false,
      lastQuestionAddedAt: json['lastQuestionAddedAt'],
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      favoriteType: json['favoriteType'] ?? 'NORMAL',
    );
  }
}

extension FavoriteListEntityExt on FavoritesEntity {
  FavoriteProblemset toFavoriteProblemSet() {
    return FavoriteProblemset(
      coverUrl: coverUrl,
      coverEmoji: coverEmoji,
      coverBackgroundColor: coverBackgroundColor,
      hasCurrentQuestion: hasCurrentQuestion,
      isPublicFavorite: isPublicFavorite,
      lastQuestionAddedAt: lastQuestionAddedAt,
      name: name,
      slug: slug,
      favoriteType: favoriteType,
    );
  }
}
