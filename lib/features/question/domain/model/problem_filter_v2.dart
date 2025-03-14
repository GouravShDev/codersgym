import 'package:equatable/equatable.dart';

enum FilterCombineType { ALL, ANY }

enum FilterOperator { IS, IS_NOT }

class ProblemFilterV2 extends Equatable {
  final FilterCombineType? filterCombineType;
  final StatusFilter? statusFilter;
  final DifficultyFilter? difficultyFilter;
  final LanguageFilter? languageFilter;
  final TopicFilter? topicFilter;
  final CompanyFilter? companyFilter;
  final PositionFilter? positionFilter;
  final PremiumFilter? premiumFilter;

  const ProblemFilterV2({
    this.filterCombineType,
    this.statusFilter,
    this.difficultyFilter,
    this.languageFilter,
    this.topicFilter,
    this.companyFilter,
    this.positionFilter,
    this.premiumFilter,
  });

  factory ProblemFilterV2.fromJson(Map<String, dynamic> json) {
    return ProblemFilterV2(
      filterCombineType: json['filterCombineType'] != null
          ? FilterCombineType.values.firstWhere(
              (e) => e.toString().split('.').last == json['filterCombineType'],
              orElse: () => FilterCombineType.ALL)
          : null,
      statusFilter: json['statusFilter'] != null
          ? StatusFilter.fromJson(json['statusFilter'])
          : null,
      difficultyFilter: json['difficultyFilter'] != null
          ? DifficultyFilter.fromJson(json['difficultyFilter'])
          : null,
      languageFilter: json['languageFilter'] != null
          ? LanguageFilter.fromJson(json['languageFilter'])
          : null,
      topicFilter: json['topicFilter'] != null
          ? TopicFilter.fromJson(json['topicFilter'])
          : null,
      companyFilter: json['companyFilter'] != null
          ? CompanyFilter.fromJson(json['companyFilter'])
          : null,
      positionFilter: json['positionFilter'] != null
          ? PositionFilter.fromJson(json['positionFilter'])
          : null,
      premiumFilter: json['premiumFilter'] != null
          ? PremiumFilter.fromJson(json['premiumFilter'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (filterCombineType != null)
          'filterCombineType': filterCombineType?.toString().split('.').last,
        if (statusFilter != null) 'statusFilter': statusFilter?.toJson(),
        if (difficultyFilter != null)
          'difficultyFilter': difficultyFilter?.toJson(),
        if (languageFilter != null) 'languageFilter': languageFilter?.toJson(),
        if (topicFilter != null) 'topicFilter': topicFilter?.toJson(),
        if (companyFilter != null) 'companyFilter': companyFilter?.toJson(),
        if (positionFilter != null) 'positionFilter': positionFilter?.toJson(),
        if (premiumFilter != null) 'premiumFilter': premiumFilter?.toJson(),
      };

  @override
  List<Object?> get props => [
        filterCombineType,
        statusFilter,
        difficultyFilter,
        languageFilter,
        topicFilter,
        companyFilter,
        positionFilter,
        premiumFilter,
      ];
}

class StatusFilter {
  final List<String>? questionStatuses;
  final FilterOperator? operator;

  StatusFilter({this.questionStatuses, this.operator});

  factory StatusFilter.fromJson(Map<String, dynamic> json) {
    return StatusFilter(
      questionStatuses: json['questionStatuses'] != null
          ? List<String>.from(json['questionStatuses'])
          : null,
      operator: json['operator'] != null
          ? FilterOperator.values.firstWhere(
              (e) => e.toString().split('.').last == json['operator'],
              orElse: () => FilterOperator.IS)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'questionStatuses': questionStatuses,
        'operator': operator?.toString().split('.').last,
      };
}

class DifficultyFilter {
  final List<String>? difficulties;
  final FilterOperator? operator;

  DifficultyFilter({this.difficulties, this.operator});

  factory DifficultyFilter.fromJson(Map<String, dynamic> json) {
    return DifficultyFilter(
      difficulties: json['difficulties'] != null
          ? List<String>.from(json['difficulties'])
          : null,
      operator: json['operator'] != null
          ? FilterOperator.values.firstWhere(
              (e) => e.toString().split('.').last == json['operator'],
              orElse: () => FilterOperator.IS)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'difficulties': difficulties,
        'operator': operator?.toString().split('.').last,
      };
}

class LanguageFilter {
  final List<String>? languageSlugs;
  final FilterOperator? operator;

  LanguageFilter({this.languageSlugs, this.operator});

  factory LanguageFilter.fromJson(Map<String, dynamic> json) {
    return LanguageFilter(
      languageSlugs: json['languageSlugs'] != null
          ? List<String>.from(json['languageSlugs'])
          : null,
      operator: json['operator'] != null
          ? FilterOperator.values.firstWhere(
              (e) => e.toString().split('.').last == json['operator'],
              orElse: () => FilterOperator.IS)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'languageSlugs': languageSlugs,
        'operator': operator?.toString().split('.').last,
      };
}

class TopicFilter {
  final List<String>? topicSlugs;
  final FilterOperator? operator;

  TopicFilter({this.topicSlugs, this.operator});

  factory TopicFilter.fromJson(Map<String, dynamic> json) {
    return TopicFilter(
      topicSlugs: (json['topicSlugs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      operator: json['operator'] != null
          ? FilterOperator.values.firstWhere(
              (e) => e.toString().split('.').last == json['operator'],
              orElse: () => FilterOperator.IS,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'topicSlugs': topicSlugs,
        'operator': operator?.toString().split('.').last,
      };
}

class CompanyFilter {
  final List<String>? companySlugs;
  final FilterOperator? operator;

  CompanyFilter({this.companySlugs, this.operator});

  factory CompanyFilter.fromJson(Map<String, dynamic> json) {
    return CompanyFilter(
      companySlugs: (json['companySlugs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      operator: json['operator'] != null
          ? FilterOperator.values.firstWhere(
              (e) => e.toString().split('.').last == json['operator'],
              orElse: () => FilterOperator.IS,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'companySlugs': companySlugs,
        'operator': operator?.toString().split('.').last,
      };
}

class PositionFilter {
  final List<String> positionSlugs;
  final FilterOperator operator;

  PositionFilter({required this.positionSlugs, required this.operator});

  factory PositionFilter.fromJson(Map<String, dynamic> json) {
    return PositionFilter(
      positionSlugs: List<String>.from(json['positionSlugs'] ?? []),
      operator: FilterOperator.values.firstWhere(
          (e) => e.toString().split('.').last == json['operator'],
          orElse: () => FilterOperator.IS),
    );
  }

  Map<String, dynamic> toJson() => {
        'positionSlugs': positionSlugs,
        'operator': operator.toString().split('.').last,
      };
}

class PremiumFilter {
  final List<String> premiumStatus;
  final FilterOperator operator;

  PremiumFilter({required this.premiumStatus, required this.operator});

  factory PremiumFilter.fromJson(Map<String, dynamic> json) {
    return PremiumFilter(
      premiumStatus: List<String>.from(json['premiumStatus'] ?? []),
      operator: FilterOperator.values.firstWhere(
          (e) => e.toString().split('.').last == json['operator'],
          orElse: () => FilterOperator.IS),
    );
  }

  Map<String, dynamic> toJson() => {
        'premiumStatus': premiumStatus,
        'operator': operator.toString().split('.').last,
      };
}
