import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/articles/domain/repository/discussion_article_repository.dart';
import 'package:codersgym/features/common/data/models/tag.dart';

typedef DiscussionTagsState = ApiState<List<Tag>, Exception>;

class DiscussionTagsCubit extends Cubit<DiscussionTagsState> {
  DiscussionTagsCubit(
    this._discussionArticleRepository,
  ) : super(ApiInitial());

  Future<void> fetchTags() async {
    emit(const ApiLoading());
    final result = await _discussionArticleRepository.getDiscussionTags();
    result.when(
      onSuccess: (tags) {
        emit(ApiLoaded(tags));
      },
      onFailure: (exception) {
        emit(ApiError(exception));
      },
    );
  }

  final DiscussionArticleRepository _discussionArticleRepository;
}
