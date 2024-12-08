// ignore_for_file: prefer_interpolation_to_compose_strings

class LeetCodeRequests {
  final String operationName;
  final Variables variables;
  final String query;

  LeetCodeRequests({
    required this.operationName,
    required this.variables,
    required this.query,
  });

  Map<String, dynamic> toJson() {
    return {
      'operationName': operationName,
      'variables': variables.toJson(),
      'query': query,
    };
  }

  // Helper methods for creating specific requests
  static LeetCodeRequests generalDiscussionRequest(
      int limit, List<String> categories) {
    return LeetCodeRequests(
        operationName: "categoryTopicList",
        variables: Variables(
          orderBy: "hot",
          query: "",
          skip: 0,
          first: limit,
          categories: categories,
        ),
        query: "query categoryTopicList(\$categories: [String!]!, \$first: Int!, \$orderBy: TopicSortingOption, \$skip: Int, \$query: String, \$tags: [String!]) { categoryTopicList"
                "(categories: \$categories, orderBy: \$orderBy, skip: \$skip, query: \$query, first: \$first, tags: \$tags) { ...TopicsList } } fragment TopicsList on TopicConnection " +
            "{ totalNum  edges {  node {  id title commentCount  viewCount  tags { name slug } post { id voteCount creationDate author { username profile { userAvatar } } } } } }");
  }

  static LeetCodeRequests generalDiscussionItemRequest(int? topicId) {
    return LeetCodeRequests(
        operationName: "DiscussTopic",
        variables: Variables(
          topicId: topicId,
        ),
        query:
            "query DiscussTopic(\$topicId: Int!) { topic(id: \$topicId) { id viewCount topLevelCommentCount title pinned tags post { ...DiscussPost } } }"
            "fragment DiscussPost on PostNode { id voteCount content updationDate creationDate author { username profile { userAvatar reputation } } } ");
  }

  static LeetCodeRequests getUserProfileRequest(String userName) {
    return LeetCodeRequests(
        operationName: "getUserProfile",
        variables: Variables(
          username: userName,
          query: "",
        ),
        query: """
            query getUserProfile(\$username: String!) {
                  allQuestionsCount {
                    difficulty
                    count
                    __typename
                  }
                  streakCounter {
                        streakCount
                        daysSkipped
                        currentDayCompleted
                  }
                  matchedUser(username: \$username) {
                    username
                    socialAccounts
                    githubUrl
                    contributions {
                      points
                      questionCount
                      testcaseCount
                      __typename
                    }
                      
                    profile {
                      realName
                      websites
                      countryName
                      skillTags
                      company
                      school
                      starRating
                      aboutMe
                      userAvatar
                      reputation
                      ranking
                      __typename
                    }
                    submissionCalendar
                    submitStats: submitStatsGlobal {
                      acSubmissionNum {
                        difficulty
                        count
                        submissions
                        __typename
                      }
                      totalSubmissionNum {
                        difficulty
                        count
                        submissions
                        __typename
                      }
                      __typename
                    }
                    badges {
                      id
                      displayName
                      icon
                      creationDate
                      medal {
                        slug
                        config {
                          icon
                          iconGif
                          iconGifBackground
                          iconWearing
                          __typename
                        }
                        __typename
                      }
                      __typename
                    }
                    upcomingBadges {
                      name
                      icon
                      __typename
                    }
                    activeBadge {
                      id
                      __typename
                    }
                    __typename
                  }
                }

    
        """);
  }

  static LeetCodeRequests getDailyQuestion() {
    return LeetCodeRequests(
      operationName: "",
      variables: Variables(),
      query: """
          query questionOfToday {
              activeDailyCodingChallengeQuestion {
                date
                userStatus
                link
                question {
                  acRate
                  difficulty
                  freqBar
                  frontendQuestionId: questionFrontendId
                  isFavor
                  paidOnly: isPaidOnly
                  status
                  title
                  titleSlug
                  hasVideoSolution
                  hasSolution
                }
              }
            }
      """,
    );
  }

  static LeetCodeRequests getQuestionContent(String? titleSlug) {
    return LeetCodeRequests(
      operationName: "questionData",
      variables: Variables(
        titleSlug: titleSlug,
      ),
      query: '''
      query questionData(\$titleSlug: String!) {
        question(titleSlug: \$titleSlug) {
          questionId
          frontendQuestionId: questionFrontendId
          title
          titleSlug
          content
          isPaidOnly
          difficulty
          likes
          dislikes
          exampleTestcases
          categoryTitle
          topicTags {
            name
            slug
            translatedName
          }
          stats
          hints
          solution {
            id
            canSeeDetail
            paidOnly
            hasVideoSolution
            paidOnlyVideo
          }
          codeSnippets {
            code
            lang
            langSlug
          }
          exampleTestcaseList
        }
      }
    ''',
    );
  }

