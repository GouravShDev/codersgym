import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/theme/app_theme.dart';
import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/common/bloc/timestamp/timestamp_cubit.dart';
import 'package:codersgym/features/common/widgets/app_loading.dart';
import 'package:codersgym/features/dashboard/presentation/blocs/contest_reminder_cubit.dart';
import 'package:codersgym/features/dashboard/presentation/widgets/feature_card.dart';
import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:codersgym/features/profile/presentation/blocs/user_profile/user_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/daily_challenge/daily_challenge_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/daily_question_card.dart';
import 'package:codersgym/features/dashboard/presentation/widgets/user_greeting_card.dart';

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
    final theme = Theme.of(context);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          final dailyChallengeCubit = context.read<DailyChallengeCubit>();
          final profileCubit = context.read<UserProfileCubit>();
          final authBloc = context.read<AuthBloc>();
          await dailyChallengeCubit.getTodayChallenge();
          final authState = authBloc.state;
          if (authState is Authenticated) {
            await profileCubit.getUserProfile(authState.userName);
          }
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
                    "Coding Toolkit",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                // Feature Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: [
                    // Upcoming Contests
                    FeatureCard(
                      icon: Icons.timer,
                      title: "Contests",
                      color: theme.colorScheme.primary,
                      onTap: () {
                        context.pushRoute(const ContestRoute());
                      },
                    ),

                    // SDE Sheets
                    FeatureCard(
                      icon: Icons.description,
                      title: "Sheets",
                      color: theme.colorScheme.secondary,
                      onTap: () {
                        context.pushRoute(const ProblemSheetListRoute());
                      },
                    ),

                    // My List
                    FeatureCard(
                      icon: Icons.bookmark,
                      title: "My List",
                      color: theme.colorScheme.successColor,
                      onTap: () {
                        final isLoginViaLeetcode = context
                            .read<AuthBloc>()
                            .isUserAuthenticatedWithLeetcodeAccount;
                        if (!isLoginViaLeetcode) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Login Required'),
                                content: const Text(
                                    'Please login with your LeetCode account to view saved list.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.router.pushAndPopUntil(
                                        const LoginRoute(),
                                        predicate: (route) => false,
                                      );
                                    },
                                    child: const Text('Go to Login'),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        context.pushRoute(const MyListRoute());
                      },
                    ),

                    // Discuss Section
                    FeatureCard(
                      icon: Icons.forum,
                      title: "Discuss",
                      color: theme.colorScheme.primary,
                      isComingSoon: true,
                      onTap: () {
                        // Navigate to discuss section
                      },
                    ),

                    // Practice
                    FeatureCard(
                      icon: Icons.code,
                      title: "Practice",
                      color: theme.colorScheme.secondary,
                      onTap: () {
                        context.tabsRouter
                            .setActiveIndex(1); // (ExploreRoute());
                      },
                    ),
                    FeatureCard(
                      icon: Icons.terminal,
                      title: "CodingEXP",
                      color: theme.colorScheme.successColor,
                      isComingSoon: true,
                      onTap: () {
                        // Navigate to practice section
                      },
                    ),
                  ],
                ),
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
                  .toLocal()
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
}
