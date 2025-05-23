// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:codersgym/features/question/domain/model/problem_filter_v2.dart';

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
      operationName: "questionOfToday",
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
          status
          isPaidOnly
          acRate
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

  static LeetCodeRequests getFavoriteQuesionsRequest(
    String? favoriteSlug,
    int? limit,
    SortBy? sortBy,
    int? skip,
    ProblemFilterV2? filtersV2,
  ) {
    return LeetCodeRequests(
      operationName: "favoriteQuestionList",
      variables: Variables(
        skip: skip ?? 0,
        favoriteSlug: favoriteSlug,
        limit: limit ?? 100,
        sortBy: sortBy ?? SortBy(),
        filtersV2: filtersV2,
      ),
      query: """
      query favoriteQuestionList(\$favoriteSlug: String!, \$filter: FavoriteQuestionFilterInput, \$filtersV2: QuestionFilterInput, \$searchKeyword: String, \$sortBy: QuestionSortByInput, \$limit: Int, \$skip: Int, \$version: String = "v2") {
        favoriteQuestionList(
          favoriteSlug: \$favoriteSlug
          filter: \$filter
          filtersV2: \$filtersV2
          searchKeyword: \$searchKeyword
          sortBy: \$sortBy
          limit: \$limit
          skip: \$skip
          version: \$version
        ) {
          questions {
            difficulty
            id
            paidOnly
            questionFrontendId
            status
            title
            titleSlug
            isInMyFavorites
            frequency
            acRate
            topicTags {
              name
              slug
            }
          }
          totalLength
          hasMore
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

  static LeetCodeRequests getCurrentTimestamp() {
    return LeetCodeRequests(
      operationName: "currentTimestamp",
      variables: Variables(),
      query: """
          query currentTimestamp {
            currentTimestamp
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

  static LeetCodeRequests getCommunitySolutiongsTags(
    String questionTitleSlug,
  ) {
    return LeetCodeRequests(
      operationName: "ugcArticleSolutionTags",
      variables: Variables(
        questionSlug: questionTitleSlug,
      ),
      query: """
        query ugcArticleSolutionTags(\$questionSlug: String!) {
          ugcArticleSolutionTags(questionSlug: \$questionSlug) {
            otherTags {
              name
              slug
              count
            }
            knowledgeTags {
              name
              slug
              count
            }
            languageTags {
              name
              slug
              count
            }
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
    required List<String> languageTags,
    required List<String> topicTags,
  }) {
    return LeetCodeRequests(
      operationName: "communitySolutions",
      variables: Variables(
        orderBy: orderBy,
        skip: skip,
        first: first,
        query: query,
        questionSlug: questionTitleSlug,
        languageTags: languageTags,
        topicTags: topicTags,
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

  static LeetCodeRequests getMyFavoriteList() {
    return LeetCodeRequests(
      operationName: "myFavoriteList",
      variables: Variables(),
      query: """
          query myFavoriteList {
              myCreatedFavoriteList {
                favorites {
                  coverUrl
                  coverEmoji
                  coverBackgroundColor
                  hasCurrentQuestion
                  isPublicFavorite
                  lastQuestionAddedAt
                  name
                  slug
                  favoriteType
                }
                hasMore
                totalLength
              }
              myCollectedFavoriteList {
                hasMore
                totalLength
                favorites {
                  coverUrl
                  coverEmoji
                  coverBackgroundColor
                  hasCurrentQuestion
                  isPublicFavorite
                  name
                  slug
                  lastQuestionAddedAt
                  favoriteType
                }
              }
            }
    """,
    );
  }

  static LeetCodeRequests getProblemListProgess(String favoriteSlug) {
    return LeetCodeRequests(
      operationName: "favoriteUserQuestionProgressV2",
      variables: Variables(
        favoriteSlug: favoriteSlug,
      ),
      query: """
        query favoriteUserQuestionProgressV2(\$favoriteSlug: String!) {
          favoriteUserQuestionProgressV2(favoriteSlug: \$favoriteSlug) {
            numAcceptedQuestions {
              count
              difficulty
            }
            numFailedQuestions {
              count
              difficulty
            }
            numUntouchedQuestions {
              count
              difficulty
            }
            userSessionBeatsPercentage {
              difficulty
              percentage
            }
          }
        }
    
    """,
    );
  }

  static LeetCodeRequests dailyCheckin() {
    return LeetCodeRequests(
      operationName: "dailyCheckin",
      variables: Variables(),
      query: """
          mutation dailyCheckin {
              checkin {
                checkedIn
                ok
                error
              }
            }
        """,
    );
  }

  static LeetCodeRequests getDiscussionArticles({
    required String? orderBy,
    required int skip,
    required int first,
    required List<String> keywords,
    required List<String>? tagSlugs,
  }) {
    return LeetCodeRequests(
      operationName: "discussPostItems",
      variables: Variables(
        orderBy: orderBy,
        skip: skip,
        first: first,
        tagSlugs: tagSlugs,
        keywords: keywords,
      ),
      query: """
          query discussPostItems(\$orderBy: ArticleOrderByEnum, \$keywords: [String]!, \$tagSlugs: [String!], \$skip: Int, \$first: Int) {
              ugcArticleDiscussionArticles(
                orderBy: \$orderBy
                keywords: \$keywords
                tagSlugs: \$tagSlugs
                skip: \$skip
                first: \$first
              ) {
                totalNum
                pageInfo {
                  hasNextPage
                }
                edges {
                  node {
                    uuid
                    title
                    slug
                    summary
                    author {
                      realName
                      userAvatar
                      userSlug
                      userName
                      nameColor
                      certificationLevel
                      activeBadge {
                        icon
                        displayName
                      }
                    }
                    isOwner
                    isAnonymous
                    isSerialized
                    scoreInfo {
                      scoreCoefficient
                    }
                    articleType
                    thumbnail
                    summary
                    createdAt
                    updatedAt
                    status
                    isLeetcode
                    canSee
                    canEdit
                    isMyFavorite
                    myReactionType
                    topicId
                    hitCount
                    reactions {
                      count
                      reactionType
                    }
                    tags {
                      name
                      slug
                      tagType
                    }
                    topic {
                      id
                      topLevelCommentCount
                    }
                  }
                }
              }
            }
                
    
    """,
    );
  }

  static getDiscussionArticleDetail(int aritcleId) {
    return LeetCodeRequests(
      operationName: "discussPostDetail",
      variables: Variables(
        topicId: aritcleId,
      ),
      query: """
          query discussPostDetail(\$topicId: ID!) {
              ugcArticleDiscussionArticle(topicId: \$topicId) {
                uuid
                title
                slug
                summary
                content
                isSlate
                author {
                  realName
                  userAvatar
                  userSlug
                  userName
                  nameColor
                  certificationLevel
                  activeBadge {
                    icon
                    displayName
                  }
                }
                isOwner
                isAnonymous
                isSerialized
                isAuthorArticleReviewer
                scoreInfo {
                  scoreCoefficient
                }
                articleType
                thumbnail
                summary
                createdAt
                updatedAt
                status
                isLeetcode
                canSee
                canEdit
                isMyFavorite
                myReactionType
                topicId
                hitCount
                reactions {
                  count
                  reactionType
                }
                tags {
                  name
                  slug
                  tagType
                }
                topic {
                  id
                  topLevelCommentCount
                }
              }
            }
                
    """,
    );
  }

  static getDiscussionTags() {
    return LeetCodeRequests(
      operationName: "discussFollowedTopics",
      variables: Variables(),
      query: """
          query discussFollowedTopics {
              ugcArticleFollowedDiscussionTags {
                id
                name
                slug
              }
            }        
    """,
    );
  }

  static getArticleComments({
    required int numPerPage,
    required String orderBy,
    required int pageNo,
    required int topicId,
  }) {
    return LeetCodeRequests(
      operationName: "questionDiscussComments",
      variables: Variables(
        topicId: topicId,
        orderBy: orderBy,
        numPerPage: numPerPage,
        pageNo: pageNo,
      ),
      query: """
        query questionDiscussComments(\$topicId: Int!, \$orderBy: String = "newest_to_oldest", \$pageNo: Int = 1, \$numPerPage: Int = 10) {
            topicComments(
              topicId: \$topicId
              orderBy: \$orderBy
              pageNo: \$pageNo
              numPerPage: \$numPerPage
            ) {
              data {
                id
                pinned
                pinnedBy {
                  username
                }
                post {
                  ...DiscussPost
                }
                intentionTag {
                  slug
                }
                numChildren
              }
              totalNum
            }
          }
              
              fragment DiscussPost on PostNode {
            id
            voteCount
            voteUpCount
            voteStatus
            content
            updationDate
            creationDate
            status
            isHidden
            anonymous
            coinRewards {
              id
              score
              description
              date
            }
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
                certificationLevel
              }
              isActive
            }
            authorIsModerator
            isOwnPost
          }
            
    """,
    );
  }

  static getArticleReplies(
    int commentId,
  ) {
    return LeetCodeRequests(
      operationName: "commentReplies",
      variables: Variables(
        commentId: commentId,
      ),
      query: """          
        query commentReplies(\$commentId: Int!) {
            commentReplies(commentId: \$commentId) {
              id
              pinned
              pinnedBy {
                username
              }
              post {
                ...DiscussPost
              }
            }
          }
              
              fragment DiscussPost on PostNode {
            id
            voteCount
            voteUpCount
            voteStatus
            content
            updationDate
            creationDate
            status
            isHidden
            anonymous
            coinRewards {
              id
              score
              description
              date
            }
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
                certificationLevel
              }
              isActive
            }
            authorIsModerator
            isOwnPost
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
  final String? userInput;
  final List<String>? tagSlugs;
  final String? favoriteSlug;
  final SortBy? sortBy;
  final ProblemFilterV2? filtersV2;
  final List<String>? keywords;
  final int? numPerPage;
  final int? pageNo;
  final int? commentId;
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
    this.userInput,
    this.tagSlugs,
    this.favoriteSlug,
    this.sortBy,
    this.filtersV2,
    this.keywords,
    this.numPerPage,
    this.pageNo,
    this.commentId,
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
      'userInput': userInput,
      'tagSlugs': tagSlugs,
      'languageTags': languageTags,
      'topicTags': topicTags,
      'favoriteSlug': favoriteSlug,
      'sortBy': sortBy?.toJson(),
      'filtersV2': filtersV2?.toJson(),
      'keywords': keywords,
      'numPerPage': numPerPage,
      'pageNo': pageNo,
      'commentId': commentId,
    };
  }
}

class Filters {
  final List<String?>? tags;
  final String? orderBy;
  final String? sortOrder;
  final String? searchKeywords;
  final String? listId;
  final String? difficulty;

  Filters({
    this.tags,
    this.orderBy,
    this.sortOrder,
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
      if (sortOrder != null) 'sortOrder': sortOrder,
    };
  }
}

class SortBy {
  final String? sortField;
  final String? sortOrder;

  SortBy({
    this.sortField,
    this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      'sortField': sortField ?? "CUSTOM",
      'sortOrder': sortOrder ?? "ASCENDING",
    };
  }
}
