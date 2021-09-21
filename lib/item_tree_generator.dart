import 'package:grouped_expansion_tile/grouped_expansion_tile.dart';

List<Parent<T>> createItemTree<T extends GroupBase>(Iterable<T> data) {
  final isUnique = data.map((e) => e.uid).toSet().length == data.length;
  if (!isUnique) {
    throw ArgumentError("List must not contain the same uid.");
  }

  final topParents = data
      .where((e) => e.parent == null)
      .map((e) => Parent<T>(self: e))
      .toList();

  return _createItemTree(data, topParents);
}

List<Parent<T>> _createItemTree<T extends GroupBase>(
  Iterable<T> data,
  List<Parent<T>> parents,
) {
  for (final parent in parents) {
    final children = data
        .where((e) => e.parent == parent.self.uid)
        .map((e) => Parent<T>(self: e))
        .toList();

    if (children.isNotEmpty) {
      parent.children = children;
      _createItemTree(data, children);
    }
  }
  return parents;
}
