import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DragDecoration extends StatelessWidget {
  final Widget child;
  final Border? border;

  const DragDecoration({
    Key? key,
    required this.child,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
