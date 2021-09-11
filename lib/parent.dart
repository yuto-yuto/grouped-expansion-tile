import 'package:grouped_expansion_tile/group_base.dart';

class Parent<T extends GroupBase> {
  final T self;
  Iterable<Parent<T>>? children;

  Parent({
    required this.self,
    this.children,
  });
}
