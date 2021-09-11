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
    uid,
    name,
    parent,
  }) : super(uid: uid, name: name, parent: parent);
}


class GroupedExtensionTileSample extends StatelessWidget {
  const GroupedExtensionTileSample({Key? key}) : super(key: key);
  List<Category> _createList() {
    return [
      Category(additional: "add", uid: 1, name: "group-1"),
      Category(additional: "add", uid: 2, name: "group-2"),
      Category(additional: "add", uid: 3, name: "group-1-1", parent: 1),
      Category(additional: "add", uid: 4, name: "group-2-1", parent: 2),
      Category(additional: "add", uid: 5, name: "group-3"),
      Category(additional: "add", uid: 6, name: "group-2-1-1", parent: 4),
      Category(additional: "add", uid: 7, name: "group-2-2", parent: 2),
      Category(additional: "add", uid: 8, name: "group-2-3", parent: 2),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final groupedExpansionTile = GroupedExpansionTile<Category>(
      data: _createList(),
      builder: (parent, depth) =>
          Text("${parent.self.additional}-${parent.self.name}"),
    );
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Grouped Extension Sample"),
      ),
      body: groupedExpansionTile,
    ));
  }
}
