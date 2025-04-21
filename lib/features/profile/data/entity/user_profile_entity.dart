import 'package:codersgym/features/profile/domain/model/user_profile.dart';

class UserProfileEntity {
  List<AllQuestionsCountNode>? allQuestionsCount;
  MatchedUserNode? matchedUser;
  StreakCounterNode? streakCounter;
  UserProfileEntity({
    this.allQuestionsCount,
    this.matchedUser,
    this.streakCounter,
  });

  factory UserProfileEntity.fromJson(Map<String, dynamic> json) {
    return UserProfileEntity(
      allQuestionsCount: (json['allQuestionsCount'] as List?)
          ?.map((item) => AllQuestionsCountNode.fromJson(item))
          .toList(),
      matchedUser: json['matchedUser'] != null
          ? MatchedUserNode.fromJson(json['matchedUser'])
          : null,
      streakCounter: json['streakCounter'] != null
          ? StreakCounterNode.fromJson(json['streakCounter'])
          : null,
    );
  }
}

class AllQuestionsCountNode {
  int? count;
  String? difficulty;

  AllQuestionsCountNode({this.count, this.difficulty});

  factory AllQuestionsCountNode.fromJson(Map<String, dynamic> json) {
    return AllQuestionsCountNode(
      count: json['count'],
      difficulty: json['difficulty'],
    );
  }
}

class MatchedUserNode {
  String? username;
  String? socialAccounts;
  String? githubUrl;
  ContributionsNode? contributions;
  String? submissionCalendar;
  ProfileNode? profile;
  SubmitStatsNode? submitStats;
  List<BadgeNode>? badges;
  String? activeBadgeId;

  MatchedUserNode({
    this.username,
    this.socialAccounts,
    this.githubUrl,
    this.contributions,
    this.submissionCalendar,
    this.profile,
    this.submitStats,
    this.badges,
    this.activeBadgeId,
  });

  factory MatchedUserNode.fromJson(Map<String, dynamic> json) {
    return MatchedUserNode(
      username: json['username'],
      githubUrl: json['githubUrl'],
      contributions: json['contributions'] != null
          ? ContributionsNode.fromJson(json['contributions'])
          : null,
      submissionCalendar: json['submissionCalendar'],
      profile: json['profile'] != null
          ? ProfileNode.fromJson(json['profile'])
          : null,
      submitStats: json['submitStats'] != null
          ? SubmitStatsNode.fromJson(json['submitStats'])
          : null,
      badges: json['badges'] != null
          ? (json['badges'] as List?)
              ?.map(
                (e) => BadgeNode.fromJson(e),
              )
              .toList()
          : null,
      activeBadgeId: json['activeBadge']?['id'],
    );
  }
}

class ContributionsNode {
  int points;
  int questionCount;
  int testcaseCount;
  ProfileNode? profile;

  ContributionsNode({
    required this.points,
    required this.questionCount,
    required this.testcaseCount,
    this.profile,
  });

  factory ContributionsNode.fromJson(Map<String, dynamic> json) {
    return ContributionsNode(
      points: json['points'],
      questionCount: json['questionCount'],
      testcaseCount: json['testcaseCount'],
      profile: json['profile'] != null
          ? ProfileNode.fromJson(json['profile'])
          : null,
    );
  }
}

class ProfileNode {
  String? realName;
  String? countryName;
  List<String>? websites;
  List<String>? skillTags;
  String? company;
  String? school;
  double? starRating;
  String? aboutMe;
  String? userAvatar;
  int? reputation;
  int? ranking;
  SubmitStatsNode? submitStats;

  ProfileNode({
    this.realName,
    this.countryName,
    this.websites,
    this.skillTags,
    this.company,
    this.school,
    this.starRating,
    this.aboutMe,
    this.userAvatar,
    this.reputation,
    this.ranking,
    this.submitStats,
  });

  factory ProfileNode.fromJson(Map<String, dynamic> json) {
    return ProfileNode(
      realName: json['realName'],
      countryName: json['countryName'],
      websites: List<String>.from(json['websites'] ?? []),
      skillTags: List<String>.from(json['skillTags'] ?? []),
      company: json['company'],
      school: json['school'],
      starRating: json['starRating'],
      aboutMe: json['aboutMe'],
      userAvatar: json['userAvatar'],
      reputation: json['reputation'],
      ranking: json['ranking'],
      submitStats: json['submitStats'] != null
          ? SubmitStatsNode.fromJson(json['submitStats'])
          : null,
    );
  }
}

class SubmitStatsNode {
  List<AcSubmissionNumNode>? acSubmissionNum;
  List<AcSubmissionNumNode>? totalSubmissionNum;

  SubmitStatsNode({this.acSubmissionNum, this.totalSubmissionNum});

