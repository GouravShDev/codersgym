import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:codersgym/features/question/presentation/blocs/community_post_detail/community_post_detail_cubit.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class CommunityPostPage extends HookWidget implements AutoRouteWrapper {
  const CommunityPostPage({
    super.key,
    required this.postDetail,
  });
  final CommunitySolutionPostDetail postDetail;

  @override
  Widget build(BuildContext context) {
    final communityPostCubit = context.read<CommunityPostDetailCubit>();
    useEffect(() {
      communityPostCubit.getCommunitySolutionsDetails(postDetail);
      return null;
    }, []);
    return Scaffold(
        appBar: AppBar(
          title: Text(postDetail?.title ?? 'Post detail'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              BlocBuilder<CommunityPostDetailCubit, CommunityPostDetailState>(
            builder: (context, state) {
              return state.when(
                onInitial: () => SizedBox.shrink(),
                onLoading: () => Center(child: CircularProgressIndicator()),
                onLoaded: (updatedPostDetail) {
                  return Markdown(
                    data: updatedPostDetail.post?.content ?? '',
                    onTapLink: (text, href, title) async {
                      if (href == null) return;
                      final uri = Uri.parse(href);
                      if (!await launchUrl(uri)) {
                        throw Exception('Could not launch $uri');
                      }
                    },
                    extensionSet: md.ExtensionSet(
                      md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                      <md.InlineSyntax>[
                        md.EmojiSyntax(),
                        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                      ],
                    ),
                    builders: {
                      'code': CodeElementBuilder(),
                    },
                  );
                },
                onError: (exception) => Text(exception.toString()),
              );
            },
          ),
        ));
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt.get<CommunityPostDetailCubit>(),
        ),
      ],
      child: this,
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    return SizedBox(
      child: HighlightView(
        // The original code to be highlighted
        element.textContent,

        // Specify language
        // It is recommended to give it a value for performance
        language: language,
        theme: monokaiSublimeTheme,
      ),
    );
  }
}
