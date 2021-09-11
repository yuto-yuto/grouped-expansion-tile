// import 'package:flutter_test/flutter_test.dart';
// import 'package:grouped_expansion_tile/group_base.dart';
// import 'package:grouped_expansion_tile/grouped_expansion_tile.dart';
// import 'package:flutter/material.dart';

// void main() {
//   List<GroupBase> _createList() {
//     return [
//       GroupBase(uid: 1, name: "group-1"),
//       GroupBase(uid: 2, name: "group-2"),
//       GroupBase(uid: 3, name: "group-1-1", parent: 1),
//       GroupBase(uid: 4, name: "group-2-1", parent: 2),
//       GroupBase(uid: 5, name: "group-3"),
//       GroupBase(uid: 6, name: "group-2-1-1", parent: 4),
//       GroupBase(uid: 7, name: "group-2-2", parent: 2),
//       GroupBase(uid: 8, name: "group-2-3", parent: 2),
//     ];
//   }

//   testWidgets('All items should appear', (WidgetTester tester) async {
//     await tester.pumpWidget(GroupedExpansionTile(
//       data: _createList(),
//       builder: (parent, depth) => const Text(""),
//     ));

//     expect(find.text('group-1'), findsOneWidget);
//     expect(find.text('group-2'), findsOneWidget);
//     expect(find.text('group-1-1'), findsOneWidget);
//     expect(find.text('group-2-1'), findsOneWidget);
//     expect(find.text('group-3'), findsOneWidget);
//     expect(find.text('group-2-1-1'), findsOneWidget);
//     expect(find.text('group-2-2'), findsOneWidget);
//     expect(find.text('group-2-3'), findsOneWidget);
//   });

//   testWidgets('Children should disappear after tap', (WidgetTester tester) async {
//     await tester.pumpWidget(GroupedExpansionTile(
//       data: _createList(),
//       builder: (parent, depth) => const Text(""),
//     ));

//     await tester.tap(find.byIcon(Icons.remove));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('group-1'), findsOneWidget);
//     expect(find.text('group-2'), findsNothing);
//   });
// }