  static LeetCodeRequests getAllQuestionsRequest(
    String? categorySlug,
    int? limit,
    Filters? filters,
    int? skip,
  ) {
    return LeetCodeRequests(
      operationName: "problemsetQuestionList",
      variables: Variables(
        skip: skip,
        categorySlug: categorySlug,
        limit: limit,
        filters: filters,
      ),
      query: """
             query problemsetQuestionList(\$categorySlug: String, \$limit: Int, \$skip: Int, \$filters: QuestionListFilterInput) {
              problemsetQuestionList: questionList(
                categorySlug: \$categorySlug
                limit: \$limit
                skip: \$skip
                filters: \$filters
              ) {
                total: totalNum
                questions: data {
                  acRate
                  difficulty
                  freqBar
                  frontendQuestionId: questionFrontendId
                  isFavor
                  paidOnly: isPaidOnly
                  status
                  title
                  titleSlug
                  topicTags {
                    name
                    id
                    slug
                  }
                  hasSolution
                  hasVideoSolution
                }
              }
              }
        """,
    );
  }

  static LeetCodeRequests getGlobalData() {
    return LeetCodeRequests(
      operationName: "globalData",
      variables: Variables(),
      query: """
        query globalData {
          userStatus {
            username
            realName
            avatar
            notificationStatus {
              lastModified
              numUnread
              __typename
            }
        }
      }
""",
    );
  }

  static LeetCodeRequests getUserContestRankingInfo(String userName) {
    return LeetCodeRequests(
      operationName: "userContestRankingInfo",
      variables: Variables(
        username: userName,
      ),
      query: """
          query userContestRankingInfo(\$username: String!) {
        userContestRanking(username: \$username) {
            attendedContestsCount
            rating
            globalRanking
            totalParticipants
            topPercentage
          }
        userContestRankingHistory(username: \$username) {
          attended
          trendDirection
          problemsSolved
          totalProblems
          rating
          ranking
          contest {
            title
            startTime
          }
        }
      }
    """,
    );
  }

  static LeetCodeRequests getUserProfileCalendar(String userName) {
    return LeetCodeRequests(
      operationName: "userProfileCalendar",
      variables: Variables(
        username: userName,
      ),
      query: """
          query userProfileCalendar(\$username: String!, \$year: Int) {
                matchedUser(username: \$username) {
                  userCalendar(year: \$year) {
                    activeYears
                    streak
                    totalActiveDays
                    dccBadges {
                      timestamp
                      badge {
                        name
                        icon
                      }
                    }
                    submissionCalendar
                  }
                }
              }
    
    """,
    );
  }

  static LeetCodeRequests getUpcomingContests() {
    return LeetCodeRequests(
      operationName: "topTwoContests",
      variables: Variables(),
      query: """
          query topTwoContests {
              topTwoContests {
                title
                titleSlug
                cardImg
                startTime
                duration
              }
            }
    """,
    );
  }

  static LeetCodeRequests getQuestionTags(String questionTitleSlug) {
    return LeetCodeRequests(
      operationName: "singleQuestionTopicTags",
      variables: Variables(
        titleSlug: questionTitleSlug,
      ),
      query: """
          query singleQuestionTopicTags(\$titleSlug: String!) {
              question(titleSlug: \$titleSlug) {
                topicTags {
                  name
                  slug
                }
              }
            }
    """,
    );
  }

  static LeetCodeRequests getSimilarQuestion(String questionTitleSlug) {
    return LeetCodeRequests(
      operationName: "SimilarQuestions",
      variables: Variables(
        titleSlug: questionTitleSlug,
      ),
      query: """
        query SimilarQuestions(\$titleSlug: String!) {
            question(titleSlug: \$titleSlug) {
              similarQuestionList {
                difficulty
                titleSlug
                title
                translatedTitle
                isPaidOnly
              }
            }
          }
        
    """,
    );
  }

  static LeetCodeRequests hasOfficialSolution(String questionTitleSlug) {
    return LeetCodeRequests(
      operationName: "hasOfficialSolution",
      variables: Variables(
        titleSlug: questionTitleSlug,
      ),
      query: """
      query hasOfficialSolution(\$titleSlug: String!) {
          question(titleSlug: \$titleSlug) {
            solution {
              id
            }
          }
      }
    """,
    );
  }

  static LeetCodeRequests getOfficialSolution(
    String questionTitleSlug,
  ) {
    return LeetCodeRequests(
      operationName: "officialSolution",
      variables: Variables(
        titleSlug: questionTitleSlug,
      ),
      query: """
        query officialSolution(\$titleSlug: String!) {
            question(titleSlug: \$titleSlug) {
              solution {
                id
                title
                content
                contentTypeId
                paidOnly
                hasVideoSolution
                paidOnlyVideo
                canSeeDetail
                rating {
                  count
                  average
                  userRating {
                    score
                  }
                }
                topic {
                  id
                  commentCount
                  topLevelCommentCount
                  viewCount
                  subscribed
                  solutionTags {
                    name
                    slug
                  }
                  post {
                    id
                    status
                    creationDate
                    author {
                      username
                      isActive
                      profile {
                        userAvatar
                        reputation
                      }
                    }
                  }
                }
              }
            }
        }
    
    """,
    );
  }

