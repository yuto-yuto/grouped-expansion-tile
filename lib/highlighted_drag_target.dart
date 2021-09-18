import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_expansion_tile/drag_decoration.dart';
import 'package:grouped_expansion_tile/group_base.dart';
import 'package:grouped_expansion_tile/model/boder_notifier.dart';
import 'package:grouped_expansion_tile/parent.dart';
import 'package:provider/provider.dart';

class HighlightedDragTarget<T extends GroupBase> extends StatefulWidget {
  /// Assigned this value to one of [borders] when a dragged piece leaves a target,
  /// is accepted or rejected.
  final Border? initialBorder;
  final Parent<T>? parent;

  /// Assigned this value to one of [borders] when a dragged piece is over a widget.
  final Border? highlightedBorder;
  final Widget child;

  /// Called when an acceptable piece of [source] data was dropped over this
  /// [destination]. [draggable] must be set to true.
  /// Null [destination] means the source item wants to be top parent.
  /// [source] and [destination] are definitely different group.
  final Function(Parent<T> source, T? destination)? onAccept;

  /// Called to determine whether this widget is interested in receiving a given
  /// piece of data being dragged over this drag target.
  final DragTargetWillAccept<Parent<T>> onWillAccept;

  const HighlightedDragTarget({
    required this.child,
    required this.parent,
    required this.onWillAccept,
    Key? key,
    this.onAccept,
    this.initialBorder,
    this.highlightedBorder,
  }) : super(key: key);
  @override
  _HighlightedDragTarget<T> createState() => _HighlightedDragTarget<T>();
}

class _HighlightedDragTarget<T extends GroupBase>
    extends State<HighlightedDragTarget<T>> {
  late BorderNotifier notifier;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    notifier = BorderNotifier(_createInitialBorder());
    super.initState();
  }

  Border _createInitialBorder() {
    return widget.initialBorder ?? Border.all(color: Colors.transparent);
  }

  Border _createHighlightedBorder() {
    return widget.highlightedBorder ?? Border.all(color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    final dragTarget = DragTarget<Parent<T>>(
      builder: (context, accepted, rejected) => widget.child,
      onMove: (DragTargetDetails<Parent<T>> details) {
        if (!widget.onWillAccept(details.data)) {
          return;
        }
        notifier.border = _createHighlightedBorder();
      },
      onLeave: (source) => notifier.border = _createInitialBorder(),
      onWillAccept: widget.onWillAccept,
      onAccept: (source) {
        notifier.border = _createInitialBorder();
        widget.onAccept?.call(source, widget.parent?.self);
      },
    );

    return ChangeNotifierProvider(
      create: (context) => notifier,
      child: DragDecoration(child: dragTarget),
    );
  }
}
