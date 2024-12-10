import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/common/widgets/app_loading.dart';
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<UserProfileCubit, ApiState<UserProfile, Exception>>(
                builder: (context, state) {
                  return state.when(
                    onInitial: () => const CircularProgressIndicator(),
                    onLoading: () {
                      return AppWidgetLoading(
                        child: UserGreetingCard.loading(),
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
                      return Text(exception.toString());
                    },
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Ready For Today's Challenge",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<DailyChallengeCubit, ApiState<Question, Exception>>(
                builder: (context, state) {
                  return state.when(
                    onInitial: () => const CircularProgressIndicator(),
                    onLoading: () => AppWidgetLoading(
                      child: DailyQuestionCard.empty(),
                    ),
                    onLoaded: (question) {
                      return DailyQuestionCard(
                        question: question,
                        onSolveTapped: () {
                          AutoRouter.of(context).push(
                            QuestionDetailRoute(question: question),
                          );
                        },
                      );
                    },
                    onError: (exception) {
                      return Text(exception.toString());
                    },
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                builder: (context, state) {
                  return state.when(
                    onInitial: () => const CircularProgressIndicator(),
                    onLoading: () => AppWidgetLoading(
                      child: UpcomingContestCard.empty(),
                    ),
                    onLoaded: (contests) {
                      // Using column instead of listview because number of
                      // contests will always be two.
                      // Atleast for now its just two elements

                      return Column(
                          children: contests
                              .map(
                                (contest) => UpcomingContestCard(
                                  contest: contest,
                                ),
                              )
                              .toList());
                    },
                    onError: (exception) {
                      return Text(exception.toString());
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
