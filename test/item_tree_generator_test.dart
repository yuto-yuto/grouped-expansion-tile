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
  });
}
