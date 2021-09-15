import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_expansion_tile/group_base.dart';
import 'package:grouped_expansion_tile/parent.dart';

export 'package:grouped_expansion_tile/group_base.dart';
export 'package:grouped_expansion_tile/parent.dart';

typedef WidgetBuilder<T extends GroupBase> = Widget Function(
  /// Item to show
  Parent<T> parent,

  /// To indicate how deep [parent] is.
  /// When it is 0 [parent] is top level item.
  /// When it is 1 [parent] is first level child.
  int depth,
);

class GroupedExpansionTile<T extends GroupBase> extends StatefulWidget {
  /// Data to be shown on the widget.
  final Iterable<T> data;

  /// The primary content of the list item. Typically a [Text] widget.
  final WidgetBuilder<T> builder;

  /// Padding to be applied to each expansion tiles.
  final EdgeInsetsGeometry padding;

  /// Typically used to force the expansion arrow icon to the tile's leading or trailing edge.
  ///
  /// By default, the value of `controlAffinity` is [ListTileControlAffinity.platform],
  /// which means that the expansion arrow icon will appear on the tile's trailing edge.
  final ListTileControlAffinity controlAffinity;

  /// Indent value for child item. The bigger this number is, the more space
  /// at left side is occupied.
  final double childIndent;

  /// Called when expansion tile is opened/closed.
  final Function(bool expanded, Parent<T> parent, int depth)?
      onExpansionChanged;

  /// Whether the expansion tile is initially expanded or not
  final bool initiallyExpanded;

  /// Assigned this value to one of [borders] when a dragged piece leaves a target,
  /// is accepted or rejected.
  final Border? initialBorder;

  /// Assigned this value to one of [borders] when a dragged piece is over a widget.
  final Border? highlightedBorder;

  /// Enable dragging. This value needs to be set to true when [onAccept] is specified.
  final bool draggable;

  /// Called when an acceptable piece of [source] data was dropped over this
  /// [destination] target. [draggable] must be set to true.
  /// Null [destination] means the source item wants to be top parent.
  final Function(Parent<T> source, T? destination)? onAccept;

  /// Top parent widget which appears at the top when drag gesture starts.
  final Widget topParent;

  const GroupedExpansionTile({
    required this.data,
    required this.builder,
    this.padding = const EdgeInsets.all(5),
    this.controlAffinity = ListTileControlAffinity.leading,
    this.childIndent = 20.0,
    this.onExpansionChanged,
    this.initiallyExpanded = true,
    this.initialBorder,
    this.highlightedBorder,
    this.onAccept,
    this.draggable = false,
    this.topParent = const Text("Top Parent"),
    Key? key,
  }) : super(key: key);

  @override
  _GroupedExpansionTile<T> createState() => _GroupedExpansionTile<T>();
}

class _GroupedExpansionTile<T extends GroupBase>
    extends State<GroupedExpansionTile<T>> {
  final Map<String, Border> _borders = <String, Border>{};
  bool _topParentVisible = false;
  Border? _parentBorder;

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
    final feedbackExpansionTile = ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: 0.8 * MediaQuery.of(context).size.width),
      child: _createExpansionTile([], parent, depth),
    );

    var border = _borders[parent.self.uid];
    if (border == null) {
      _borders[parent.self.uid] = _createInitialBorder();
      border = _borders[parent.self.uid];
    }

    final decoratedTile = _decorate(expansionTile, border!);

    if (!widget.draggable) {
      return decoratedTile;
    }

    final draggable = Draggable(
      data: parent,
      child: decoratedTile,
      feedback: Material(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: feedbackExpansionTile,
        ),
      ),
      onDragStarted: () => setState(() => _topParentVisible = true),
      onDragEnd: (details) => setState(() => _topParentVisible = false),
    );

    // This may not be good way.
    // TODO: Look for a way to update only one widget
    return DragTarget<Parent<T>>(
      builder: (context, accepted, rejected) => draggable,
      onMove: (details) {
        if (!_onWillAccept(details.data, parent)) {
          return;
        }
        setState(() {
          _borders[parent.self.uid] =
              widget.highlightedBorder ?? Border.all(color: Colors.red);
        });
      },
      onLeave: (source) {
        setState(() {
          _borders[parent.self.uid] = _createInitialBorder();
        });
      },
      onWillAccept: (source) => _onWillAccept(source, parent),
      onAccept: (source) {
        setState(() {
          _borders[parent.self.uid] = _createInitialBorder();
        });
        widget.onAccept?.call(source, parent.self);
      },
    );
  }

  bool _onWillAccept(Parent<T>? source, Parent<T> dest) {
    if (source == null) {
      return false;
    }
    if (source.self.uid == dest.self.uid) {
      return false;
    }
    final children = source.children;
    if (children == null) {
      return true;
    }
    bool isDifferentGroup(Iterable<Parent<T>> list) {
      final isDifferent =
          list.every((child) => child.self.uid != dest.self.uid);

      if (!isDifferent) {
        return false;
      }
      final children = list
          .where((child) => child.children != null)
          .map((e) => e.children)
          .expand((element) => element!);
      if (children.isEmpty) {
        return true;
      }
      return isDifferentGroup(children);
    }

    return isDifferentGroup(children);
  }

  Widget _decorate(Widget child, Border border) {
    return Container(
      decoration: BoxDecoration(
        border: border,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: child,
      ),
    );
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
        tilePadding: EdgeInsets.only(left: depth * widget.childIndent),
        initiallyExpanded: widget.initiallyExpanded,
        title: widget.builder(parent, depth),
        children: children.toList(),
        controlAffinity: widget.controlAffinity);
  }

  Border _createInitialBorder() {
    return widget.initialBorder ?? Border.all(color: Colors.transparent);
  }

  Border _createHighlightedBorder() {
    return widget.highlightedBorder ?? Border.all(color: Colors.red);
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
      padding: widget.padding,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: expansionTiles.length + 1,
      itemBuilder: (context, index) {
        if (index > 0) {
          return expansionTiles[index - 1];
        }

        if (!_topParentVisible) {
          return const SizedBox.shrink();
        }

        return DragTarget<Parent<T>>(
          builder: (context, accepted, rejected) {
            final child = ListTile(
              title: Center(child: widget.topParent),
            );
            final border = _parentBorder ?? _createInitialBorder();
            return _decorate(child, border);
          },
          onMove: (details) {
            setState(() => _parentBorder = _createHighlightedBorder());
          },
          onLeave: (data) {
            setState(() => _parentBorder = _createInitialBorder());
          },
          onAccept: (data) {
            setState(() => _parentBorder = _createInitialBorder());
            widget.onAccept?.call(data, null);
          },
        );
      },
    );
  }
}
