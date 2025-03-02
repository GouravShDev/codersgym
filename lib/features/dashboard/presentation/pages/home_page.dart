import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/common/bloc/timestamp/timestamp_cubit.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/common/widgets/app_loading.dart';
import 'package:codersgym/features/dashboard/presentation/blocs/contest_reminder_cubit.dart';
import 'package:codersgym/features/dashboard/presentation/widgets/upcoming_contest_card.dart';
import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:codersgym/features/profile/presentation/blocs/user_profile/user_profile_cubit.dart';
import 'package:codersgym/features/question/domain/model/contest.dart';
import 'package:codersgym/features/question/presentation/blocs/upcoming_contests/upcoming_contests_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/daily_challenge/daily_challenge_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/daily_question_card.dart';
import 'package:codersgym/features/dashboard/presentation/widgets/user_greeting_card.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: HomePageBody());
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          final dailyChallengeCubit = context.read<DailyChallengeCubit>();
          final profileCubit = context.read<UserProfileCubit>();
          final authBloc = context.read<AuthBloc>();
          final upcomingContestCubit = context.read<UpcomingContestsCubit>();
          final contestReminderCubit = context.read<ContestReminderCubit>();

          await dailyChallengeCubit.getTodayChallenge();
          await upcomingContestCubit.getUpcomingContest();
          final authState = authBloc.state;
          if (authState is Authenticated) {
            await profileCubit.getUserProfile(authState.userName);
          }
          contestReminderCubit.checkSchedulesContests();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<UserProfileCubit, ApiState<UserProfile, Exception>>(
                  buildWhen: (previous, current) =>
                      current.isLoaded ||
                      (current.isError && !previous.isLoaded),
                  builder: (context, state) {
                    return state.when(
                      onInitial: () => AppWidgetLoading(
                        child: UserGreetingCard.loading(),
                      ),
                      onLoading: (cachedData) {
                        if (cachedData == null) {
                          return UserGreetingCard.loading();
                        }
                        return UserGreetingCard(
                          userName: cachedData.realName ?? "",
                          avatarUrl: cachedData.userAvatar ?? "",
                          streak: cachedData.streakCounter,
                          isFetching: true,
                        );
                      },
                      onLoaded: (profile) {
                        return UserGreetingCard(
                          userName: profile.realName ?? "",
                          avatarUrl: profile.userAvatar ?? "",
                          streak: profile.streakCounter,
                        );
                      },
                      onError: (exception) {
                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<DailyChallengeCubit, ApiState<Question, Exception>>(
                  buildWhen: (previous, current) =>
                      current.isLoaded ||
                      current.isLoading ||
                      (current.isError && !previous.isLoaded),
                  builder: (context, state) {
                    if (state.isError) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        state.mayBeWhen(
                          onLoaded: (question) => _buildQuestionCard(
                            context,
                            question: question,
                          ),
                          onLoading: (cachedData) => cachedData != null
                              ? _buildQuestionCard(
                                  context,
                                  question: cachedData,
                                  isFetching: true,
                                )
                              : DailyQuestionCard.empty(),
                          orElse: () => AppWidgetLoading(
                            child: DailyQuestionCard.empty(),
                          ),
                        )
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Upcoming Contests",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<UpcomingContestsCubit,
                    ApiState<List<Contest>, Exception>>(
                  buildWhen: (previous, current) =>
                      current.isLoaded ||
                      (current.isError && !previous.isLoaded),
                  builder: (context, state) {
                    return state.mayBeWhen(
                      orElse: () => AppWidgetLoading(
                        child: Column(
                          children: List.generate(
                            2,
                            (index) => UpcomingContestCard.empty(),
                          ),
                        ),
                      ),
                      onLoaded: (contests) {
                        // Using column instead of listview because number of
                        // contests will always be two.
                        // Atleast for now its just two elements

                        return BlocListener<ContestReminderCubit,
                            ContestReminderState>(
                          listener: (context, state) {
                            if (state is ContestReminderLoaded) {
                              final error = state.error;
                              if (error != null) {
                                _handleScheduleFailure(context, error);
                              }
                            }
                          },
                          child: Column(
                              children: contests
                                  .map(
                                    (contest) => UpcomingContestCard(
                                      contest: contest,
                                    ),
                                  )
                                  .toList()),
                        );
                      },
                      onError: (exception) {
                        return const AppErrorWidget(
                          message: "That was not supposed to happen!!",
                          showRetryButton: false,
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context, {
    required Question question,
    bool isFetching = false,
  }) {
    return BlocBuilder<TimestampCubit, TimestampState>(
      builder: (context, state) {
        final timestamp = state.mayBeWhen(
          onLoaded: (value) => value,
          orElse: () => null,
        );
        return DailyQuestionCard(
          question: question,
          isFetching: isFetching,
          currentTime: timestamp != null
              ? DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).toInt())
              : null,
          onSolveTapped: () {
            AutoRouter.of(context).push(
              QuestionDetailRoute(question: question),
            );
          },
        );
      },
    );
  }

  void _handleScheduleFailure(BuildContext context, SetReminderError error) {
    switch (error) {
      case SetReminderError.notificationPermissionDenied:
      case SetReminderError.notificationPermissionDeniedPermanently:
        _showSettingsDialog(context);
      case SetReminderError.alarmNotificationPermissionDenied:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please allow alarm permission')),
        );
    }
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enable Notifications"),
        content: const Text(
          "Notifications are disabled. Please enable them in settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
