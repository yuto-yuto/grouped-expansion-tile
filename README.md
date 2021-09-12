## Features

This widget shows grouped data with expansion tile.

![Example](https://user-images.githubusercontent.com/39804422/132971430-d63b97ba-4355-408c-842d-f08688dd4c18.gif)

## Usage

See `/example` folder for the sample.

```dart
List<GroupBase> _createList() {
  return [
    GroupBase(uid: "group-1"),
    GroupBase(uid: "group-2"),
    GroupBase(uid: "group-1-1" parent: "group-1"),
    GroupBase(uid: "group-2-1" parent: "group-2"),
    GroupBase(uid: "group-3"),
    GroupBase(uid: "group-2-1-1", parent: "group-2-1"),
    GroupBase(uid: "group-2-2",  parent: "group-2"),
    GroupBase(uid: "group-2-3",  parent: "group-2"),
  ];
}

GroupedExpansionTile<GroupBase>(
  data: _createList(),
  builder: (parent, depth) => Text(parent.self.name),
}
```
