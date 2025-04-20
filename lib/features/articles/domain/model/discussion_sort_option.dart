import 'package:codersgym/features/common/widgets/app_sort_option_dropdown.dart';
import 'package:flutter/material.dart';

class DiscussionSortOption implements ISortOption {
  @override
  final String label;
  @override
  final IconData icon;
  @override
  final Color color;
  final String value;
  const DiscussionSortOption._({
    required this.label,
    required this.icon,
    required this.value,
    required this.color,
  });
  static const DiscussionSortOption mostVotes = DiscussionSortOption._(
    label: 'Votes',
    icon: Icons.thumb_up_alt_outlined,
    value: 'MOST_VOTES',
    color: Colors.blue,
  );
  static const DiscussionSortOption newest = DiscussionSortOption._(
    label: 'Recent',
    icon: Icons.schedule,
    value: 'MOST_RECENT',
    color: Colors.green,
  );
  // Not shown to users will be used when searching in discussion
  static const DiscussionSortOption mostRelevant = DiscussionSortOption._(
    label: 'Relevant ',
    icon: Icons.abc,
    value: 'MOST_RELEVANT',
    color: Colors.black,
  );


  static List<DiscussionSortOption> get options => [mostVotes, newest];
  static List<DiscussionSortOption> get hiddenOptions => [mostRelevant];
}
