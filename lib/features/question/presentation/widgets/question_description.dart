import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/core/theme/app_theme.dart';
import 'package:codersgym/core/utils/inherited_provider.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/online_user_count/online_user_count_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_content/question_content_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_hints/question_hints_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_tags/question_tags_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/similar_question/similar_question_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/question_difficulty_text.dart';
import 'package:codersgym/features/question/presentation/widgets/question_info_tile.dart';
import 'package:codersgym/features/question/presentation/widgets/question_status_icon.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class QuestionDescription extends HookWidget {
  QuestionDescription({
    Key? key,
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    final similarQuestionCubit = context.read<SimilarQuestionCubit>();
    useEffect(() {
      similarQuestionCubit.getSimilarQuestions(question);
      return null;
    }, []);
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      controller: InheritedDataProvider.of<ScrollController>(context),
      child: BlocBuilder<QuestionContentCubit, QuestionContentState>(
        builder: (context, state) {
          return state.when(
            onInitial: () => const CircularProgressIndicator(),
            onLoading: (_) => const CircularProgressIndicator(),
            onLoaded: (question) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        right: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: SelectableText(
                              ("${question.frontendQuestionId}. ") +
                                  (question.title ?? ""),
                              style: textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (question.status != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: QuestionStatusIcon(
                                status: question.status!,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        QuestionDifficultyText(question),
                        const SizedBox(
                          width: 12,
                        ),
                        BlocBuilder<OnlineUserCountCubit, OnlineUserCountState>(
                          builder: (context, state) {
                            return switch (state) {
                              OnlineUserCountConnectedState() => Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .successColor,
                                      size: 12,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      '${state.userCount} Online',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context).hintColor,
                                          ),
                                    ),
                                  ],
                                ),
                              _ => const SizedBox(
                                  height: 12,
                                )
                            };
                          },
                        ),
                        if (question.paidOnly ?? false)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Premium',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if ((question.paidOnly ?? false) &&
                        (question.content?.isEmpty ?? true))
                      _buildPremiumContentLock(context),
                    SelectionArea(
                      child: HtmlWidget(
                        question.content ?? '',
                        renderMode: RenderMode.column,
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _buildTopicTile(context),
                    _buildHintTiles(context),
                    BlocBuilder<SimilarQuestionCubit, SimilarQuestionState>(
                      bloc: similarQuestionCubit,
                      builder: (context, state) {
                        return state.when(
                          onInitial: () => const SizedBox.shrink(),
                          onLoading: (_) => const SizedBox.shrink(),
                          onLoaded: (similarQuestionList) {
                            return _buildSimilarQuestionsTiles(
                              context,
                              similarQuestionList,
                            );
                          },
                          onError: (exception) => Text(exception.toString()),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
            onError: (exception) => const AppErrorWidget(
              showRetryButton: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopicTile(BuildContext context) {
    return BlocBuilder<QuestionTagsCubit, QuestionTagsState>(
      builder: (context, state) {
        return state.when(
          onInitial: () => const SizedBox.shrink(),
          onLoading: (_) => const SizedBox.shrink(),
          onLoaded: (topicTags) {
            if (topicTags.isEmpty) {
              return const SizedBox.shrink();
            }
            return QuestionInfoTile(
              title: 'Topics',
              icon: Icons.discount_outlined,
              children: [
                Wrap(
                  spacing: 8.0,
                  children: topicTags
                      .map(
                        (e) => e.name ?? '',
                      )
                      .toList()
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: Theme.of(context).cardColor,
                              width: 1.0,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            );
          },
          onError: (exception) {
            return Text(exception.toString());
          },
        );
      },
    );
  }

  Widget _buildHintTiles(BuildContext context) {
    return BlocBuilder<QuestionHintsCubit, QuestionHintsState>(
      builder: (context, state) {
        return state.when(
          onInitial: () => const SizedBox.shrink(),
          onLoading: (_) => const SizedBox.shrink(),
          onLoaded: (hints) {
            return Column(
              children: hints.mapIndexed(
                (
                  index,
                  hint,
                ) {
                  return QuestionInfoTile(
                    title: 'Hint ${index + 1}',
                    icon: Icons.lightbulb_outline_sharp,
                    children: [
                      Text(hint),
                    ],
                  );
                },
              ).toList(),
            );
          },
          onError: (exception) => Text(
            exception.toString(),
          ),
        );
      },
    );
  }

  Widget _buildSimilarQuestionsTiles(
      BuildContext context, List<Question>? similarQuestions) {
    if (similarQuestions == null || similarQuestions.isEmpty) {
      return const SizedBox.shrink();
    }
    return QuestionInfoTile(
      title: 'Similar Questions',
      icon: Icons.sticky_note_2_rounded,
      children: similarQuestions
          .map(
            (question) => InkWell(
              onTap: () {
                AutoRouter.of(context)
                    .push(QuestionDetailRoute(question: question));
              },
              child: Card(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ).copyWith(
                    left: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          question.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      QuestionDifficultyText(
                        question,
                        showLabel: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPremiumContentLock(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock,
            size: 64,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Premium Question',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'This is a premium question available with a leetcode premium subscription.',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              context.maybePop();
            },
            child: Text(
              'Go back',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
