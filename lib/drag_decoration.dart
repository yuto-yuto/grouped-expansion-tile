import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_expansion_tile/model/notifier.dart';
import 'package:provider/provider.dart';

class DragDecoration extends StatelessWidget {
  final Widget child;
  const DragDecoration({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Notifier<Border>>(
      builder: (context, border, child) => decorateDraggable(
        context,
        this.child,
        border.value,
      ),
    );
  }
}

Widget decorateDraggable(BuildContext context, Widget child, Border border) {
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
