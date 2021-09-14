import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_expansion_tile/parent.dart';
import 'package:grouped_expansion_tile/group_base.dart';

export 'package:grouped_expansion_tile/parent.dart';
export 'package:grouped_expansion_tile/group_base.dart';

typedef WidgetBuilder<T extends GroupBase> = Widget Function(
  Parent<T> parent,
  int depth,
);

class GroupedExpansionTile<T extends GroupBase> extends StatefulWidget {
  final Iterable<T> data;
  final WidgetBuilder<T> builder;
  final EdgeInsetsGeometry? padding;
  final ListTileControlAffinity? controlAffinity;
  final EdgeInsetsGeometry? tilePadding;
  final Function(bool, Parent<T>, int)? onExpansionChanged;
  final bool? initiallyExpanded;

  const GroupedExpansionTile({
    required this.data,
    required this.builder,
    this.padding,
    this.controlAffinity,
    this.tilePadding,
    this.onExpansionChanged,
    this.initiallyExpanded,
    Key? key,
  }) : super(key: key);

  @override
  _GroupedExpansionTile<T> createState() => _GroupedExpansionTile<T>();
}

class _GroupedExpansionTile<T extends GroupBase>
    extends State<GroupedExpansionTile<T>> {
  List<Border> _boders = [];

  List<Parent<T>> _createItemTree(List<Parent<T>> parents) {
    for (final parent in parents) {
      final children = widget.data
          .where((e) => e.parent == parent.self.uid)
          .map((e) => Parent<T>(self: e))
          .toList();

      if (children.isNotEmpty) {
        parent.children = children;
        _createItemTree(children);
      }
    }
    return parents;
  }

  Widget _createWidgetTree(BuildContext context, Parent<T> parent, int depth) {
    final Iterable<Widget> children =
        parent.children?.map((e) => _createWidgetTree(context, e, depth + 1)) ??
            [];

    final expansionTile =
        _createExpansionTile(children.toList(), parent, depth);
    final feedbackExpansionTile = _createExpansionTile([], parent, depth);

    final border = Border.all(color: Colors.transparent, width: 1);
    _boders.add(border);

    final decoratedTile = Container(
      decoration: BoxDecoration(
        border: border,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: expansionTile,
      ),
    );

    final draggable = Draggable(
      child: decoratedTile,
      feedback: Material(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: feedbackExpansionTile,
        ),
      ),
    );
    return draggable;
    // return DragTarget<T>(
    //   builder: (context, accepted, rejected) => expansionTile,
    //   onMove: ,
    // );
  }

  ExpansionTile _createExpansionTile(
    List<Widget> children,
    Parent<T> parent,
    int depth,
  ) {
    final leading = children.isEmpty ? const Icon(Icons.remove) : null;

    return ExpansionTile(
      leading: leading,
      onExpansionChanged: (bool expanded) {
        widget.onExpansionChanged?.call(expanded, parent, depth);
      },
      tilePadding: widget.tilePadding ?? EdgeInsets.only(left: depth * 20),
      initiallyExpanded: widget.initiallyExpanded ?? true,
      title: widget.builder(parent, depth),
      children: children.toList(),
      controlAffinity:
          widget.controlAffinity ?? ListTileControlAffinity.leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUnique =
        widget.data.map((e) => e.uid).toSet().length == widget.data.length;
    if (!isUnique) {
      throw Exception("List must not contain the same uid.");
    }

    final topParents = widget.data
        .where((e) => e.parent == null)
        .map((e) => Parent<T>(self: e))
        .toList();

    final tree = _createItemTree(topParents);

    final expansionTiles =
        tree.map((e) => _createWidgetTree(context, e, 0)).toList();

    return ListView.separated(
      padding: widget.padding ?? const EdgeInsets.all(5),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: expansionTiles.length,
      itemBuilder: (context, index) => expansionTiles[index],
    );
  }
}
