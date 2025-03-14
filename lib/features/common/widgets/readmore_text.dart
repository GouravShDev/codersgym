import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;

  const ReadMoreText({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 3,
  });

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: widget.style,
          maxLines: _expanded ? null : widget.maxLines,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (_isTextOverflowing())
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Read less' : 'Read more',
              style: widget.style?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  bool _isTextOverflowing() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 32);
    
    return textPainter.didExceedMaxLines;
  }
}