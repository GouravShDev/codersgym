import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:codersgym/features/articles/domain/model/article_comment.dart';
import 'package:codersgym/features/articles/domain/repository/discussion_article_repository.dart';
import 'package:equatable/equatable.dart';

part 'article_comments_event.dart';
part 'article_comments_state.dart';

class ArticleCommentsBloc
    extends Bloc<ArticleCommentsEvent, ArticleCommentsState> {
  ArticleCommentsBloc(this._articleRepository)
      : super(ArticleCommentsState.initial()) {
    on<FetchArticleCommentsEvent>(_onFetchArticleCommentsEvent);
  }
  final DiscussionArticleRepository _articleRepository;

  final Map<int, List<ArticleComment>> _cache = {};

  FutureOr<void> _onFetchArticleCommentsEvent(
    FetchArticleCommentsEvent event,
    Emitter<ArticleCommentsState> emit,
  ) async {
    if (_cache.containsKey(event.pageNo)) {
      emit(
        state.copyWith(
          comments: _cache[event.pageNo]!,
          isLoading: false,
          pageNo: event.pageNo,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    final result = await _articleRepository.getArticleComments(
      ArticleCommentInput(
        numPerPage: event.numPerPage,
        orderBy: event.orderBy,
        pageNo: event.pageNo,
        topicId: event.topicId,
      ),
    );
    result.when(
      onSuccess: (value) {
        emit(
          state.copyWith(
            isLoading: false,
            comments: value.comments.map(
              (e) {
                final parsedContent = e.content
                    ?.replaceAll('\\n', "  \n")
                    .replaceAll('<br>', "  \n");
                return e.copyWith(
                  content: parsedContent ?? '',
                );
              },
            ).toList(),
            pageNo: event.pageNo,
            totalComments: value.totalComments,
          ),
        );
      },
      onFailure: (exception) {
        emit(
          state.copyWith(
            isLoading: false,
            error: exception,
          ),
        );
      },
    );
  }
}
