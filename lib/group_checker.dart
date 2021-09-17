import 'package:grouped_expansion_tile/grouped_expansion_tile.dart';

bool isDifferentGroup<T extends GroupBase>(Parent<T>? source, Parent<T>? dest) {
  if (source == null) {
    return false;
  }
  final isSelf = source.self.uid == dest?.self.uid;
  if (isSelf) {
    return false;
  }
  final hasTheChild = source.self.uid == dest?.self.parent;
  if (hasTheChild) {
    return false;
  }
  final hasTheParent = source.self.parent == dest?.self.uid;
  if (hasTheParent) {
    return false;
  }

  final children = source.children;
  if (children == null) {
    return true;
  }

  bool isChildOfChild(Iterable<Parent<T>> list) {
    final isDifferent = list.every((child) => child.self.uid != dest?.self.uid);

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
    return isChildOfChild(children);
  }

  return isChildOfChild(children);
}