  factory SubmitStatsNode.fromJson(Map<String, dynamic> json) {
    return SubmitStatsNode(
      acSubmissionNum: (json['acSubmissionNum'] as List?)
          ?.map((item) => AcSubmissionNumNode.fromJson(item))
          .toList(),
      totalSubmissionNum: (json['totalSubmissionNum'] as List?)
          ?.map((item) => AcSubmissionNumNode.fromJson(item))
          .toList(),
    );
  }
}

class AcSubmissionNumNode {
  int? count;
  String? difficulty;
  int? submissions;

  AcSubmissionNumNode({this.count, this.difficulty, this.submissions});

  factory AcSubmissionNumNode.fromJson(Map<String, dynamic> json) {
    return AcSubmissionNumNode(
      count: json['count'],
      difficulty: json['difficulty'],
      submissions: json['submissions'],
    );
  }
}

class BadgeNode {
  String? id;
  String? displayName;
  String? icon;
  BadgeNode({this.id, this.displayName, this.icon});

  factory BadgeNode.fromJson(Map<String, dynamic> json) {
    return BadgeNode(
      id: json['id'],
      displayName: json['displayName'],
      icon: json['icon'],
    );
  }
}

extension UserProfileModelConversion on UserProfileEntity {
  UserProfile toUserProfile() {
    final profile = matchedUser?.profile;
    final submitStats = matchedUser?.submitStats;

    return UserProfile(
      username: matchedUser?.username,
      socialAccounts: matchedUser?.socialAccounts,
      githubUrl: matchedUser?.githubUrl,
      points: matchedUser?.contributions?.points,
      questionCount: matchedUser?.contributions?.questionCount,
      testcaseCount: matchedUser?.contributions?.testcaseCount,
      realName: profile?.realName,
      websites: profile?.websites,
      countryName: profile?.countryName,
      skillTags: profile?.skillTags,
      company: profile?.company,
      school: profile?.school,
      starRating: profile?.starRating,
      aboutMe: profile?.aboutMe,
      userAvatar: profile?.userAvatar,
      reputation: profile?.reputation,
      ranking: profile?.ranking,
      acSubmissionNum: submitStats?.acSubmissionNum
          ?.map((acStat) => acStat.toQuestionCount())
          .toList(),
      totalSubmissionNum: submitStats?.totalSubmissionNum
          ?.map((totalStat) => totalStat.toQuestionCount())
          .toList(),
      allQuestionsCount: allQuestionsCount
          ?.map((questionCount) => questionCount.toQuestionCount())
          .toList(),
      badges: matchedUser?.badges
          ?.map(
            (e) => e.toBadge(),
          )
          .toList(),
      activeBadgeId: matchedUser?.activeBadgeId,
      streakCounter: streakCounter?.toStreakCounter(),
    );
  }
}

class StreakCounterNode {
  final int streakCount;
  final int daysSkipped;
  final bool currentDayCompleted;

  StreakCounterNode({
    required this.streakCount,
    required this.daysSkipped,
    required this.currentDayCompleted,
  });

  factory StreakCounterNode.fromJson(Map<String, dynamic> json) {
    return StreakCounterNode(
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
}

// Extension methods for converting nested classes
extension AllQuestionsCountNodeConversion on AllQuestionsCountNode {
  QuestionCount toQuestionCount() {
    return QuestionCount(
      count: count,
      difficulty: difficulty,
    );
  }
}

extension AcSubmissionNumNodeConversion on AcSubmissionNumNode {
  QuestionCount toQuestionCount() {
    return QuestionCount(
      count: count,
      difficulty: difficulty,
      // submissions: submissions,
    );
  }
}

extension BadgeNodeConversion on BadgeNode {
  LeetCodeBadge toBadge() {
    String? iconUrl = icon;

    // Check if the icon URL is relative
    if (iconUrl != null && !Uri.parse(iconUrl).isAbsolute) {
      // Prepend the base URL for relative URLs
      iconUrl = 'https://leetcode.com/$iconUrl';
    }
    return LeetCodeBadge(
      id: id,
      displayName: displayName,
      icon: iconUrl,
    );
  }
}

extension StreakCounterNodeConversion on StreakCounterNode {
  StreakCounter toStreakCounter() {
    return StreakCounter(
      streakCount: streakCount,
      daysSkipped: daysSkipped,
      currentDayCompleted: currentDayCompleted,
    );
  }
}

extension ProfileNodeExt on ProfileNode {
  UserProfile toProfile() {
    return UserProfile(
      realName: realName,
      websites: websites,
      countryName: countryName,
      skillTags: skillTags,
      company: company,
      school: school,
      starRating: starRating,
      aboutMe: aboutMe,
      userAvatar: userAvatar,
      reputation: reputation,
      ranking: ranking,
    );
  }
}
