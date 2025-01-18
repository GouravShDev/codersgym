import 'package:codersgym/features/code_editor/domain/model/coding_key_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

class CodingKeys extends StatefulWidget {
  const CodingKeys({
    super.key,
    required this.codeController,
    required this.codingKeyIds,
  });
  final CodeController codeController;
  final List<String> codingKeyIds;

  @override
  State<CodingKeys> createState() => _CodingKeysState();

  factory CodingKeys.empty() {
    return CodingKeys(
        codeController: CodeController(),
        codingKeyIds: List.generate(
          7 * 4,
          (index) => MultiplyCodingKeyConfig.ID,
        ));
  }
}

class _CodingKeysState extends State<CodingKeys> with TickerProviderStateMixin {
  late TabController _tabController;
  final int keysPerRow = 7;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildCodingKeyButton({
    required CodingKeyConfig? codingKey,
  }) {
    // ignore: prefer_const_constructors
    if (codingKey == null) return SizedBox.shrink();
    final child = switch (codingKey) {
      CodingTextKeyConfig() => Text(
          codingKey.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      CodingIconKeyConfig() => Icon(
          codingKey.icon,
        ),
    };
    return Expanded(
      child: TextButton(
        onPressed: () {
          final action = resolveCodingKeyAction(codingKey);
          action.call();
        },
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          foregroundColor: Colors.white,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        child: child,
      ),
    );
  }

  Widget _buildBasicKeysTab() {
    /// Element from 0 - 6 in [codingKeyIds]
    final firstRow = widget.codingKeyIds.sublist(0, keysPerRow);

    /// Element from 7 - 13 in [codingKeyIds]
    final secondRow = widget.codingKeyIds.sublist(keysPerRow, keysPerRow * 2);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: firstRow
              .map(
                (e) => _buildCodingKeyButton(
                  codingKey: CodingKeyConfig.lookupMap[e]?.call(),
                ),
              )
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: secondRow
              .map(
                (e) => _buildCodingKeyButton(
                  codingKey: CodingKeyConfig.lookupMap[e]?.call(),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAdvancedKeysTab() {
    /// Element from 14 - 20 in [codingKeyIds]
    final thirdRow =
        widget.codingKeyIds.sublist(keysPerRow * 2, keysPerRow * 3);

    /// Element from 21 - 27 in [codingKeyIds]
    final forthRow =
        widget.codingKeyIds.sublist(keysPerRow * 3, keysPerRow * 4);
    return Column(
      children: [
        // Row 1: Additional brackets and quotes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: thirdRow
              .map(
                (e) => _buildCodingKeyButton(
                  codingKey: CodingKeyConfig.lookupMap[e]?.call(),
                ),
              )
              .toList(),
        ),
        // Row 2: Mathematical and logical operators
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: forthRow
              .map(
                (e) => _buildCodingKeyButton(
                  codingKey: CodingKeyConfig.lookupMap[e]?.call(),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.codingKeyIds.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      color: Theme.of(context).cardColor.withOpacity(0.4),
      height: 78,
      child: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicKeysTab(),
                _buildAdvancedKeysTab(),
              ],
            ),
          ),
          _buildAnimatedIndicator(),
        ],
      ),
    );
  }

  VoidCallback resolveCodingKeyAction(CodingKeyConfig codingKey) {
    return switch (codingKey) {
      TabCodingKeyConfig() => () {
          final offset = widget.codeController.selection.baseOffset;
          widget.codeController.insertStr("\t");
          widget.codeController
              .setCursor(offset + widget.codeController.params.tabSpaces);
        },
      CurlyCodingKeyConfig() => () {
          widget.codeController.insertStr("{}");
          widget.codeController
              .setCursor(widget.codeController.selection.baseOffset - 1);
        },
      ParenthesesCodingKeyConfig() => () {
          widget.codeController.insertStr("()");
          widget.codeController
              .setCursor(widget.codeController.selection.baseOffset - 1);
        },
      BracketsCodingKeyConfig() => () {
          widget.codeController.insertStr("[]");
          widget.codeController
              .setCursor(widget.codeController.selection.baseOffset - 1);
        },
      AngleCodingKeyConfig() => () {
          widget.codeController.insertStr("<>");
          widget.codeController
              .setCursor(widget.codeController.selection.baseOffset - 1);
        },
      DoubleQuoteCodingKeyConfig() => () {
          widget.codeController.insertStr('""');
          widget.codeController
              .setCursor(widget.codeController.selection.baseOffset - 1);
        },
      SingleQuoteCodingKeyConfig() => () {
          widget.codeController.insertStr("''");
          widget.codeController
              .setCursor(widget.codeController.selection.baseOffset - 1);
        },
      UndoCodingKeyConfig() => () =>
          widget.codeController.historyController.undo(),
      RedoCodingKeyConfig() => () =>
          widget.codeController.historyController.redo(),
      UpArrowCodingKeyConfig() => () =>
          moveCursorToPreviousLineMaintainingColumn(),
      DownArrowCodingKeyConfig() => () =>
          moveCursorToNextLineMaintainingColumn(),
      LeftArrowCodingKeyConfig() => () {
          widget.codeController
              .setCursor(widget.codeController.selection.baseOffset - 1);
        },
      RightArrowCodingKeyConfig() => () {
          widget.codeController
              .setCursor(widget.codeController.selection.baseOffset + 1);
        },
      PipeCodingKeyConfig() => () => widget.codeController.insertStr("|"),
      AmpersandCodingKeyConfig() => () => widget.codeController.insertStr("&"),
      UnderscoreCodingKeyConfig() => () => widget.codeController.insertStr("_"),
      SemicolonCodingKeyConfig() => () => widget.codeController.insertStr(";"),
      ExclamationCodingKeyConfig() => () =>
          widget.codeController.insertStr("!"),
      QuestionCodingKeyConfig() => () => widget.codeController.insertStr("?"),
      ColonCodingKeyConfig() => () => widget.codeController.insertStr(":"),
      BackslashCodingKeyConfig() => () => widget.codeController.insertStr("\\"),
      PlusCodingKeyConfig() => () => widget.codeController.insertStr("+"),
      MinusCodingKeyConfig() => () => widget.codeController.insertStr("-"),
      MultiplyCodingKeyConfig() => () => widget.codeController.insertStr("*"),
      DivideCodingKeyConfig() => () => widget.codeController.insertStr("/"),
      ModuloCodingKeyConfig() => () => widget.codeController.insertStr("%"),
      EqualsCodingKeyConfig() => () => widget.codeController.insertStr("="),
      CaretCodingKeyConfig() => () => widget.codeController.insertStr("^"),
    };
  }

  Widget _buildAnimatedIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: AnimatedBuilder(
        animation: _tabController.animation!,
        builder: (context, child) {
          return SizedBox(
            width: 52,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 2.4,
                        width: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.centerLeft,
                  child: Transform.translate(
                    offset: Offset((_tabController.animation!.value * 20), 0),
                    child: Container(
                      height: 2.4,
                      width: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void moveCursorToNextLineMaintainingColumn() {
    final lines = widget.codeController.code.lines.lines;
    final offset = widget.codeController.selection.base.offset;

    final currentLineIndex = lines.indexWhere(
      (line) => offset >= line.textRange.start && offset <= line.textRange.end,
    );

    if (currentLineIndex < lines.length - 1) {
      _calculateNewCursorPosition(lines, currentLineIndex, offset, 1);
    }
  }

  void moveCursorToPreviousLineMaintainingColumn() {
    final lines = widget.codeController.code.lines.lines;
    final offset = widget.codeController.selection.base.offset;

    final currentLineIndex = lines.indexWhere(
      (line) => offset >= line.textRange.start && offset <= line.textRange.end,
    );

    if (currentLineIndex > 0) {
      _calculateNewCursorPosition(lines, currentLineIndex, offset, -1);
    }
  }

  void _calculateNewCursorPosition(
    List<CodeLine> lines,
    int currentLineIndex,
    int offset,
    int lineOffset,
  ) {
    final targetLineIndex = currentLineIndex + lineOffset;
    if (targetLineIndex < 0 || targetLineIndex >= lines.length) {
      return;
    }

    final targetLine = lines[targetLineIndex];
    final currentLine = lines[currentLineIndex];
    final columnOffset = offset - currentLine.textRange.start;
    var newCursorPosition = targetLine.textRange.start + columnOffset;

    if (targetLine.text.isEmpty) {
      newCursorPosition = targetLine.textRange.start;
    } else {
      final lineEndOffset = targetLine.textRange.end;
      newCursorPosition = newCursorPosition.clamp(
        targetLine.textRange.start,
        lineEndOffset,
      );
    }

    widget.codeController.setCursor(newCursorPosition);
  }
}