  static LeetCodeRequests getQuestionHints(
    String questionTitleSlug,
  ) {
    return LeetCodeRequests(
      operationName: "questionHints",
      variables: Variables(
        titleSlug: questionTitleSlug,
      ),
      query: """
      query questionHints(\$titleSlug: String!) {
          question(titleSlug: \$titleSlug) {
            hints
          }
        }
    """,
    );
  }

  static LeetCodeRequests getCommunitySolutions({
    required int first,
    required String questionTitleSlug,
    required int skip,
    required String query,
    required String orderBy,
  }) {
    return LeetCodeRequests(
      operationName: "communitySolutions",
      variables: Variables(
        orderBy: orderBy,
        skip: skip,
        first: first,
        query: query,
        questionSlug: questionTitleSlug,
        languageTags: [],
        topicTags: [],
      ),
      query: """
              query communitySolutions(\$questionSlug: String!, \$skip: Int!, \$first: Int!, \$query: String, \$orderBy: TopicSortingOption, \$languageTags: [String!], \$topicTags: [String!]) {
            questionSolutions(
              filters: {questionSlug: \$questionSlug, skip: \$skip, first: \$first, query: \$query, orderBy: \$orderBy, languageTags: \$languageTags, topicTags: \$topicTags}
            ) {
              hasDirectResults
              totalNum
              solutions {
                id
                title
                commentCount
                topLevelCommentCount
                viewCount
                pinned
                isFavorite
                solutionTags {
                  name
                  slug
                }
                post {
                  id
                  status
                  voteStatus
                  voteCount
                  creationDate
                  isHidden
                  author {
                    username
                    isActive
                    nameColor
                    activeBadge {
                      displayName
                      icon
                    }
                    profile {
                      userAvatar
                      reputation
                      realName
                    }
                  }
                }
                searchMeta {
                  content
                  contentType
                  commentAuthor {
                    username
                  }
                  replyAuthor {
                    username
                  }
                  highlights
                }
              }
            }
          }
    
    """,
    );
  }

  static LeetCodeRequests getCommunitySolutionDetails(
    int topicId,
  ) {
    return LeetCodeRequests(
      operationName: "communitySolution",
      variables: Variables(
        topicId: topicId,
      ),
      query: """
          query communitySolution(\$topicId: Int!) {
                topic(id: \$topicId) {
                  id
                  viewCount
                  topLevelCommentCount
                  subscribed
                  title
                  pinned
                  solutionTags {
                    name
                    slug
                  }
                  hideFromTrending
                  commentCount
                  isFavorite
                  post {
                    id
                    voteCount
                    voteStatus
                    content
                    updationDate
                    creationDate
                    status
                    isHidden
                    author {
                      isDiscussAdmin
                      isDiscussStaff
                      username
                      nameColor
                      activeBadge {
                        displayName
                        icon
                      }
                      profile {
                        userAvatar
                        reputation
                        realName
                      }
                      isActive
                    }
                    authorIsModerator
                    isOwnPost
                  }
                }
              }
          
    """,
    );
  }
}

class Variables {
  final String? username;
  final String? titleSlug;
  final String? categorySlug;
  final String? questionSlug;
  final String? orderBy;
  final String? query;
  final int? skip;
  final int? first;
  final List<String>? categories;
  final Filters? filters;
  final String? questionId;
  final int? topicId;
  final List<String>? tags;
  final int? limit;
  final List<String>? languageTags;
  final List<String>? topicTags;

  Variables({
    this.username,
    this.titleSlug,
    this.questionSlug,
    this.categorySlug,
    this.orderBy,
    this.query,
    this.skip,
    this.first,
    this.categories,
    this.filters,
    this.questionId,
    this.topicId,
    this.tags,
    this.limit,
    this.languageTags,
    this.topicTags,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'titleSlug': titleSlug,
      'questionSlug': questionSlug,
      'categorySlug': categorySlug,
      'orderBy': orderBy,
      'query': query,
      'skip': skip,
      'first': first,
      'categories': categories,
      'filters': filters?.toJson(),
      'questionId': questionId,
      'topicId': topicId,
      'tags': tags,
      'limit': limit,
    };
  }
}

class Filters {
  final List<String?>? tags;
  final String? orderBy;
  final String? searchKeywords;
  final String? listId;
  final String? difficulty;

  Filters({
    this.tags,
    this.orderBy,
    this.searchKeywords,
    this.listId,
    this.difficulty,
  });

  Map<String, dynamic> toJson() {
    return {
      if (tags != null) 'tags': tags,
      if (orderBy != null) 'orderBy': orderBy,
      if (searchKeywords != null) 'searchKeywords': searchKeywords,
      if (listId != null) 'listId': listId,
      if (difficulty != null) 'difficulty': difficulty,
    };
  }
}
