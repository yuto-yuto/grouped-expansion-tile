library grouped_expansion_tile;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_expansion_tile/Parent.dart';
import 'package:grouped_expansion_tile/group_base.dart';

typedef WidgetBuilder<T extends GroupBase> = Widget Function(
  Parent<T> parent,
  int depth,
);

class GroupedExpansionTile<T extends GroupBase> extends StatelessWidget {
  final Iterable<T> data;
  final WidgetBuilder<T> builder;

  const GroupedExpansionTile({
    required this.data,
    required this.builder,
    Key? key,
  }) : super(key: key);

  List<Parent<T>> _createItemTree(List<Parent<T>> parents) {
    final List<Parent<T>> nextParents = [];

    for (final parent in parents) {
      final children = data
          .where((e) => e.parent == parent.self.uid)
          .map((e) => Parent<T>(self: e))
          .toList();

      if (children.isNotEmpty) {
        parent.children = children;
        nextParents.addAll(children);
      }
    }

    if (nextParents.isNotEmpty) {
      _createItemTree(nextParents);
    }
    return parents;
  }

  Widget _createWidgetTree(Parent<T> parent, int depth) {
    final controller = TextEditingController();
    controller.text = parent.self.name;

    final Iterable<Widget> children =
        parent.children?.map((e) => _createWidgetTree(e, depth + 1)) ?? [];

    final leading = children.isEmpty ? const Icon(Icons.remove) : null;
    return ExpansionTile(
      leading: leading,
      tilePadding: EdgeInsets.only(left: depth * 20),
      initiallyExpanded: true,
      title: builder(parent, depth),
      children: children.toList(),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final topParents = data
        .where((e) => e.parent == null)
        .map((e) => Parent<T>(self: e))
        .toList();

    final tree = _createItemTree(topParents);

    final expansionTiles = tree.map((e) => _createWidgetTree(e, 0)).toList();

    return ListView.separated(
      padding: const EdgeInsets.all(5),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: expansionTiles.length,
      itemBuilder: (context, index) => expansionTiles[index],
    );
  }
}