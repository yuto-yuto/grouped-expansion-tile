import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_expansion_tile/drag_decoration.dart';
import 'package:grouped_expansion_tile/group_base.dart';
import 'package:grouped_expansion_tile/group_checker.dart';
import 'package:grouped_expansion_tile/highlighted_drag_target.dart';
import 'package:grouped_expansion_tile/model/notifier.dart';
import 'package:grouped_expansion_tile/parent.dart';
import 'package:grouped_expansion_tile/top_parent_box.dart';
import 'package:provider/provider.dart';

export 'package:grouped_expansion_tile/group_base.dart';
export 'package:grouped_expansion_tile/parent.dart';
export 'package:grouped_expansion_tile/group_checker.dart';

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
  /// [destination]. [draggable] must be set to true.
  /// Null [destination] means the source item wants to be top parent.
  /// [source] and [destination] are definitely different group.
  final Function(Parent<T> source, T? destination)? onAccept;

  /// Top parent widget which appears at the bottom when drag gesture starts.
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
  final Notifier<bool> _topParentVisibleNotifier = Notifier(false);
  final Notifier<bool> _draggableNotifier = Notifier(false);
  final ScrollController _scroller = ScrollController();
  final _listViewKey = GlobalKey();

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

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

    final decoratedTile = decorateDraggable(
      context,
      expansionTile,
      _createInitialBorder(),
    );

    if (!widget.draggable) {
      return decoratedTile;
    }

    return HighlightedDragTarget<T>(
      child: expansionTile,
      parent: parent,
      onWillAccept: (source) => isDifferentGroup(source, parent),
      initialBorder: widget.initialBorder,
      highlightedBorder: widget.highlightedBorder,
      onAccept: widget.onAccept,
    );
  }

  ExpansionTile _createExpansionTile(
    List<Widget> children,
    Parent<T> parent,
    int depth,
  ) {
    Widget? _buildDraggableIcon() {
      if (!widget.draggable) {
        return null;
      }
      final feedbackExpansionTile = Material(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 0.7 * MediaQuery.of(context).size.width,
          ),
          child: widget.builder(parent, depth),
        ),
      );

      return Draggable(
        data: parent,
        child: const Icon(Icons.dehaze_sharp),
        feedback: feedbackExpansionTile,
        onDragStarted: () {
          _topParentVisibleNotifier.value = true;
          _draggableNotifier.value = true;
        },
        onDragEnd: (details) {
          _topParentVisibleNotifier.value = false;
          _draggableNotifier.value = false;
        },
      );
    }

    Widget? _buildLeadingIcon() {
      if (widget.controlAffinity != ListTileControlAffinity.leading) {
        return _buildDraggableIcon();
      }
      return children.isEmpty ? const Icon(Icons.remove) : null;
    }

    Widget? _buildTrailingIcon() {
      if (widget.controlAffinity == ListTileControlAffinity.leading) {
        return _buildDraggableIcon();
      }
      return children.isEmpty ? const Icon(Icons.remove) : null;
    }

    return ExpansionTile(
      leading: _buildLeadingIcon(),
      trailing: _buildTrailingIcon(),
      onExpansionChanged: (bool expanded) {
        widget.onExpansionChanged?.call(expanded, parent, depth);
      },
      tilePadding: EdgeInsets.only(left: depth * widget.childIndent),
      initiallyExpanded: widget.initiallyExpanded,
      title: widget.builder(parent, depth),
      children: children.toList(),
      controlAffinity: widget.controlAffinity,
    );
  }

  Border _createInitialBorder() {
    return widget.initialBorder ?? Border.all(color: Colors.transparent);
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

    final listView = ListView.separated(
      key: _listViewKey,
      controller: _scroller,
      padding: widget.padding,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: expansionTiles.length + 1,
      itemBuilder: (context, index) {
        if (index != expansionTiles.length) {
          return expansionTiles[index];
        }
        return const SizedBox(height: 150);
      },
    );

    final listener = Consumer<Notifier<bool>>(
      builder: (context, idDragging, child) => Listener(
        child: listView,
        onPointerMove: (PointerMoveEvent event) {
          if (!_draggableNotifier.value) {
            return;
          }
          RenderBox render =
              _listViewKey.currentContext?.findRenderObject() as RenderBox;
          Offset position = render.localToGlobal(Offset.zero);
          double topY = position.dy;
          double bottomY = topY + render.size.height;

          const detectedRange = 100;
          const moveDistance = 3;

          if (event.position.dy < topY + detectedRange) {
            var to = _scroller.offset - moveDistance;
            to = (to < 0) ? 0 : to;
            _scroller.jumpTo(to);
          }
          if (event.position.dy > bottomY - detectedRange) {
            _scroller.jumpTo(_scroller.offset + moveDistance);
          }
        },
      ),
    );

    final topParentBox = TopParentBox(
      child: widget.topParent,
      initialBorder: widget.initialBorder,
      highlightedBorder: widget.highlightedBorder,
      onAccept: widget.onAccept,
    );

    final topParentBoxProvider = ChangeNotifierProvider.value(
      value: _topParentVisibleNotifier,
      builder: (context, widget) => topParentBox,
    );

    return ChangeNotifierProvider.value(
      value: _draggableNotifier,
      child: Column(
        children: [
          Expanded(child: listener),
          topParentBoxProvider,
        ],
      ),
    );
  }
}
