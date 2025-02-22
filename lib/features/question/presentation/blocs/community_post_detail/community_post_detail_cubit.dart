import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:codersgym/features/question/domain/repository/community_solution_repository.dart';

typedef CommunityPostDetailState
    = ApiState<CommunitySolutionPostDetail, Exception>;

class CommunityPostDetailCubit extends Cubit<CommunityPostDetailState> {
  final CommunitySolutionRepository _solutionRepository;
  CommunityPostDetailCubit(
    this._solutionRepository,
  ) : super(ApiState.initial());

  Future<void> getCommunitySolutionsDetails(
    CommunitySolutionPostDetail post,
  ) async {
    emit(const ApiLoading());
    final result = await _solutionRepository.getCommunitySolutionDetails(
      post.id ?? 0,
    );
    if (result.isFailure) {
      emit(ApiError(result.getFailureException));
      return;
    }
    final solutionDetail = result.getSuccessValue;

    final parsedContentResult = solutionDetail.post?.content
        ?.replaceAll('\\n', "  \n")
        .replaceAll('<br>', "  \n");

    emit(
      ApiLoaded(
        solutionDetail.copyWith(
          post: solutionDetail.post?.copyWith(
            content: parsedContentResult,
          ),
        ),
      ),
    );
  }
}
