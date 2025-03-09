import 'package:flutter/material.dart';

/// A sliver list widget that handles pagination and loading more data when the user
/// scrolls to the end of the list.
class AppPaginationSliverList extends StatelessWidget {
  const AppPaginationSliverList({
    required this.itemBuilder,
    required this.itemCount,
    required this.moreAvailable,
    required this.loadMoreData,
    this.scrollController,
    this.loadingWidget,
    super.key,
  });

  /// Callback function to load more data when the user reaches the end of the list
  final VoidCallback loadMoreData;
  
  /// Whether there is more data available to load
  final bool moreAvailable;
  
  /// The number of items in the list
  final int itemCount;
  
  /// Optional scroll controller to control the scrolling behavior
  final ScrollController? scrollController;
  
  /// Builder function to create list items
  final Widget Function(BuildContext context, int index) itemBuilder;
  
  /// Optional widget to show when loading more data
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter.toInt() == 0) {
          // User has reached the end of the list
          loadMoreData();
        }
        return false;
      },
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index < itemCount) {
              return itemBuilder(context, index);
            } else {
              if (!moreAvailable) return const SliverToBoxAdapter(child: SizedBox.shrink());
              
              // Trigger loading more data when reaching this item
              loadMoreData();
              
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: loadingWidget ??
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
              );
            }
          },
          childCount: itemCount + (moreAvailable ? 1 : 0), // Add 1 for loading indicator if more data is available
        ),
      ),
    );
  }
}