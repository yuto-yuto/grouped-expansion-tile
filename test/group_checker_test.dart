import 'package:flutter_test/flutter_test.dart';
import 'package:grouped_expansion_tile/grouped_expansion_tile.dart';

void main() {
  group("isDifferentGroup", () {
    Parent _createData(
      String uid, {
      String? parent,
      Iterable<Parent<GroupBase>>? children,
    }) {
      return Parent(
        self: GroupBase(uid: uid, parent: parent),
        children: children,
      );
    }

    test("should be false when source is null", () {
      final dest = _createData("1");
      final result = isDifferentGroup(null, dest);
      expect(result, false);
    });
    test("should be false when dest is null", () {
      final source = _createData("1");
      final result = isDifferentGroup(source, null);
      expect(result, false);
    });
    test("should be false when uid is the same", () {
      final source = _createData("1");
      final dest = _createData("1");
      final result = isDifferentGroup(source, dest);
      expect(result, false);
    });
    test("should be false when source has the dest", () {
      final dest = _createData("2", parent: "1");
      final source = _createData("1", children: [dest]);
      final result = isDifferentGroup(source, dest);
      expect(result, false);
    });
    test("should be false when dest is the parent", () {
      final source = _createData("1", parent: "2");
      final dest = _createData("2", parent: "1", children: [source]);
      final result = isDifferentGroup(source, dest);
      expect(result, false);
    });
    test("should be true when source and dest are top level parent", () {
      final source = _createData("1");
      final dest = _createData("2");
      final result = isDifferentGroup(source, dest);
      expect(result, true);
    });
    test(
        'should be true when'
        'source has no children but is child of child of dest', () {
      final source = _createData("1", parent: "2");
      final middle = _createData("2", parent: "3", children: [source]);
      final dest = _createData("3", children: [middle]);
      final result = isDifferentGroup(source, dest);
      expect(result, true);
    });
    test('should be false when dest is in the source group (3rd level)', () {
      final dest = _createData("1", parent: "2");
      final middle = _createData("2", parent: "3", children: [dest]);
      final source = _createData("3", children: [middle]);
      final result = isDifferentGroup(source, dest);
      expect(result, false);
    });
    test('should be false when dest is in the source group (4th level)', () {
      final dest = _createData("1", parent: "4");
      final middle2 = _createData("4", parent: "2", children: [dest]);
      final middle1 = _createData("2", parent: "3", children: [middle2]);
      final source = _createData("3", children: [middle1]);
      final result = isDifferentGroup(source, dest);
      expect(result, false);
    });
    test('should be true when dest is child of different group', () {
      // group 1
      final dest = _createData("1", parent: "4");
      final middle2 = _createData("4", parent: "2", children: [dest]);
      final middle1 = _createData("2", parent: "3", children: [middle2]);

      // group 2
      final source = _createData("99", parent: "88");

      final result = isDifferentGroup(source, dest);
      expect(result, true);
    });
  });
}
