import 'package:flutter/material.dart';

enum CommunitySolutionSortOptionType {
  hot,
  votes,
  recent,
  // mostRelevant,
}

class CommunitySolutionSortOption {
  final CommunitySolutionSortOptionType type;
  final String value;
  final String label; // User-friendly text
  final IconData icon;
  final Color color;

  const CommunitySolutionSortOption({
    required this.type,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });
}

const defaultCommunitySolutionSortOptions = [
  CommunitySolutionSortOption(
    type: CommunitySolutionSortOptionType.hot,
    value: 'hot',
    label: 'Hot', // User-friendly text
    icon: Icons.local_fire_department,
    color: Colors.orange,
  ),
  CommunitySolutionSortOption(
    type: CommunitySolutionSortOptionType.votes,
    value: 'most_votes',
    label: 'Votes',
    icon: Icons.thumb_up_alt_outlined,
    color: Colors.blue,
  ),
  CommunitySolutionSortOption(
    type: CommunitySolutionSortOptionType.recent,
    value: 'newest_to_oldest',
    label: 'Recent',
    icon: Icons.access_time,
    color: Colors.green,
  ),
  // CommunitySolutionSortOption(
  //   type: CommunitySolutionSortOptionType.mostRelevant,
  //   value: 'most-relevant',
  //   label: 'Most Relevant',
  //   icon: Icons.star, // Adjust icon if necessary
  //   color: Colors.purple,
  // ),
];
