import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/domain/model/favorite_problemset.dart';
import 'package:codersgym/features/question/domain/repository/favorite_questions_repository.dart';

typedef MyFavoriteListState = ApiState<
    ({
      List<FavoriteProblemset> createdProblemset,
      List<FavoriteProblemset> collectedProblemset
    }),
    Exception>;

class MyFavoriteListCubit extends Cubit<MyFavoriteListState> {
  MyFavoriteListCubit(this.favoriteQuestionsRepository)
      : super(ApiState.initial());

  final FavoriteQuestionsRepository favoriteQuestionsRepository;

  Future<void> fetchFavoriteList() async {
    emit(const ApiLoading());
    final result = await favoriteQuestionsRepository.getFavorites();

    result.when(
      onSuccess: (value) {
        emit(ApiLoaded(value));
      },
      onFailure: (exception) {
        emit(ApiError(exception));
      },
    );
  }
}
