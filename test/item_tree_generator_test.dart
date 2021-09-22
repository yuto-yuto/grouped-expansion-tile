import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grouped_expansion_tile/grouped_expansion_tile.dart';
import 'package:grouped_expansion_tile/item_tree_generator.dart';

void main() {
  group("createItemTree", () {
    test("should throw an error when data contains the same uid", () {
      final data = [
        GroupBase(uid: "1"),
        GroupBase(uid: "2"),
        GroupBase(uid: "1"),
      ];
      expect(() => createItemTree(data), throwsArgumentError);
      expect(
          () => createItemTree(data),
          throwsA(isA<ArgumentError>().having(
            (p0) => p0.message,
            "message",
            "List must not contain the same uid.",
          )));
    });
    test("should return empty list when data contains only child", () {
      final data = [GroupBase(uid: "1", parent: "2")];
      final result = createItemTree(data);
      expect(result, isEmpty);
    });
    test("should return only top parents when they don't have child", () {
      final data = [
        GroupBase(uid: "1"),
        GroupBase(uid: "2"),
      ];
      final result = createItemTree(data);
      expect(result.length, 2);
      final expected = [
        Parent(self: GroupBase(uid: "1")),
        Parent(self: GroupBase(uid: "2")),
      ];
      expect(listEquals(result, expected), true);
    });
    test("should return complete Parent tree", () {
      final data = [
        GroupBase(uid: "1"),
        GroupBase(uid: "2"),
        GroupBase(uid: "3", parent: "1"),
        GroupBase(uid: "4", parent: "1"),
        GroupBase(uid: "5", parent: "2"),
        GroupBase(uid: "6", parent: "2"),
        GroupBase(uid: "7", parent: "4"),
      ];
      final result = createItemTree(data);
      expect(result.length, 2);
      final expected = [
        Parent(
          self: GroupBase(uid: "1"),
          children: [
            Parent(self: GroupBase(uid: "3", parent: "1")),
            Parent(
              self: GroupBase(uid: "4", parent: "1"),
              children: [Parent(self: GroupBase(uid: "7", parent: "4"))],
            ),
          ],
        ),
        Parent(
          self: GroupBase(uid: "2"),
          children: [
            Parent(self: GroupBase(uid: "5", parent: "2")),
            Parent(self: GroupBase(uid: "6", parent: "2")),
          ],
        ),
      ];
      expect(listEquals(result, expected), true);
    });
  });
}
