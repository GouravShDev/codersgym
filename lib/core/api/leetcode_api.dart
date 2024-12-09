import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:codersgym/core/network/network_service.dart';
import 'package:codersgym/core/utils/storage/cookie_encoder.dart';
import 'package:codersgym/core/utils/storage/storage_manager.dart';
import 'package:codersgym/features/auth/data/service/auth_service.dart';
import 'package:codersgym/injection.dart';
import 'package:exponential_back_off/exponential_back_off.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:codersgym/core/error/exception.dart';
import 'package:codersgym/core/api/api_urls.dart';
import 'package:codersgym/core/api/leetcode_requests.dart';

class LeetcodeApi {
  late GraphQLClient _graphQLClient;
  late NetworkService _networkService;

  final StorageManager _storageManager;

  LeetcodeApi({
    GraphQLClient? client,
    required StorageManager storageManger,
    required NetworkService networkService,
  }) : _storageManager = storageManger {
    _graphQLClient = client ??
        GraphQLClient(
          link: HttpLink(
            ApiUrls.leetcodeGraphql,
          ),
          cache: GraphQLCache(),
        );
    _networkService = networkService;
  }

  Future<Map<String, dynamic>?> getDailyQuestion() async {
    final request = LeetCodeRequests.getDailyQuestion();
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> getQuestionContent(String titleSlug) async {
    final request = LeetCodeRequests.getQuestionContent(titleSlug);
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> getUserProfile(String userName) async {
    final request = LeetCodeRequests.getUserProfileRequest(userName);
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> getGlobalData() async {
    final request = LeetCodeRequests.getGlobalData();
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> getContestRankingInfo(String userName) async {
    final request = LeetCodeRequests.getUserContestRankingInfo(userName);
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> getUserProfileCalendar(String userName) async {
    final request = LeetCodeRequests.getUserProfileCalendar(userName);
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> getProblemsList({
    required String? categorySlug,
    required int? limit,
    required Filters? filters,
    required int? skip,
  }) async {
    final request = LeetCodeRequests.getAllQuestionsRequest(
      categorySlug,
      limit,
      filters ?? Filters(), // Passing empty filter until filter is implemented
      skip,
    );
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> getUpcomingContest() async {
    final request = LeetCodeRequests.getUpcomingContests();
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> getSimilarQuestions(String questionId) async {
    final request = LeetCodeRequests.getSimilarQuestion(questionId);
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> hasOfficialSolution(String questionId) async {
    final request = LeetCodeRequests.hasOfficialSolution(questionId);
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> getOfficialSolution(String questionId) async {
    final request = LeetCodeRequests.getOfficialSolution(questionId);
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> getQuestionTags(String questionId) async {
    final request = LeetCodeRequests.getQuestionTags(questionId);
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> getQuestionHints(String questionId) async {
    final request = LeetCodeRequests.getQuestionHints(questionId);
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> getCommunitySolutions({
    required String questionId,
    required int skip,
    required orderBy,
  }) async {
    final request = LeetCodeRequests.getCommunitySolutions(
      first: 15,
      orderBy: orderBy,
      query: '',
      questionTitleSlug: questionId,
      skip: skip,
    );
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> getCommunitySolutionDetail(int topicId) async {
    final request = LeetCodeRequests.getCommunitySolutionDetails(topicId);
    return _executeGraphQLQuery(request);
  }

  Future<Map<String, dynamic>?> _executeGraphQLQuery(
      LeetCodeRequests request) async {
    try {
      final leetcodeCreds =
          await _storageManager.getObjectMap(_storageManager.leetcodeSession);

      final queryOptions = QueryOptions(
        document: gql(request.query),
        variables: request.variables.toJson(),
        context: Context.fromList([
          HttpLinkHeaders(headers: {
            'Cookie': CookieEncoder.encode(
              leetcodeCreds ?? {},
            ),
          })
        ]),
      );
      final exponentialBackOff = ExponentialBackOff(
        interval: const Duration(milliseconds: 1000),
        maxAttempts: 3,
        maxRandomizationFactor: 1,
        maxDelay: const Duration(seconds: 3),
      );

      final queryResult = await exponentialBackOff.start(
        () => _graphQLClient
            .query(
          queryOptions,
        )
            .timeout(const Duration(seconds: 2), onTimeout: () {
          throw TimeoutException('Server Timeout');
        }),
        retryIf: (error) {
          return (error is TimeoutException);
        },
      );
      return queryResult.fold(
        (exception) {
          throw ApiServerException("Server Error", exception);
        },
        (result) {
          if (result.hasException) {
            if (result.exception is OperationException) {
              if (result.exception?.graphqlErrors.firstOrNull?.message ==
                  "That user does not exist.") {
                throw ApiNotFoundException("User Not Found", result.exception);
              }
            }
            throw ApiServerException("Server Error", result.exception);
          }
          return result.data;
        },
      );
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiNoNetworkException("There was some network error", e);
    }
  }

  Future<Map<String, dynamic>?> runCode({
    required String questionTitleSlug,
    required String questionId,
    required String programmingLanguage,
    required String code,
    required String testCases,
    required bool submitCode,
  }) async {
    try {
      final leetcodeCreds =
          await _storageManager.getObjectMap(_storageManager.leetcodeSession);

      final url =
          '/problems/$questionTitleSlug/${submitCode ? 'submit' : 'interpret_solution'}/';
      final res = await _networkService.execute(
        NetworkRequest(
          path: url,
          data: NetworkRequestBody.json(
            {
              "lang": programmingLanguage,
              "question_id": questionId,
              "typed_code": code,
              "data_input": testCases,
            },
          ),
          type: NetworkRequestType.post,
          headers: {
            'Cookie': CookieEncoder.encode(
              leetcodeCreds ?? {},
            ),
            'origin': "https://leetcode.com",
            'referer': "https://leetcode.com/problems/$questionTitleSlug/",
            'x-csrftoken': leetcodeCreds?['csrftoken'],
          },
        ),
        (data) => data,
      );
      return res.when(
        ok: (data) => data,
        error: (error) {
          throw ApiServerException(error.message ?? '', error.code);
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> checkSubmission({
    required String submissionId,
  }) async {
    try {
      final leetcodeCreds =
          await _storageManager.getObjectMap(_storageManager.leetcodeSession);

      final res = await _networkService.execute(
        NetworkRequest(
          path: '/submissions/detail/$submissionId/check/',
          data: NetworkRequestBody.empty(),
          type: NetworkRequestType.get,
          headers: {
            'Cookie': CookieEncoder.encode(
              leetcodeCreds ?? {},
            ),
            'origin': "https://leetcode.com",
            'referer': "https://leetcode.com",
            'x-csrftoken': leetcodeCreds?['csrftoken'],
          },
        ),
        (data) => data,
      );
      return res.when(
        ok: (data) => data,
        error: (error) {
          throw ApiServerException(error.message ?? '', error.code);
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
