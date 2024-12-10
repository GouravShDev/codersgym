import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:codersgym/core/network/network_service.dart';
import 'package:codersgym/core/utils/app_constants.dart';
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
  late NetworkService _leetcodeNetworkService;
  late NetworkService _dynamicBaseUrlNetworkService;

  final StorageManager _storageManager;

  LeetcodeApi({
    GraphQLClient? client,
    required StorageManager storageManger,
    required NetworkService leetcodeNetworkService,
    required NetworkService dynamicBaseUrlNetworkService,
  }) : _storageManager = storageManger {
    _graphQLClient = client ??
        GraphQLClient(
          link: HttpLink(
            ApiUrls.leetcodeGraphql,
          ),
          cache: GraphQLCache(),
        );
    _leetcodeNetworkService = leetcodeNetworkService;
    _dynamicBaseUrlNetworkService = dynamicBaseUrlNetworkService;
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
  }) {
    final url =
        '/problems/$questionTitleSlug/${submitCode ? 'submit' : 'interpret_solution'}/';
    return _executeApiRequest(
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
      referer: "https://leetcode.com/problems/$questionTitleSlug/",
    );
  }

  Future<Map<String, dynamic>?> checkSubmission({
    required String submissionId,
  }) async {
    return _executeApiRequest(
      path: '/submissions/detail/$submissionId/check/',
      data: NetworkRequestBody.empty(),
      type: NetworkRequestType.get,
    );
  }

  Future<Map<String, dynamic>?> formatCode({
    required String code,
    required String languageCode,
    required bool insertSpaces,
    required int tabSize,
  }) async {
    return _executeApiRequest(
      path: LeetcodeConstants.leetcodeFormatUrl.replaceFirst(
        '{lang}',
        languageCode,
      ),
      data: NetworkRequestBody.json({
        'code': code,
        'insertSpaces': insertSpaces,
        'tabSize': tabSize,
      }),
      type: NetworkRequestType.post,
      isDynamicBaseUrl: true,
    );
  }

  Future<Map<String, dynamic>?> _executeApiRequest({
    required String path,
    required NetworkRequestBody data,
    required NetworkRequestType type,
    String? referer,
    bool? isDynamicBaseUrl = false,
  }) async {
    try {
      final leetcodeCreds =
          await _storageManager.getObjectMap(_storageManager.leetcodeSession);
      final networkServie = (isDynamicBaseUrl ?? false)
          ? _dynamicBaseUrlNetworkService
          : _leetcodeNetworkService;
      final res = await networkServie.execute(
        NetworkRequest(
          path: path,
          data: data,
          type: type,
          headers: {
            'Cookie': CookieEncoder.encode(
              leetcodeCreds ?? {},
            ),
            'origin': "https://leetcode.com",
            'referer': referer ?? "https://leetcode.com",
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
