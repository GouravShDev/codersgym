import 'package:codersgym/core/theme/app_theme.dart';
import 'package:codersgym/features/code_editor/presentation/pages/code_editor_page.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TestCaseManager extends HookWidget {
  TestCaseManager({
    super.key,
    required this.testcases,
    required this.readonly,
    this.codeOutput,
    this.expectedOutput,
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
                  child: Card(
                    color: selectedTestcaseIndex.value == index
                        ? Theme.of(context).hintColor.withOpacity(0.15)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Case ${index + 1}"),
                    ),
                  ),
                );
              },
            ),
            // Limit adding to a maximum of 5 testcases
            if (currentTestcases.value.length < 5 && !readonly)
              IconButton(
                onPressed: () {
                  currentTestcases.value = List.from(currentTestcases.value)
                    ..add(
                      currentTestcases.value[selectedTestcaseIndex.value],
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
                    currentTestcases.value[selectedTestcaseIndex.value]
                            .toString() +
                        selectedTestcaseIndex.value.toString() +
                        index.toString(),
                  ),
                  initialValue: currentInput,
                  readOnly: readonly,
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
        SizedBox(
          height: 12,
        ),
        if (codeOutput != null &&
            expectedOutput != null &&
            codeOutput!.isNotEmpty &&
            expectedOutput!.isNotEmpty) ...[
          Text("Output"),
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
          SizedBox(
            height: 8,
          ),
          Text("Expected"),
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
        ],
      ],
    );
  }
}
