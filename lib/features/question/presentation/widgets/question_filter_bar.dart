import 'package:codersgym/features/question/domain/model/problem_sort_option.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/question_filter/question_filter_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/difficulty_dropdown_button.dart';
import 'package:codersgym/features/question/presentation/widgets/question_sort_bottomsheet_button.dart';
import 'package:codersgym/features/question/presentation/widgets/topic_tags_selection_dialog_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuestionFilterBar extends HookWidget {
  const QuestionFilterBar({
    super.key,
    this.showDifficultyFilter = true,
    this.showTopicTagsFilter = true,
    this.showSortFilter = true,
    this.showResetButton = true,
    this.showHideSolvedToggle = true,
    this.showDifficultyToggle = true,
    this.onShowDifficultyToggle,
  });

  final bool showDifficultyFilter;
  final bool showTopicTagsFilter;
  final bool showSortFilter;
  final bool showResetButton;
  final bool showHideSolvedToggle;
  final bool showDifficultyToggle;
  final void Function(bool value)? onShowDifficultyToggle;

  @override
  Widget build(BuildContext context) {
    final showDifficulty = useValueNotifier(false);
    showDifficulty.addListener(
      () {
        onShowDifficultyToggle?.call(showDifficulty.value);
      },
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Difficulty filter
                if (showDifficultyFilter)
                  BlocBuilder<QuestionFilterCubit, QuestionFilterState>(
                    buildWhen: (previous, current) =>
                        previous.difficulty != current.difficulty,
                    builder: (context, state) {
                      final difficulty = state.difficulty;
                      return DifficultyDropdownButton(
                        key: ValueKey(difficulty),
                        initalValue: difficulty != null
                            ? QuestionDifficulty.fromString(difficulty)
                            : null,
                        onChange: (QuestionDifficulty difficulty) {
                          context.read<QuestionFilterCubit>().setDifficulty(
                                difficulty.slug,
                              );
                        },
                      );
                    },
                  ),

                // Topic tags filter
                if (showTopicTagsFilter)
                  BlocBuilder<QuestionFilterCubit, QuestionFilterState>(
                    buildWhen: (previous, current) =>
                        previous.topicTags != current.topicTags,
                    builder: (context, state) {
                      return TopicTagsSelectionDialogButton(
                        key: ValueKey(state.topicTags),
                        initialValue: state.topicTags,
                        onTopicTagsSelected: (Set<TopicTags> selectedTags) {
                          context.read<QuestionFilterCubit>().setTopicTags(
                                Set<TopicTags>.from(selectedTags),
                              );
                        },
                      );
                    },
                  ),

                // Sort filter
                if (showSortFilter)
                  BlocBuilder<QuestionFilterCubit, QuestionFilterState>(
                    buildWhen: (previous, current) =>
                        previous.sortOption != current.sortOption,
                    builder: (context, state) {
                      return QuestionSortBottomsheetButton(
                        key: ValueKey(state.sortOption),
                        initialValue: state.sortOption,
                        onSortOptionApply:
                            (ProblemSortOption? selectedSortOption) {
                          context.read<QuestionFilterCubit>().setSortOption(
                                selectedSortOption,
                              );
                        },
                      );
                    },
                  ),

                // Reset button
                if (showResetButton)
                  InkWell(
                    onTap: () {
                      context.read<QuestionFilterCubit>().reset();
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).cardColor,
                      ),
                      child: const Icon(
                        Icons.restart_alt,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (showDifficultyToggle || showHideSolvedToggle)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Difficulty Toggle
                  if (showDifficultyToggle)
                    ValueListenableBuilder(
                      valueListenable: showDifficulty,
                      builder: (context, _, __) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: GestureDetector(
                            onTap: () {
                              showDifficulty.value = !showDifficulty.value;
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: showDifficulty.value,
                                    onChanged: (_) {
                                      showDifficulty.value =
                                          !showDifficulty.value;
                                    },
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Show Difficulty',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  // Solved/Unsolved Toggle
                  if (showHideSolvedToggle)
                    BlocBuilder<QuestionFilterCubit, QuestionFilterState>(
                      buildWhen: (previous, current) =>
                          previous.hideSolved != current.hideSolved,
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<QuestionFilterCubit>()
                                  .toggleHideSolved();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: !state.hideSolved,
                                    onChanged: (_) {
                                      context
                                          .read<QuestionFilterCubit>()
                                          .toggleHideSolved();
                                    },
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Show Solved',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
