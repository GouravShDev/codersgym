import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

class CodingKeys extends StatelessWidget {
  const CodingKeys({super.key, required this.codeController});
  final CodeController codeController;

  Widget _buildCodingKeyButton(
      {required VoidCallback onPressed, required Widget child}) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          foregroundColor: Colors.white,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

          // You can customize other button styles here
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor.withOpacity(0.4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCodingKeyButton(
                onPressed: () {
                  final offset = codeController.selection.baseOffset;
                  codeController.insertStr("\t");
                  codeController.setCursor(
                    offset + codeController.params.tabSpaces,
                  );
                },
                child: const Text('Tab',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildCodingKeyButton(
                onPressed: () {
                  codeController.insertStr("{}");
                  codeController
                      .setCursor(codeController.selection.baseOffset - 1);
                },
                child: const Text('{}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildCodingKeyButton(
                onPressed: () {
                  codeController.insertStr("\"\"");
                  codeController
                      .setCursor(codeController.selection.baseOffset - 1);
                },
                child: const Text('""',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildCodingKeyButton(
                onPressed: () {
                  codeController.insertStr("()");
                  codeController
                      .setCursor(codeController.selection.baseOffset - 1);
                },
                child: const Text('()',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildCodingKeyButton(
                onPressed: () {
                  codeController.historyController.undo();
                },
                child: const Icon(Icons.undo),
              ),
              _buildCodingKeyButton(
                onPressed: () {
                  moveCursorToPreviousLineMaintainingColumn();
                },
                child: const Icon(Icons.arrow_upward),
              ),
              _buildCodingKeyButton(
                onPressed: () {
                  codeController.historyController.redo();
                },
                child: const Icon(Icons.redo),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCodingKeyButton(
                onPressed: () {
                  codeController.insertStr("=");
                },
                child: const Text('=',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildCodingKeyButton(
                onPressed: () {
                  codeController.insertStr("\\");
                },
                child: const Text('\\',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildCodingKeyButton(
                onPressed: () {
                  codeController.insertStr("&");
                },
                child: const Text('&',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildCodingKeyButton(
                onPressed: () {
                  codeController.insertStr(";");
                },
                child: const Text(';',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildCodingKeyButton(
                onPressed: () {
                  codeController
                      .setCursor(codeController.selection.baseOffset - 1);
                },
                child: const Icon(Icons.arrow_back),
              ),
              _buildCodingKeyButton(
                onPressed: () {
                  moveCursorToNextLineMaintainingColumn();
                },
                child: const Icon(Icons.arrow_downward),
              ),
              _buildCodingKeyButton(
                onPressed: () {
                  codeController
                      .setCursor(codeController.selection.baseOffset + 1);
                },
                child: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void moveCursorToNextLineMaintainingColumn() {
    final lines = codeController.code.lines.lines;
    final offset = codeController.selection.base.offset;

    // Find the current line index
    final currentLineIndex = lines.indexWhere(
      (line) => offset >= line.textRange.start && offset <= line.textRange.end,
    );

    // Check if there's a next line
    if (currentLineIndex < lines.length - 1) {
      final nextLine = lines[currentLineIndex + 1];
      final currentLine = lines[currentLineIndex];

      // Calculate the column offset within the current line
      final columnOffset = offset - currentLine.textRange.start;

      // Calculate the new cursor position on the next line
      final newCursorPosition = nextLine.textRange.start + columnOffset;

      // Set the cursor position
      codeController.setCursor(newCursorPosition);
    }
  }

// Function to calculate the new cursor position
  int _calculateNewCursorPosition(
      List<CodeLine> lines, int currentLineIndex, int offset, int lineOffset) {
    // Check if the target line is within bounds
    final targetLineIndex = currentLineIndex + lineOffset;
    if (targetLineIndex < 0 || targetLineIndex >= lines.length) {
      return offset; // Return the original offset if out of bounds
    }

    final targetLine = lines[targetLineIndex];
    final currentLine = lines[currentLineIndex];

    // Calculate the column offset within the current line
    final columnOffset = offset - currentLine.textRange.start;

    // Calculate the new cursor position on the target line
    var newCursorPosition = targetLine.textRange.start + columnOffset;

    // Handle empty target lines
    if (targetLine.text.isEmpty) {
      newCursorPosition = targetLine.textRange.start;
    } else {
      // Ensure the new cursor position is within the line's bounds
      final lineEndOffset = targetLine.textRange.end;
      newCursorPosition =
          newCursorPosition.clamp(targetLine.textRange.start, lineEndOffset);
    }

    // Set selection affinity explicitly
    codeController.setCursor(newCursorPosition);

    return newCursorPosition;
  }

  void moveCursorToPreviousLineMaintainingColumn() {
    final lines = codeController.code.lines.lines;
    final offset = codeController.selection.base.offset;

    // Find the current line index
    final currentLineIndex = lines.indexWhere(
      (line) => offset >= line.textRange.start && offset <= line.textRange.end,
    );

    // Check if there's a previous line
    if (currentLineIndex > 0) {
      // Calculate the new cursor position using the common function
      final newCursorPosition =
          _calculateNewCursorPosition(lines, currentLineIndex, offset, -1);

      // Set the cursor position
      codeController.setCursor(newCursorPosition);
    }
  }
}
