import 'package:codersgym/core/utils/custom_scroll_physics.dart';
import 'package:flutter/material.dart';

class AppScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return const SizedBox.shrink();
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const CustomPageViewScrollPhysics(
      parent: ClampingScrollPhysics(),
    );
  }
}
