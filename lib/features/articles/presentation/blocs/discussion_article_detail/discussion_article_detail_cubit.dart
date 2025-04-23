import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/articles/domain/model/discussion_article.dart';
import 'package:codersgym/features/articles/domain/repository/discussion_article_repository.dart';

typedef DiscussionArticleDetailState = ApiState<DiscussionArticle, Exception>;

class DiscussionArticleDetailCubit extends Cubit<DiscussionArticleDetailState> {
  DiscussionArticleDetailCubit(this._discussionArticleRepository)
      : super(ApiInitial());

  final DiscussionArticleRepository _discussionArticleRepository;

  Future<void> getDiscussionArticleDetail(
    DiscussionArticle post,
  ) async {
    emit(const ApiLoading());
    final result =
        await _discussionArticleRepository.getDiscussionArticleDetail(
      post.topicId ?? 0,
    );
    if (isClosed) return;
    if (result.isFailure) {
      emit(ApiError(result.getFailureException));
      return;
    }
    final postDetail = result.getSuccessValue;

    final parsedContentResult = postDetail?.content
        ?.replaceAll('\\n', "  \n")
        .replaceAll('\\t', "  \t")
        .replaceAll('<br>', "  \n");

    emit(
      ApiLoaded(
        postDetail.copyWith(
          content: parsedContentResult,
        ),
      ),
    );
  }
}
