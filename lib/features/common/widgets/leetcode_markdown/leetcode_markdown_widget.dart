import 'package:codersgym/features/common/widgets/leetcode_markdown/element_builders.dart';
import 'package:codersgym/features/common/widgets/leetcode_markdown/iframe_block_syntax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown/src/extension_set.dart' as md;
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:url_launcher/url_launcher.dart';

class LeetcodeMarkdownWidget extends StatelessWidget {
  const LeetcodeMarkdownWidget({
    super.key,
    this.controller,
    this.assetsBaseUrl,
    this.shrinkWrap,
    this.physics,
    required this.data,
  });

  final ScrollController? controller;
  final String? assetsBaseUrl;
  final String data;
  final bool? shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Markdown(
      selectable: true,
      physics: physics,
      shrinkWrap: shrinkWrap ?? false,
      imageBuilder: (uri, title, alt) {
        final normalizedUri = uri.replace(
          pathSegments: uri.pathSegments.where((e) => e != '..').toList(),
        );

        final String imageUrl = normalizedUri.hasScheme
            ? normalizedUri.toString()
            : '$assetsBaseUrl/${normalizedUri.path}';

        if (imageUrl.endsWith('.svg')) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 800),
            color: Theme.of(context).colorScheme.onSurface,
            child: SvgPicture.network(
              imageUrl,
              placeholderBuilder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          );
        }

        return Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Image.network(
            imageUrl,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image, size: 50);
            },
          ),
        );
      },
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      controller: controller,
      styleSheet: MarkdownStyleSheet(
        // Text Styles
        h1: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),

        h2: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        h3: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        p: TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface,
          height: 1.5,
        ),
        strong: const TextStyle(fontWeight: FontWeight.bold),
        em: const TextStyle(fontStyle: FontStyle.italic),

        codeblockPadding: const EdgeInsets.all(16),
        codeblockDecoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),

        // Blockquotes
        blockquote: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.8),
          fontSize: 16,
          height: 1.5,
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: theme.primaryColor,
              width: 4,
            ),
          ),
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        blockquotePadding: const EdgeInsets.all(16),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: theme.primaryColor,
              width: 4,
            ),
          ),
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        // Lists
        listBullet: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 16,
        ),
        listIndent: 24,

        // Tables
        tableHead: TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        tableBorder: TableBorder.all(
          color: theme.colorScheme.outline,
          width: 1,
        ),
        tableColumnWidth: const FlexColumnWidth(),
        tableCellsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
      onTapLink: (text, href, title) async {
        if (href != null) {
          final uri = Uri.parse(href);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        }
      },
      builders: {
        // 'code': CodeElementBuilder(),
        // 'code': HighLightBuilder(),
        'latex': LatexElementBuilder(),
        'video-container': VideoContainerBuilder(),
        'iframe': IframeElementBuilder(),
      },
      extensionSet: md.ExtensionSet(
        [
          LatexBlockSyntax(),
          IframeBlockSyntax(),
          md.FencedCodeBlockSyntax(),
          const md.TableSyntax(),
        ],
        [
          LatexInlineSyntax(),
          md.EmojiSyntax(),
        ],
      ),
      data: data,
    );
  }
}
