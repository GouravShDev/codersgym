import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/articles/domain/model/discussion_article.dart';
import 'package:codersgym/features/articles/presentation/blocs/discussion/discussion_bloc.dart';
import 'package:codersgym/features/articles/presentation/blocs/discussion_filter/discussion_filter_cubit.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/common/widgets/app_pagination_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class DiscussionPage extends HookWidget {
  const DiscussionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final discussionCubit = context.read<DiscussionBloc>();
    final discussionFilterCubit = context.read<DiscussionFilterCubit>();
    
    useEffect(
      () {
        discussionFilterCubit.fetchDiscussionCategories();
        discussionCubit.add(
          FetchDiscussionListEvent(
            categoryTags: discussionFilterCubit.state.selectedCategoryTags,
            orderBy: discussionFilterCubit.state.sortOption,
            searchQuery: discussionFilterCubit.state.searchQuery,
            skip: 0,
          ),
        );
        return null;
      },
      [],
    );
    
    return BlocListener<DiscussionFilterCubit, DiscussionFilterState>(
      listener: (context, state) {
        discussionCubit.add(
          FetchDiscussionListEvent(
            categoryTags: state.selectedCategoryTags,
            orderBy: state.sortOption,
            searchQuery: state.searchQuery,
            skip: 0,
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Discussions'),
          elevation: 0,
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            // Categories section
            BlocBuilder<DiscussionFilterCubit, DiscussionFilterState>(
              builder: (context, state) {
                if (state.isCategoriesLoading) {
                  return const SizedBox(
                    height: 48,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                return SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: state.availableCategories.length,
                    itemBuilder: (context, index) {
                      final category = state.availableCategories[index];
                      final isSelected = state.selectedCategoryTags.contains(category.slug);
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category.name??''),
                          selected: isSelected,
                          onSelected: (selected) {
                            final newSelectedCategories = {...state.selectedCategoryTags};
                            if (selected) {
                              newSelectedCategories.add(category);
                            } else {
                              newSelectedCategories.remove(category);
                            }
                            
                            discussionFilterCubit.updateFilters(
                              categoryTags: newSelectedCategories,
                              searchQuery: state.searchQuery,
                              sortOption: state.sortOption,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            
            // Filter widget with padding
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              alignment: Alignment.topCenter,
              child: BlocBuilder<DiscussionFilterCubit, DiscussionFilterState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4)
                        .add(const EdgeInsets.only(top: 4)),
                    child: DiscussionFilterSearchBar(
                      initialSearchQuery: state.searchQuery,
                      initialSortOption: state.sortOption,
                      onFiltersChanged: ({
                        required searchQuery,
                        required sortOption,
                      }) {
                        discussionFilterCubit.updateFilters(
                          categoryTags: state.selectedCategoryTags,
                          searchQuery: searchQuery,
                          sortOption: sortOption,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Discussion posts list
            BlocBuilder<DiscussionBloc, DiscussionState>(
              builder: (context, state) {
                final discussions = state.discussions;
                
                if (state.isLoading && discussions.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                if (state.error != null) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: AppErrorWidget(
                      onRetry: () {
                        discussionFilterCubit.fetchDiscussionCategories();
                        discussionCubit.add(
                          FetchDiscussionListEvent(
                            categoryTags: discussionFilterCubit.state.selectedCategoryTags,
                            orderBy: discussionFilterCubit.state.sortOption,
                            searchQuery: discussionFilterCubit.state.searchQuery,
                            skip: 0,
                          ),
                        );
                      },
                    ),
                  );
                }
                
                if (discussions.isEmpty && !state.moreDiscussionsAvailable) {
                  return const Expanded(
                    child: Center(
                      child: NoDiscussionStateWidget(),
                    ),
                  );
                }
                
                return Expanded(
                  child: AppPaginationList(
                    itemBuilder: (context, index) {
                      final discussion = discussions[index];
                      return DiscussionPostTile(
                        discussion: discussion,
                        onCardTap: () {
                          // AutoRouter.of(context).push(
                          //   DiscussionDetailRoute(
                          //     discussionSlug: discussion.slug,
                          //     discussionUuid: discussion.uuid,
                          //   ),
                          // );
                        },
                      );
                    },
                    itemCount: discussions.length,
                    moreAvailable: state.moreDiscussionsAvailable,
                    loadMoreData: () {
                      discussionCubit.add(
                        FetchDiscussionListEvent(
                          categoryTags: discussionFilterCubit.state.selectedCategoryTags,
                          orderBy: discussionFilterCubit.state.sortOption,
                          searchQuery: discussionFilterCubit.state.searchQuery,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NoDiscussionStateWidget extends StatelessWidget {
  const NoDiscussionStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// Discussion Post Tile Widget
class DiscussionPostTile extends StatelessWidget {
  final DiscussionArticle discussion;
  final VoidCallback onCardTap;

  const DiscussionPostTile({
    super.key,
    required this.discussion,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 1,
      child: InkWell(
        onTap: onCardTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      discussion.author?.userAvatar??'',
                    ),
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          discussion.author?.realName??'',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   timeAgo(discussion?.createdAt),
                        //   style: theme.textTheme.bodySmall?.copyWith(
                        //     color: theme.colorScheme.onSurface.withOpacity(0.6),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                discussion.title??'',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                discussion.summary ?? '',
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final tag in (discussion.tags ?? []) )
                    Chip(
                      label: Text(tag.name),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelStyle: theme.textTheme.bodySmall,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.thumb_up_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  // Text(
                  //   getReactionCount(discussion.reactions, 'UPVOTE').toString(),
                  //   style: theme.textTheme.bodySmall,
                  // ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.comment_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  // Text(
                  //   discussion?.tags?.topLevelCommentCount?.toString() ?? '',
                  //   style: theme.textTheme.bodySmall,
                  // ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.visibility_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    discussion.hitCount.toString(),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // int getReactionCount(List<Reaction> reactions, String type) {
  //   final reaction = reactions.firstWhere(
  //     (r) => r.reactionType == type,
  //     orElse: () => Reaction(count: 0, reactionType: type),
  //   );
  //   return reaction.count;
  // }
  
  String timeAgo(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
}

// Custom Filter and Search Bar
class DiscussionFilterSearchBar extends StatefulWidget {
  final String initialSearchQuery;
  final String initialSortOption;
  final Function({
    required String searchQuery,
    required String sortOption,
  }) onFiltersChanged;

  const DiscussionFilterSearchBar({
    super.key,
    required this.initialSearchQuery,
    required this.initialSortOption,
    required this.onFiltersChanged,
  });

  @override
  State<DiscussionFilterSearchBar> createState() => _DiscussionFilterSearchBarState();
}

class _DiscussionFilterSearchBarState extends State<DiscussionFilterSearchBar> {
  late TextEditingController _searchController;
  late String _sortOption;
  final List<String> _sortOptions = ['recent', 'popular', 'recommend'];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearchQuery);
    _sortOption = widget.initialSortOption;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search discussions',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onSubmitted: (value) {
                    widget.onFiltersChanged(
                      searchQuery: value,
                      sortOption: _sortOption,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _sortOption,
                  isDense: true,
                  icon: const Icon(Icons.sort),
                  items: _sortOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _sortOption = newValue;
                      });
                      widget.onFiltersChanged(
                        searchQuery: _searchController.text,
                        sortOption: newValue,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

