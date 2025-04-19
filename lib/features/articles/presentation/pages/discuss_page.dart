import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/articles/presentation/blocs/discussion/discussion_bloc.dart';
import 'package:codersgym/features/articles/presentation/widgets/discussion_post_tile.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/common/widgets/app_pagination_sliver_list.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/discussion_search_bar.dart';

@RoutePage()
class DiscussPage extends StatefulWidget implements AutoRouteWrapper {
  const DiscussPage({super.key});

  @override
  State<DiscussPage> createState() => _DiscussPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<DiscussionBloc>(),
      child: this,
    );
  }
}

class _DiscussPageState extends State<DiscussPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    context.read<DiscussionBloc>().add(
          FetchDiscussionArticlesEvent(),
        );
  }

  @override
  Widget build(BuildContext context) {
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
                child: DiscussionSearchBar(
                  searchController: _searchController,
                  onChanged: (value) {
                    context.read<DiscussionBloc>().add(
                          FetchDiscussionArticlesEvent(
                            skip: 0,
                            first: 20,
                            keywords: [value],
                          ),
                        );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Chip(
                    label: Text("Tag 1"),
                  ),
                  SizedBox(width: 8),
                  Chip(
                    label: Text("Tag 2"),
                  ),
                ],
              ),
            ),
            BlocBuilder<DiscussionBloc, DiscussionState>(
              builder: (context, state) {
                if (state.isLoading) {
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
                } else if (state.articles.isEmpty) {
                  return SliverFillRemaining(
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
                      BlocProvider.of<DiscussionBloc>(context).add(
                        FetchDiscussionArticlesEvent(
                            skip: state.articles.length),
                      );
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
