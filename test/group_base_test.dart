import 'package:flutter_test/flutter_test.dart';
import 'package:grouped_expansion_tile/grouped_expansion_tile.dart';

class ExtendedClass extends GroupBase {
  String additional;
  ExtendedClass({
    required this.additional,
    required String uid,
    String? parent,
  }) : super(uid: uid, parent: parent);
}

void main() {
  group("GroupBase", () {
    test("should not equal when one of them is String", () {
      final obj1 = GroupBase(uid: "uid");
      const obj2 = "uid";
      // ignore: unrelated_type_equality_checks
      expect(obj1 == obj2, false);
    });
    test("should equal when both have the same uid", () {
      final obj1 = GroupBase(uid: "uid");
      final obj2 = GroupBase(uid: "uid");
      expect(obj1 == obj2, true);
      expect(obj2 == obj1, true);
    });
    test("should equal when both have the same uid and parent", () {
      final obj1 = GroupBase(uid: "uid", parent: "1");
      final obj2 = GroupBase(uid: "uid", parent: "1");
      expect(obj1 == obj2, true);
    });
    test("should not equal when they have the different uid", () {
      final obj1 = GroupBase(uid: "uid");
      final obj2 = GroupBase(uid: "uid-2");
      expect(obj1 == obj2, false);
      expect(obj2 == obj1, false);
    });
    test(
        "should not equal"
        "when they have the same uid but different parent", () {
      final obj1 = GroupBase(uid: "uid", parent: "1");
      final obj2 = GroupBase(uid: "uid", parent: "2");
      expect(obj1 == obj2, false);
    });
    test(
        "should not equal"
        "when they have the different uid but the same parent", () {
      final obj1 = GroupBase(uid: "uid", parent: "1");
      final obj2 = GroupBase(uid: "uid-2", parent: "1");
      expect(obj1, isNot(equals(obj2)));
      expect(obj1 == obj2, false);
    });

    test(
        "should not equal"
        "when one of them is inherited class", () {
      final obj1 = GroupBase(uid: "uid", parent: "1");
      final obj2 = ExtendedClass(additional: "1", uid: "uid", parent: "1");
      expect(obj1, isNot(equals(obj2)));
      expect(obj1 == obj2, false);
    });
  });
}
