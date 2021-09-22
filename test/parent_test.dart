import 'package:flutter_test/flutter_test.dart';
import 'package:grouped_expansion_tile/grouped_expansion_tile.dart';

class ExtendedClass<T extends GroupBase> extends Parent<T> {
  String additional;
  final T self;
  Iterable<Parent<T>>? children;

  ExtendedClass({
    required this.additional,
    required this.self,
    this.children,
  }) : super(self: self, children: children);
}

void main() {
  group("Parent", () {
    test("should equal when both have the same GroupBase without children", () {
      final obj1 = Parent(self: GroupBase(uid: "uid"));
      final obj2 = Parent(self: GroupBase(uid: "uid"));
      expect(obj1 == obj2, true);
      expect(obj2 == obj1, true);
    });
    test("should not equal when self is different", () {
      final obj1 = Parent(self: GroupBase(uid: "uid"));
      final obj2 = Parent(self: GroupBase(uid: "uid2"));
      expect(obj1 == obj2, false);
    });
    test("should not equal when children.length is different", () {
      final obj1 = Parent(
        self: GroupBase(uid: "uid"),
        children: [
          Parent(self: GroupBase(uid: "uid")),
        ],
      );
      final obj2 = Parent(
        self: GroupBase(uid: "uid"),
        children: [
          Parent(self: GroupBase(uid: "uid")),
          Parent(self: GroupBase(uid: "uid")),
        ],
      );
      expect(obj1 == obj2, false);
    });
    test("should not equal when children.length is different", () {
      final obj1 = Parent(
        self: GroupBase(uid: "uid"),
        children: [
          Parent(self: GroupBase(uid: "uid")),
        ],
      );
      final obj2 = Parent(
        self: GroupBase(uid: "uid"),
        children: [
          Parent(self: GroupBase(uid: "uid")),
          Parent(self: GroupBase(uid: "uid")),
        ],
      );
      expect(obj1 == obj2, false);
    });
    test("should equal when having the same children", () {
      final obj1 = Parent(
        self: GroupBase(uid: "uid"),
        children: [
          Parent(self: GroupBase(uid: "uid")),
          Parent(self: GroupBase(uid: "uid2")),
        ],
      );
      final obj2 = Parent(
        self: GroupBase(uid: "uid"),
        children: [
          Parent(self: GroupBase(uid: "uid")),
          Parent(self: GroupBase(uid: "uid2")),
        ],
      );
      expect(obj1 == obj2, true);
      expect(obj2 == obj1, true);
    });
    test(
        "should not equal"
        "when one of them is inherited class", () {
      final obj1 = Parent(self: GroupBase(uid: "uid"));
      final obj2 = ExtendedClass(additional: "1", self: GroupBase(uid: "uid"));
      expect(obj1, isNot(equals(obj2)));
      expect(obj1 == obj2, false);
    });
  });
}
