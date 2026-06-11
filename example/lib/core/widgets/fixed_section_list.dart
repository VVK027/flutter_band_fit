import 'package:flutter/material.dart';

/// Builds a scrollable list from a small fixed set of sections without eager child lists.
class FixedSectionListView extends StatelessWidget {
  const FixedSectionListView({
    super.key,
    required this.sections,
    this.padding,
    this.physics,
  });

  final List<Widget> sections;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      physics: physics,
      itemCount: sections.length,
      itemBuilder: (context, index) => sections[index],
    );
  }
}
