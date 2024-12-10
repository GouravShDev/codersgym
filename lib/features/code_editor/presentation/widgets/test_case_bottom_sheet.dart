import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/test_case_manager.dart';
import 'package:codersgym/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';

class TestCaseBottomSheet extends StatelessWidget {
  final List<TestCase> testcases;
  final VoidCallback onRunCode;
  const TestCaseBottomSheet({
    super.key,
    required this.testcases,
    required this.onRunCode,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.6,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          // Moves input sheet up when keyboard is opened
          padding: MediaQuery.of(context).viewInsets,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              controller: scrollController,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // Header
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Testcases',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     // Run Test Cases Button
                      //     OutlinedButton.icon(
                      //       onPressed: () {
                      //         context.maybePop();
                      //         onRunCode();
                      //       },
                      //       icon: const Icon(Icons.play_arrow),
                      //       label: const Text('Run Code'),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),

                TestCaseManager(
                  testcases: testcases,
                  readonly: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
