import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_expansion_tile/model/boder_notifier.dart';
import 'package:provider/provider.dart';

class DragDecoration extends StatelessWidget {
  final Widget child;

  const DragDecoration({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BorderNotifier>(
      builder: (context, border, child) {
        return Container(
          decoration: BoxDecoration(
            border: border.border,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: this.child,
          ),
        );
      },
    );
  }
}
