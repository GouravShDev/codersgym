import 'dart:math';

import 'package:codersgym/core/services/analytics.dart';
import 'package:codersgym/core/theme/app_theme.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/code_editor/code_editor_bloc.dart';
import 'package:codersgym/features/common/data/models/analytics_events.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TestCaseManager extends HookWidget {
  TestCaseManager({
    super.key,
    required this.testcases,
    required this.readonly,
    this.codeOutput,
    this.expectedOutput,
    this.stdOutput,
  }) : assert(
            (codeOutput == null && expectedOutput == null) ||
                (codeOutput?.isEmpty == true &&
                    expectedOutput?.isEmpty == true) ||
                (codeOutput != null &&
                    expectedOutput != null &&
                    codeOutput.isNotEmpty &&
                    expectedOutput.isNotEmpty &&
                    codeOutput.length == expectedOutput.length &&
                    codeOutput.length == testcases.length),
            'codeOutput and expectedOutput should either both be null, '
            'both empty, or have the same length as each other and testcases. '
            'Lengths: codeOutput: ${codeOutput?.length}, '
            'expectedOutput: ${expectedOutput?.length}');

  final List<TestCase> testcases;
  final bool readonly;
  final List<String>? codeOutput;
  final List<String>? expectedOutput;
  final List<String>? stdOutput;
  @override
  Widget build(BuildContext context) {
    final currentTestcases = useState(testcases);
    final selectedTestcaseIndex = useState(0);
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide.none,
    );
    final focusInputBorder = inputBorder.copyWith(
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
      ),
    );
    useEffect(() {
      context.read<CodeEditorBloc>().add(
            CodeEditorUpdateTestcaseEvent(
              testcases: currentTestcases.value,
            ),
          );
      return null;
    }, [currentTestcases.value]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...List.generate(
              currentTestcases.value.length,
              (index) {
                // Wrap the Card with Dismissible
                return InkWell(
                  // Wrap with InkWell for tap functionality

                  onTap: () {
                    // Update the selected testcase
                    selectedTestcaseIndex.value = index;
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Card(
                        color: selectedTestcaseIndex.value == index
                            ? Theme.of(context).hintColor.withOpacity(0.15)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              if ((codeOutput?.isNotEmpty ?? false) &&
                                  (expectedOutput?.isNotEmpty ?? false)) ...[
                                Icon(
                                  Icons.circle,
                                  size: 6,
                                  color: codeOutput![index] ==
                                          expectedOutput![index]
                                      ? Theme.of(context)
                                          .colorScheme
                                          .successColor
                                      : Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                "Case ${index + 1}",
                                style: TextStyle(
                                  fontWeight:
                                      selectedTestcaseIndex.value == index
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!readonly &&
                          selectedTestcaseIndex.value == index &&
                          currentTestcases.value.length > 1)
                        InkWell(
                          onTap: () {
                            AnalyticsService().logCustomEvent(
                              name: AnalyticsEvents.removeTestCase,
                            );
                            final newTestcases = currentTestcases.value
                                .map(
                                  (e) => e.copy(),
                                )
                                .toList();
                            newTestcases.removeAt(index);
                            currentTestcases.value = newTestcases;
                            selectedTestcaseIndex.value = min(
                              newTestcases.length - 1,
                              selectedTestcaseIndex.value,
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            maxRadius: 8,
                            child: const Icon(
                              Icons.remove,
                              size: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            // Limit adding to a maximum of 5 testcases
            if (currentTestcases.value.length < 5 && !readonly)
              IconButton(
                onPressed: () {
                    AnalyticsService().logCustomEvent(
                                name: AnalyticsEvents.addTestCase,
                              );
                  currentTestcases.value = currentTestcases.value
                      .map(
                        (e) => e.copy(),
                      )
                      .toList()
                    ..add(
                      currentTestcases.value[selectedTestcaseIndex.value]
                          .copy(),
                    );
                  WidgetsBinding.instance.addPostFrameCallback(
                    (timeStamp) {
                      selectedTestcaseIndex.value =
                          currentTestcases.value.length - 1;
                    },
                  );
                },
                icon: const Icon(Icons.add),
              ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        ...List.generate(
          currentTestcases.value[selectedTestcaseIndex.value].inputs.length,
          (index) {
            final currentInput = currentTestcases
                .value[selectedTestcaseIndex.value].inputs[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text("Input ${index + 1}"),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  // Force child to rebuild when testcases changes
                  // might need to find better way
                  key: ValueKey(
                    "${currentTestcases.value.length}#${selectedTestcaseIndex.value}$index",
                  ),
                  initialValue: currentInput,
                  readOnly: readonly,
                  onChanged: (value) {
                    final newTestcases = currentTestcases.value
                        .map(
                          (e) => e.copy(),
                        )
                        .toList();
                    newTestcases[selectedTestcaseIndex.value].inputs[index] =
                        value;
                    currentTestcases.value = newTestcases;
                  },
                  decoration: InputDecoration(
                    fillColor:
                        Theme.of(context).highlightColor.withOpacity(0.1),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: focusInputBorder,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(
          height: 12,
        ),
        if (stdOutput != null && stdOutput!.isNotEmpty) ...[
          const Text("StdOutput"),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            // Force child to rebuild when testcases changes
            // might need to find better way
            key: UniqueKey(),
            initialValue: stdOutput![selectedTestcaseIndex.value],
            readOnly: readonly,
            decoration: InputDecoration(
              fillColor: Theme.of(context).highlightColor.withOpacity(0.1),
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: focusInputBorder,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
        if (codeOutput != null &&
            expectedOutput != null &&
            codeOutput!.isNotEmpty &&
            expectedOutput!.isNotEmpty) ...[
          const Text("Output"),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            // Force child to rebuild when testcases changes
            // might need to find better way
            key: UniqueKey(),
            initialValue: codeOutput![selectedTestcaseIndex.value],
            readOnly: readonly,
            style: TextStyle(
              color: codeOutput![selectedTestcaseIndex.value] ==
                      expectedOutput![selectedTestcaseIndex.value]
                  ? null // Use default color if they match
                  : Theme.of(context)
                      .colorScheme
                      .error, // Use error color if they don't match
            ),
            decoration: InputDecoration(
              fillColor: Theme.of(context).highlightColor.withOpacity(0.1),
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: focusInputBorder,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text("Expected"),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            // Force child to rebuild when testcases changes
            // might need to find better way
            key: UniqueKey(),
            initialValue: expectedOutput![selectedTestcaseIndex.value],
            readOnly: readonly,
            style: TextStyle(
              color: codeOutput![selectedTestcaseIndex.value] ==
                      expectedOutput![selectedTestcaseIndex.value]
                  ? null // Use default color if they match
                  : Theme.of(context)
                      .colorScheme
                      .successColor, // Use success color if they don't match
            ),
            decoration: InputDecoration(
              fillColor: Theme.of(context).highlightColor.withOpacity(0.1),
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: focusInputBorder,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ],
    );
  }
}
