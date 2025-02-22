import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';

abstract class CommunitySolutionRepository {
  Future<
      Result<
          ({
            List<CommunitySolutionPostDetail> solutionList,
            int totalSolutionCount
          }),
          Exception>> getCommunitySolutions(
    CommunitySolutionsInput input,
  );

  Future<Result<CommunitySolutionPostDetail, Exception>>
      getCommunitySolutionDetails(
    int topicId,
  );
  Future<Result<({List<SolutionTag> topicTags, List<SolutionTag> languageTags }), Exception>> getSolutionTags(
    String questionSlug,
  );
}

class CommunitySolutionsInput {
  final String questiontitleSlug;
  final String orderBy;
  final int skip;
  final int limit;
  String query;
  List<String> topics;
  List<String> languages;

  CommunitySolutionsInput({
    required this.questiontitleSlug,
    required this.orderBy,
    required this.skip,
    required this.limit,
    this.topics = const <String>[],
    this.languages = const <String>[],
    this.query = '',
  });
}
