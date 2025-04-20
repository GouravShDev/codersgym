import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:codersgym/features/articles/domain/model/discussion_article.dart';
import 'package:codersgym/features/articles/domain/repository/discussion_article_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'discussion_event.dart';
part 'discussion_state.dart';

class DiscussionBloc extends Bloc<DiscussionEvent, DiscussionState> {
  final DiscussionArticleRepository _discussionArticleRepository;

  int currentSkip = 0;
  int currentFirst = 10;
  DiscussionBloc(
    this._discussionArticleRepository,
  ) : super(DiscussionState.initial()) {
    on<DiscussionEvent>(
      (event, emit) async {
        switch (event) {
          case FetchDiscussionArticlesEvent():
            await _onFetchSolutionList(event, emit);
            break;
          default:
            break;
        }
      },
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 300))
          .asyncExpand(mapper),
    );
  }

  Future<void> _onFetchSolutionList(
      FetchDiscussionArticlesEvent event, Emitter<DiscussionState> emit) async {
// resent list if the skip is zero in the event
    if (event.skip == 0) {
      emit(state.copyWith(articles: []));
    }
    // Prevent unnecessary api calls
    if (state.articles.isNotEmpty && !state.moreArticlesAvailable) {
      return;
    }

    // Set values to input if provided
    currentFirst = event.first ?? currentFirst;
    currentSkip = event.skip ?? currentSkip;
    if (state.isLoading) {
      return; // Prevent mutliple call resulting in duplicate items
    }
    emit(state.copyWith(isLoading: true));
    final result = await _discussionArticleRepository.getDiscussionArticles(
      DiscussionArticlesInput(
        skip: currentSkip,
        first: currentFirst,
        orderBy: event.orderBy,
        keywords: event.keywords ?? [],
        tagSlugs: event.tagSlugs,
      ),
    );

    result.when(onSuccess: (value) {
      final updatedList = List<DiscussionArticle>.from(state.articles)
        ..addAll(value.articleList);
      final moreArticlesAvailable =
          updatedList.length < value.totalArticleCount;
      currentSkip = updatedList.length;
      emit(
        state.copyWith(
          articles: updatedList,
          isLoading: false,
          moreArticlesAvailable: moreArticlesAvailable,
        ),
      );
    }, onFailure: (exception) {
      emit(
        state.copyWith(
          error: exception,
          isLoading: false,
        ),
      );
    });
  }
}
