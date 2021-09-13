import 'package:flutter/material.dart';
import 'package:grouped_expansion_tile/grouped_expansion_tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GroupedExtensionTileSample(),
    );
  }
}

class Category extends GroupBase {
  final String additional;
  Category({
    required this.additional,
    required String uid,
    String? parent,
  }) : super(uid: uid, parent: parent);
}

class GroupedExtensionTileSample extends StatelessWidget {
  const GroupedExtensionTileSample({Key? key}) : super(key: key);
  List<Category> _createList() {
    return [
      Category(additional: "group-1", uid: "1"),
      Category(additional: "group-2", uid: "2"),
      Category(additional: "group-1-1", uid: "3", parent: "1"),
      Category(additional: "group-2-1", uid: "4", parent: "2"),
      Category(additional: "group-3", uid: "5"),
      Category(additional: "group-2-1-1", uid: "6", parent: "4"),
      Category(additional: "group-2-2", uid: "7", parent: "2"),
      Category(additional: "group-2-3", uid: "8", parent: "2"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final groupedExpansionTile = GroupedExpansionTile<Category>(
      data: _createList(),
      builder: (parent, depth) => Text(parent.self.additional),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Grouped Extension Sample"),
        ),
        body: groupedExpansionTile,
      ),
    );
  }
}
