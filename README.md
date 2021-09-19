## Features

This widget shows grouped data with expansion tile.

## Simple Usage

Set data and builder properties. data must be a class that extends `GroupBase`. If you don't need additional property you can use `GroupBase` class directly. The builder is assigned to title property of expansion tile.

```dart
class Category extends GroupBase {
  String additional;
  Category({
    required this.additional,
    required String uid,
    String? parent,
  }) : super(uid: uid, parent: parent);
}

List<Category> _createList() {
  final topParents = List.generate(10,
      (index) => Category(additional: "auto-generated-$index", uid: "2$index"));

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
    ...topParents,
  ];
}

final groupedExpansionTile = GroupedExpansionTile<Category>(
  data: _createList(),
  builder: (parent, depth) => Text(parent.self.additional),
);

return Scaffold(
  appBar: AppBar(
    title: const Text("Simplest"),
  ),
  body: groupedExpansionTile,
);
```

<video autoplay="" controls="" loop="" muted="" preload="auto" src="https://user-images.githubusercontent.com/39804422/133917379-fc9e0edc-03d6-4941-b7ad-428f7cf64166.mp4" width="240" height="426" ></video>

## Enabling drag gesture

You can make each item draggable. Set true to `draggable` property to enable dragging. You can specify your own border to highlight the target widget when it will accept the dragged item. `onAccept` is called when target item accepts dragged item. You can write your own process there for example to update the item list.

```dart
final List<Category> _data = _createList();
GroupedExpansionTile<Category>(
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
    setState(() {
      // source is one of elements of _data
      source.self.parent = dest?.uid;
    });
  },
  onExpansionChanged: (expanded, parent, depth) {
    setState(() {
      parent.self.additional += "@";
    });
  },
  padding: EdgeInsets.zero,
);
```

<video autoplay="" controls="" loop="" muted="" preload="auto" src="https://user-images.githubusercontent.com/39804422/133917377-4e74d53b-3f17-4cc7-8443-2e7d2f9fdef4.mp4" width="240" height="426" > </video>
