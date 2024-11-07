import 'package:auto_route/auto_route.dart';
import 'package:dailycoder/features/common/widgets/app_loading.dart';
import 'package:dailycoder/features/profile/domain/model/user_profile.dart';
import 'package:dailycoder/features/profile/presentation/blocs/user_profile/user_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dailycoder/core/api/api_state.dart';
import 'package:dailycoder/core/routes/app_router.gr.dart';
import 'package:dailycoder/features/question/domain/model/question.dart';
import 'package:dailycoder/features/question/presentation/blocs/daily_challenge/daily_challenge_cubit.dart';
import 'package:dailycoder/features/question/presentation/widgets/daily_question_card.dart';
import 'package:dailycoder/features/dashboard/presentation/widgets/user_greeting_card.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    .headlineLarge
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
                "Upcoming Contest",
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
          ],
        ),
      ),
    );
  }
}