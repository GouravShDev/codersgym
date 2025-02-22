import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/core/error/exception.dart';
import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/features/question/data/entity/community_post_detail_entity.dart';
import 'package:codersgym/features/question/data/entity/community_solutions_entity.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:codersgym/features/question/domain/repository/community_solution_repository.dart';

class CommunitySolutionRepositoryImp implements CommunitySolutionRepository {
  final LeetcodeApi leetcodeApi;

  CommunitySolutionRepositoryImp(this.leetcodeApi);

  @override
  Future<
      Result<
          ({
            List<CommunitySolutionPostDetail> solutionList,
            int totalSolutionCount
          }),
          Exception>> getCommunitySolutions(
    CommunitySolutionsInput input,
  ) async {
    try {
      final data = await leetcodeApi.getCommunitySolutions(
        questionId: input.questiontitleSlug,
        orderBy: input.orderBy,
        skip: input.skip,
        query: input.query,
        languageTags: input.languages,
        topicTags: input.topics,
      );
      if (data == null) {
        return Failure(Exception("No data found"));
      }
      final communitySolutions = CommunitySolutionListEntity.fromJson(data);
      final communitySolutionsList =
          communitySolutions.questionSolutions?.solutions
              ?.map(
                (e) => e.toCommunitySolutionPostDetail(),
              )
              .toList();

      return Success((
        solutionList: communitySolutionsList ?? [],
        totalSolutionCount: communitySolutions.questionSolutions?.totalNum ?? 0
      ));
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<
      Result<({List<SolutionTag> topicTags, List<SolutionTag> languageTags}),
          Exception>> getSolutionTags(String questionSlug) async {
    try {
      final Map<String, dynamic>? data =
          await leetcodeApi.getCommunitySolutionsTag(questionSlug);
      if (data == null) {
        return Failure(Exception("No data found"));
      }

      final ugcArticleSolutionTags = data['ugcArticleSolutionTags'];
      final languageTagsData =
          ugcArticleSolutionTags['languageTags'] as List<dynamic>?;
      final knowledgeTagsData =
          ugcArticleSolutionTags['knowledgeTags'] as List<dynamic>?;

      final List<SolutionTag> languageTags = languageTagsData
              ?.map((e) => SolutionTag(
                    name: e['name'],
                    slug: e['slug'],
                    count: e['count'],
                  ))
              .toList() ??
          [];

      final List<SolutionTag> topicTags = knowledgeTagsData
              ?.map((e) => SolutionTag(
                    name: e['name'],
                    slug: e['slug'],
                    count: e['count'],
                  ))
              .toList() ??
          [];

      return Success((topicTags: topicTags, languageTags: languageTags));
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<CommunitySolutionPostDetail, Exception>>
      getCommunitySolutionDetails(int topicId) async {
    try {
      final data = await leetcodeApi.getCommunitySolutionDetail(topicId);
      if (data == null) {
        return Failure(Exception("No data found"));
      }
      final comunityPostDetails =
          CommunityPostDetailEntity.fromJson(data['topic']);

      return Success(comunityPostDetails.toCommunitySolutionPostDetail());
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }
}
