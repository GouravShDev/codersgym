import 'package:codersgym/core/network/app_dio_logger.dart';
import 'package:codersgym/core/network/dio_network_service.dart';
import 'package:codersgym/core/network/network_service.dart';
import 'package:codersgym/core/services/firebase_remote_config_service.dart';
import 'package:codersgym/core/services/github_updater.dart';
import 'package:codersgym/core/services/local_notification_service.dart';
import 'package:codersgym/core/services/notification_scheduler.dart';
import 'package:codersgym/core/utils/app_constants.dart';
import 'package:codersgym/core/utils/storage/local_storage_manager.dart';
import 'package:codersgym/core/utils/storage/storage_manager.dart';
import 'package:codersgym/features/articles/data/repository/discussion_article_repository.dart';
import 'package:codersgym/features/articles/domain/repository/discussion_article_repository.dart';
import 'package:codersgym/features/articles/presentation/blocs/discussion/discussion_bloc.dart';
import 'package:codersgym/features/articles/presentation/blocs/discussion_tags/discussion_tags_cubit.dart';
import 'package:codersgym/features/auth/data/service/auth_service.dart';
import 'package:codersgym/features/auth/domain/service/auth_service.dart';
import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/code_editor/data/repository/code_editor_repository.dart';
import 'package:codersgym/features/code_editor/domain/repository/code_editor_repository.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/code_editor/code_editor_bloc.dart';
import 'package:codersgym/features/common/bloc/app_file_downloader/app_file_downloader_bloc.dart';
import 'package:codersgym/features/common/bloc/timestamp/timestamp_cubit.dart';
import 'package:codersgym/features/common/services/recent_question_manager.dart';
import 'package:codersgym/features/common/widgets/app_error_notifier.dart';
import 'package:codersgym/features/dashboard/data/repository/daily_checkin_repository.dart';
import 'package:codersgym/features/dashboard/domain/repository/daily_checkin_repository.dart';
import 'package:codersgym/features/dashboard/presentation/blocs/contest_reminder_cubit.dart';
import 'package:codersgym/features/dashboard/presentation/blocs/daily_checkin/daily_checkin_cubit.dart';
import 'package:codersgym/features/dashboard/presentation/blocs/recent_question/recent_question_cubit.dart';
import 'package:codersgym/features/profile/data/repository/profile_repository.dart';
import 'package:codersgym/features/profile/presentation/blocs/contest_ranking_info/contest_ranking_info_cubit.dart';
import 'package:codersgym/features/profile/presentation/blocs/cubit/user_profile_calendar_cubit.dart';
import 'package:codersgym/features/profile/presentation/blocs/user_profile/user_profile_cubit.dart';
import 'package:codersgym/features/question/data/parser/leetcode_solution_parser.dart';
import 'package:codersgym/features/question/data/repository/community_solution_repository.dart';
import 'package:codersgym/features/question/data/repository/favorite_questions_repository.dart';
import 'package:codersgym/features/question/domain/repository/community_solution_repository.dart';
import 'package:codersgym/features/question/domain/repository/favorite_questions_repository.dart';
import 'package:codersgym/features/question/presentation/blocs/community_post_detail/community_post_detail_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/community_solution_filter/community_solution_filter_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/community_solutions/community_solutions_bloc.dart';
import 'package:codersgym/features/question/presentation/blocs/favorite_quesions_list/favorite_quesions_list_bloc.dart';
import 'package:codersgym/features/question/presentation/blocs/my_favorite_list/my_favorite_list_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/official_solution_available/official_solution_available_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/online_user_count/online_user_count_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/problem_list_progress/problem_list_progress_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/problem_sheets/problem_sheets_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_archieve/question_archieve_bloc.dart';
import 'package:codersgym/features/question/presentation/blocs/question_filter/question_filter_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_hints/question_hints_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_solution/question_solution_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_tags/question_tags_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/similar_question/similar_question_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/upcoming_contests/upcoming_contests_cubit.dart';
import 'package:codersgym/features/settings/presentation/blocs/app_info/app_info_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/core/routes/app_router.dart';
import 'package:codersgym/features/question/data/repository/question_repository.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';
import 'package:codersgym/features/question/presentation/blocs/daily_challenge/daily_challenge_cubit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/profile/domain/repository/profile_repository.dart';
import 'features/question/presentation/blocs/question_content/question_content_cubit.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // UTILS
  final sharedPref = await SharedPreferences.getInstance();
  final hydradedStorage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  HydratedBloc.storage = hydradedStorage;
  getIt.registerLazySingleton<StorageManager>(
    () => LocalStorageManager.getInstance(sharedPref),
  );
  getIt.registerLazySingleton(
    () => HTMLMarkdownParser(),
  );

  getIt.registerLazySingleton<HydratedStorage>(
    () => hydradedStorage,
  );

  final configService = FirebaseRemoteConfigService();
  await configService.initialize(
    minimumFetchInterval: 3600, // 1 hour
    fetchImmediately: true,
  );

  getIt.registerSingleton(configService);

  // ROUTER
  getIt.registerSingleton(AppRouter());

  // Notifier
  getIt.registerSingleton(AppErrorNotifier(getIt.get()));

  // SERVICE
  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImp(
      getIt.get(),
      getIt.get(),
      getIt.get(),
      getIt.get(),
    ),
  );
  getIt.registerLazySingleton<NetworkService>(
    () => DioNetworkService(
      configuration: NetworkConfiguration(baseUrl: 'https://leetcode.com'),
      interceptors: [
        AppDioLogger(),
      ],
      appErrorNotifier: getIt.get(),
    ),
    instanceName: 'leetcodeNetworkService',
  );
  getIt.registerLazySingleton<NetworkService>(
    () => DioNetworkService(
      configuration: NetworkConfiguration(baseUrl: ''),
      interceptors: [
        AppDioLogger(),
      ],
      appErrorNotifier: getIt.get(),
    ),
    instanceName: 'dynamicBaseUrlNetworkService',
  );

  getIt.registerLazySingleton<GithubUpdater>(
    () => GithubUpdater(
        repoName: AppConstants.githubRepo,
        username: AppConstants.githubUsername,
        storageManager: getIt.get()),
  );
  getIt.registerLazySingleton<NotificationScheduler>(
    () => NotificationScheduler(
      notificationService: LocalNotificationService(),
      storage: getIt.get(),
    ),
  );

  getIt.registerLazySingleton<RecentQuestionManager>(
    () => RecentQuestionManager(),
  );

  // REPOSITORY
  getIt.registerLazySingleton(
    () => LeetcodeApi(
      storageManger: getIt.get(),
      errorNotifier: getIt.get(),
      leetcodeNetworkService: getIt.get(instanceName: 'leetcodeNetworkService'),
      dynamicBaseUrlNetworkService:
          getIt.get(instanceName: 'dynamicBaseUrlNetworkService'),
    ),
  );
  getIt.registerSingleton<QuestionRepository>(
    QuestionRepositoryImpl(
      getIt.get(),
    ),
  );
  getIt.registerSingleton<ProfileRepository>(
    ProfileRepositoryImp(
      getIt.get(),
    ),
  );
  getIt.registerSingleton<CodeEditorRepository>(
    CodeEditorRepositoryImp(
      leetcodeApi: getIt.get(),
    ),
  );
  getIt.registerSingleton<CommunitySolutionRepository>(
    CommunitySolutionRepositoryImp(
      getIt.get(),
    ),
  );
  getIt.registerSingleton<FavoriteQuestionsRepository>(
    FavoriteQuestionsRepositoryImp(
      getIt.get(),
      getIt.get(),
    ),
  );
  getIt.registerSingleton<DailyCheckinRepository>(
    DailyCheckinRepositoryImp(
      getIt.get(),
    ),
  );
  getIt.registerSingleton<DiscussionArticleRepository>(
    DiscussionArticleRepositoryImp(
      getIt.get(),
    ),
  );

  // BLOC/CUBIT
  getIt.registerFactory(
    () => AuthBloc(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => DailyChallengeCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => QuestionContentCubit(
      getIt.get(),
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => UserProfileCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => ContestRankingInfoCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => UserProfileCalendarCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => QuestionArchieveBloc(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => UpcomingContestsCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => SimilarQuestionCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => QuestionSolutionCubit(
      getIt.get(),
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => QuestionTagsCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => QuestionHintsCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => OfficialSolutionAvailableCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => CommunitySolutionsBloc(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => CommunityPostDetailCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactoryParam<CodeEditorBloc, String, void>(
    (questionId, _) => CodeEditorBloc(
      getIt.get(),
      getIt.get(),
      questionId,
    ),
  );
  getIt.registerFactory(
    () => AppInfoCubit(),
  );
  getIt.registerFactory(
    () => AppFileDownloaderBloc(),
  );
  getIt.registerFactory(
    () => QuestionFilterCubit(),
  );
  getIt.registerFactory(
    () => ContestReminderCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactoryParam<OnlineUserCountCubit, String, void>(
    (questionId, _) => OnlineUserCountCubit(
      questionTitleSlug: questionId,
    ),
  );
  getIt.registerFactory(
    () => CommunitySolutionFilterCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => TimestampCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => FavoriteQuesionsListBloc(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => MyFavoriteListCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => ProblemSheetsCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => ProblemListProgressCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => RecentQuestionCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => DailyCheckinCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => DiscussionBloc(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => DiscussionTagsCubit(
      getIt.get(),
    ),
  );
}
