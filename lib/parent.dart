import 'package:grouped_expansion_tile/group_base.dart';
import 'package:collection/collection.dart';

class Parent<T extends GroupBase> {
  final T self;
  Iterable<Parent<T>>? children;

  Parent({
    required this.self,
    this.children,
  });

  @override
  bool operator ==(Object other) {
    if (other is! Parent ||
        other.runtimeType != runtimeType ||
        self != other.self ||
        children?.length != other.children?.length) {
      return false;
    }
    return const IterableEquality().equals(children, other.children);
  }

  @override
  int get hashCode => self.hashCode + children.hashCode;
}
