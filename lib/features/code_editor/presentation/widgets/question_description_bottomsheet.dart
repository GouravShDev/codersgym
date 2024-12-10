import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class QuestionDescriptionBottomsheet extends StatelessWidget {
  const QuestionDescriptionBottomsheet({super.key, required this.question});
  final Question question;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            controller: controller,
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
              Text(
                'Problem Description',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              HtmlWidget(
                question.content ?? '',
                renderMode: RenderMode.column,
                textStyle: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
