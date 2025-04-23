import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/articles/domain/model/article_comment.dart';
import 'package:codersgym/features/articles/domain/repository/discussion_article_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef CommentRepliesState = ApiState<List<ArticleComment>, Exception>;

class CommentRepliesCubit extends Cubit<CommentRepliesState> {
  CommentRepliesCubit({
    required DiscussionArticleRepository discussionArticleRepository,
    required int articleCommentId,
  })  : _discussionArticleRepository = discussionArticleRepository,
        _articleCommentId = articleCommentId,
        super(ApiInitial()) {
    fetchCommentReplies();
  }
  final DiscussionArticleRepository _discussionArticleRepository;
  final int _articleCommentId;

  Future<void> fetchCommentReplies() async {
    emit(const ApiLoading());

    final result =
        await _discussionArticleRepository.getArticleReplies(_articleCommentId);
    result.when(
      onSuccess: (value) {
        emit(
          ApiLoaded(value),
        );
      },
      onFailure: (exception) {
        emit(
          ApiError(Exception(exception)),
        );
      },
    );
  }
}
