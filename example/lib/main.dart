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
    Category(additional: "group-2-1-1-1", uid: "9", parent: "6"),
    Category(additional: "group-2-1-1-2", uid: "10", parent: "6"),
  ];
}

Future<void> _showDialog(
  BuildContext context,
  String title,
  String text,
) async {
  final alert = AlertDialog(
    title: Text(title),
    content: Text(text),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text("OK"),
      ),
    ],
  );
  await showDialog(
    context: context,
    builder: (BuildContext context) => alert,
  );
}

class GroupedExtensionTileSample extends StatelessWidget {
  const GroupedExtensionTileSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Grouped Extension Sample"),
        ),
        body: PageView(
          children: [
            _createSimplestSample(),
            GroupedExtensionTileSample2(),
          ],
        ),
      ),
    );
  }

  Widget _createSimplestSample() {
    final groupedExpansionTile = GroupedExpansionTile<Category>(
      data: _createList(),
      builder: (parent, depth) => Text(parent.self.additional),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Simplest"),
      ),
      // body: groupedExpansionTile,
      body: groupedExpansionTile,
    );
  }
}

class GroupedExtensionTileSample2 extends StatefulWidget {
  const GroupedExtensionTileSample2({Key? key}) : super(key: key);

  @override
  _GroupedExtensionTileSample2 createState() => _GroupedExtensionTileSample2();
}

class _GroupedExtensionTileSample2 extends State<GroupedExtensionTileSample2> {
  final List<Category> _data = _createList();

  @override
  Widget build(BuildContext context) {
    final groupedExpansionTile = GroupedExpansionTile<Category>(
      data: _data,
      builder: (parent, depth) => Text(parent.self.additional),
      childIndent: 50,
      controlAffinity: ListTileControlAffinity.trailing,
      initialBorder: Border.all(color: Colors.orange, width: 1),
      highlightedBorder:
          Border.all(color: Colors.deepPurple.shade800, width: 3),
      initiallyExpanded: false,
      draggable: true,
      onAccept: (source, dest) async {
        final text = 'uid: ${source.self.uid}\n'
            'additional: ${source.self.additional}\n'
            'parent: ${source.self.parent}\n\n'
            'to\n\n'
            'uid: ${dest.uid}\n'
            'additional: ${dest.additional}\n'
            'parent: ${dest.parent}';
        await _showDialog(context, "onAccept", text);

        setState(() {
          source.self.parent = dest.uid;
        });
      },
      onExpansionChanged: (expanded, parent, depth) async {
        final text = "open: $expanded\n parent:$parent\n depth: $depth";
        await _showDialog(context, "onExpansionChanged", text);
      },
      padding: EdgeInsets.zero,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Advanced"),
      ),
      body: groupedExpansionTile,
    );
  }
}
