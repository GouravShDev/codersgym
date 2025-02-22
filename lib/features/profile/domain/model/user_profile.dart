import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String? username;
  final String? socialAccounts;
  final String? githubUrl;
  final int? points;
  final int? questionCount;
  final int? testcaseCount;
  final String? realName;
  final List<String>? websites;
  final String? countryName;
  final List<String>? skillTags;
  final String? company;
  final String? school;
  final double? starRating;
  final String? aboutMe;
  final String? userAvatar;
  final int? reputation;
  final int? ranking;
  final List<QuestionCount>? acSubmissionNum;
  final List<QuestionCount>? totalSubmissionNum;
  final List<QuestionCount>? allQuestionsCount;
  final List<LeetCodeBadge>? badges;
  final String? activeBadgeId;
  final StreakCounter? streakCounter;

  UserProfile({
    this.username,
    this.socialAccounts,
    this.githubUrl,
    this.points,
    this.questionCount,
    this.testcaseCount,
    this.realName,
    this.websites,
    this.countryName,
    this.skillTags,
    this.company,
    this.school,
    this.starRating,
    this.aboutMe,
    this.userAvatar,
    this.reputation,
    this.ranking,
    this.acSubmissionNum,
    this.totalSubmissionNum,
    this.allQuestionsCount,
    this.badges,
    this.activeBadgeId,
    this.streakCounter,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'],
      socialAccounts: json['socialAccounts'],
      githubUrl: json['githubUrl'],
      points: json['points'],
      questionCount: json['questionCount'],
      testcaseCount: json['testcaseCount'],
      realName: json['realName'],
      websites: (json['websites'] as List<dynamic>?)?.cast<String>(),
      countryName: json['countryName'],
      skillTags: (json['skillTags'] as List<dynamic>?)?.cast<String>(),
      company: json['company'],
      school: json['school'],
      starRating: (json['starRating'] as num?)?.toDouble(),
      aboutMe: json['aboutMe'],
      userAvatar: json['userAvatar'],
      reputation: json['reputation'],
      ranking: json['ranking'],
      acSubmissionNum: (json['acSubmissionNum'] as List<dynamic>?)
          ?.map((e) => QuestionCount.fromJson(e))
          .toList(),
      totalSubmissionNum: (json['totalSubmissionNum'] as List<dynamic>?)
          ?.map((e) => QuestionCount.fromJson(e))
          .toList(),
      allQuestionsCount: (json['allQuestionsCount'] as List<dynamic>?)
          ?.map((e) => QuestionCount.fromJson(e))
          .toList(),
      badges: (json['badges'] as List<dynamic>?)
          ?.map((e) => LeetCodeBadge.fromJson(e))
          .toList(),
      activeBadgeId: json['activeBadgeId'],
      streakCounter: json['streakCounter'] != null
          ? StreakCounter.fromJson(json['streakCounter'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'socialAccounts': socialAccounts,
      'githubUrl': githubUrl,
      'points': points,
      'questionCount': questionCount,
      'testcaseCount': testcaseCount,
      'realName': realName,
      'websites': websites,
      'countryName': countryName,
      'skillTags': skillTags,
      'company': company,
      'school': school,
      'starRating': starRating,
      'aboutMe': aboutMe,
      'userAvatar': userAvatar,
      'reputation': reputation,
      'ranking': ranking,
      'acSubmissionNum': acSubmissionNum?.map((e) => e.toJson()).toList(),
      'totalSubmissionNum': totalSubmissionNum?.map((e) => e.toJson()).toList(),
      'allQuestionsCount': allQuestionsCount?.map((e) => e.toJson()).toList(),
      'badges': badges?.map((e) => e.toJson()).toList(),
      'activeBadgeId': activeBadgeId,
      'streakCounter': streakCounter?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        username,
        socialAccounts,
        githubUrl,
        points,
        questionCount,
        testcaseCount,
        realName,
        websites,
        countryName,
        skillTags,
        company,
        school,
        starRating,
        aboutMe,
        userAvatar,
        reputation,
        ranking,
        acSubmissionNum,
        totalSubmissionNum,
        allQuestionsCount,
        badges,
        activeBadgeId,
        streakCounter,
      ];
}

class QuestionCount extends Equatable {
  int? count;
  String? difficulty;

  QuestionCount({this.count, this.difficulty});

  factory QuestionCount.fromJson(Map<String, dynamic> json) {
    return QuestionCount(
      count: json['count'],
      difficulty: json['difficulty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'difficulty': difficulty,
    };
  }

  @override
  List<Object?> get props => [count, difficulty];
}

class LeetCodeBadge extends Equatable {
  final String? id;
  final String? displayName;
  final String? icon;

  LeetCodeBadge({
    required this.id,
    required this.displayName,
    required this.icon,
  });

  factory LeetCodeBadge.fromJson(Map<String, dynamic> json) {
    return LeetCodeBadge(
      id: json['id'],
      displayName: json['displayName'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'icon': icon,
    };
  }

  @override
  List<Object?> get props => [id, displayName, icon];
}


class StreakCounter extends Equatable {
  final int streakCount;
  final int daysSkipped;
  final bool currentDayCompleted;

  StreakCounter({
    required this.streakCount,
    required this.daysSkipped,
    required this.currentDayCompleted,
  });

  factory StreakCounter.fromJson(Map<String, dynamic> json) {
    return StreakCounter(
      streakCount: json['streakCount'] ?? 0,
      daysSkipped: json['daysSkipped'] ?? 0,
      currentDayCompleted: json['currentDayCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'streakCount': streakCount,
      'daysSkipped': daysSkipped,
      'currentDayCompleted': currentDayCompleted,
    };
  }

  @override
  List<Object?> get props => [streakCount, daysSkipped, currentDayCompleted];
}

extension UserProfileExt on UserProfile {
  UserProfileQuestionsStats get questionsStats {
    final easySolved = acSubmissionNum
            ?.firstWhereOrNull(
              (element) => element.difficulty == 'Easy',
            )
            ?.count ??
        0;
    final mediumSolved = acSubmissionNum
            ?.firstWhereOrNull(
              (element) => element.difficulty == 'Medium',
            )
            ?.count ??
        0;
    final hardSolved = acSubmissionNum
            ?.firstWhereOrNull(
              (element) => element.difficulty == 'Hard',
            )
            ?.count ??
        0;
    final totalEasy = allQuestionsCount
            ?.firstWhereOrNull(
              (element) => element.difficulty == 'Easy',
            )
            ?.count ??
        0;
    final totalMedium = allQuestionsCount
            ?.firstWhereOrNull(
              (element) => element.difficulty == 'Medium',
            )
            ?.count ??
        0;

    final totalHard = allQuestionsCount
            ?.firstWhereOrNull(
              (element) => element.difficulty == 'Hard',
            )
            ?.count ??
        0;
    return UserProfileQuestionsStats(
      easySolved: easySolved,
      mediumSolved: mediumSolved,
      hardSolved: hardSolved,
      totalEasy: totalEasy,
      totalMedium: totalMedium,
      totalHard: totalHard,
    );
  }
}

class UserProfileQuestionsStats extends Equatable {
  final int easySolved;
  final int mediumSolved;
  final int hardSolved;
  final int totalEasy;
  final int totalMedium;
  final int totalHard;

  UserProfileQuestionsStats({
    required this.easySolved,
    required this.mediumSolved,
    required this.hardSolved,
    required this.totalEasy,
    required this.totalMedium,
    required this.totalHard,
  });
  @override
  List<Object?> get props => [
        easySolved,
        mediumSolved,
        hardSolved,
        totalEasy,
        totalMedium,
        totalHard,
      ];
}
