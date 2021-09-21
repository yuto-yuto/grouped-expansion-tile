import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_expansion_tile/grouped_expansion_tile.dart';
import 'package:grouped_expansion_tile/highlighted_drag_target.dart';
import 'package:grouped_expansion_tile/model/notifier.dart';
import 'package:provider/provider.dart';

class TopParentBox<T extends GroupBase> extends StatelessWidget {
  final Widget child;
  final Border? initialBorder;
  final Border? highlightedBorder;
  final Function(Parent<T> source, T? destination)? onAccept;
  const TopParentBox({
    Key? key,
    required this.child,
    required this.initialBorder,
    required this.highlightedBorder,
    required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Notifier<bool>>(
      builder: (context, visible, child) {
        if (!visible.value) {
          return const SizedBox.shrink();
        }
        final dragTarget = HighlightedDragTarget<T>(
          child: ListTile(
            title: Center(child: this.child),
          ),
          parent: null,
          onWillAccept: (source) => true,
          initialBorder: initialBorder,
          highlightedBorder: highlightedBorder,
          onAccept: onAccept,
        );

        return dragTarget;
      },
    );
  }
}
