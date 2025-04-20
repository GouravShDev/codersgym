import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/articles/domain/model/discussion_sort_option.dart';
import 'package:codersgym/features/articles/presentation/blocs/discussion/discussion_bloc.dart';
import 'package:codersgym/features/articles/presentation/blocs/discussion_tags/discussion_tags_cubit.dart';
import 'package:codersgym/features/articles/presentation/widgets/discussion_post_tile.dart';
import 'package:codersgym/features/articles/presentation/widgets/discussion_tags.dart';
import 'package:codersgym/features/common/data/models/tag.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/common/widgets/app_pagination_sliver_list.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widgets/discussion_search_bar.dart';

@RoutePage()
class DiscussPage extends HookWidget implements AutoRouteWrapper {
  const DiscussPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt.get<DiscussionBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<DiscussionTagsCubit>(),
        ),
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = useTextEditingController();
    final currentSortOption =
        useValueNotifier(DiscussionSortOption.mostRelevant);
    final currentSelectedTag = useValueNotifier<Tag?>(null);
    void fetchArticles({int? skip}) {
      context.read<DiscussionBloc>().add(
            FetchDiscussionArticlesEvent(
              skip: skip,
              first: 10,
              keywords: [searchController.text],
              orderBy: currentSortOption.value.value,
              tagSlugs: currentSelectedTag.value?.slug != null
                  ? [currentSelectedTag.value!.slug!]
                  : [],
            ),
          );
    }

    useEffect(() {
      context.read<DiscussionBloc>().add(
            FetchDiscussionArticlesEvent(),
          );
      context.read<DiscussionTagsCubit>().fetchTags();
      searchController.addListener(
        () {
          currentSortOption.value = DiscussionSortOption.mostRelevant;
          fetchArticles(skip: 0);
        },
      );
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussions'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              sliver: SliverToBoxAdapter(
                child: ValueListenableBuilder(
                  valueListenable: currentSortOption,
                  builder: (context, value, _) {
                    return DiscussionSearchBar(
                      searchController: searchController,
                      initialSortOption: DiscussionSortOption.hiddenOptions
                              .contains(currentSortOption.value)
                          ? null
                          : currentSortOption.value,
                      onSortOptionChanged: (sortOption) {
                        currentSortOption.value = sortOption;
                        fetchArticles(skip: 0);
                      },
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: BlocBuilder<DiscussionTagsCubit, DiscussionTagsState>(
              builder: (context, state) {
                return state.mayBeWhen(
                  orElse: () {
                    return const SizedBox.shrink();
                  },
                  onLoaded: (tags) {
                    return DiscussionTags(
                      initialTags: tags,
                      onTagSelected: (value) {
                        currentSelectedTag.value = value;
                        fetchArticles(skip: 0);
                      },
                    );
                  },
                );
              },
            )),
            BlocBuilder<DiscussionBloc, DiscussionState>(
              builder: (context, state) {
                if (state.isLoading && state.articles.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state.error != null) {
                  return SliverFillRemaining(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: AppErrorWidget(
                        message: state.error.toString(),
                        onRetry: () {},
                      ),
                    ),
                  );
                } else if (state.articles.isEmpty &&
                    !state.moreArticlesAvailable) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text("No articles found."),
                    ),
                  );
                } else {
                  return AppPaginationSliverList(
                    itemBuilder: (context, index) => DiscussionPostTile(
                      article: state.articles[index],
                      onCardTap: () {},
                    ),
                    itemCount: state.articles.length,
                    moreAvailable: state.moreArticlesAvailable,
                    loadMoreData: () {
                      fetchArticles();
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
