import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/common/bloc/app_file_downloader/app_file_downloader_bloc.dart';
import 'package:codersgym/features/common/bloc/timestamp/timestamp_cubit.dart';
import 'package:codersgym/features/dashboard/presentation/blocs/contest_reminder_cubit.dart';
import 'package:codersgym/features/profile/presentation/blocs/user_profile/user_profile_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/daily_challenge/daily_challenge_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_archieve/question_archieve_bloc.dart';
import 'package:codersgym/features/question/presentation/blocs/question_filter/question_filter_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/upcoming_contests/upcoming_contests_cubit.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DashboardShell extends StatelessWidget implements AutoRouteWrapper {
  const DashboardShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt.get<UserProfileCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt.get<DailyChallengeCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<QuestionArchieveBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<UpcomingContestsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<AppFileDownloaderBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<QuestionFilterCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<ContestReminderCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<TimestampCubit>(),
        ),
      ],
      child: this,
    );
  }
}
