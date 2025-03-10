import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/question/domain/model/favorite_problemset.dart';
import 'package:codersgym/features/question/presentation/blocs/my_favorite_list/my_favorite_list_cubit.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class MyListPage extends HookWidget implements AutoRouteWrapper {
  const MyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);
    // Theme colors and text styles
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Load data effect
    useEffect(() {
      context.read<MyFavoriteListCubit>().fetchFavoriteList();
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
        bottom: TabBar(
          controller: tabController,
          dividerColor: theme.canvasColor,
          tabs: const [
            Tab(text: 'Created Favorites'),
            Tab(text: 'Saved Favorites'),
          ],
        ),
      ),
      body: BlocBuilder<MyFavoriteListCubit, MyFavoriteListState>(
        builder: (context, state) {
          return state.when(
            onInitial: () => const Center(child: CircularProgressIndicator()),
            onLoading: (cachedData) =>
                const Center(child: CircularProgressIndicator()),
            onLoaded: (lists) => TabBarView(
              controller: tabController,
              children: [
                _buildFavoritesList(context, lists.createdProblemset),
                _buildFavoritesList(context, lists.collectedProblemset),
              ],
            ),
            onError: (exception) => AppErrorWidget(
              onRetry: () {
                context.read<MyFavoriteListCubit>().fetchFavoriteList();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesList(
      BuildContext context, List<FavoriteProblemset> favoriteList) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (favoriteList.isEmpty) {
      return Center(
        child: Text(
          'No Problems found',
          style: textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      itemCount: favoriteList.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final favorite = favoriteList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              context.pushRoute(ProblemSheetDetailRoute(
                sheetId: favorite.slug,
                sheetName: favorite.name,
              ));
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildFavoriteImage(context, favorite),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          favorite.name,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              favorite.isPublicFavorite
                                  ? Icons.public
                                  : Icons.lock,
                              size: 16,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              favorite.isPublicFavorite ? 'Public' : 'Private',
                              style: textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoriteImage(
      BuildContext context, FavoriteProblemset favorite) {

    if (favorite.coverUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          favorite.coverUrl!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackImage(context, favorite);
          },
        ),
      );
    } else {
      return _buildFallbackImage(context, favorite);
    }
  }

  Widget _buildFallbackImage(
      BuildContext context, FavoriteProblemset favorite) {
    final theme = Theme.of(context);

    Color backgroundColor = favorite.coverBackgroundColor != null
        ? Color(
            int.parse(favorite.coverBackgroundColor!.replaceAll('#', '0xFF')))
        : theme.primaryColor;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: favorite.coverEmoji != null
            ? Text(
                favorite.coverEmoji!,
                style: const TextStyle(fontSize: 24),
              )
            : Text(
                favorite.name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<MyFavoriteListCubit>(),
      child: this,
    );
  }
}
