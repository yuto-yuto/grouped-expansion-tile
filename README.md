## Features

This widget shows grouped data with expansion tile.

![Example](https://user-images.githubusercontent.com/39804422/132948271-21126573-65a2-4d5a-9cec-231cc70c260e.gif)


## Usage

See `/example` folder for the complete sample.

```dart
List<GroupBase> _createList() {
  return [
    GroupBase(uid: 1, name: "group-1"),
    GroupBase(uid: 2, name: "group-2"),
    GroupBase(uid: 3, name: "group-1-1", parent: 1),
    GroupBase(uid: 4, name: "group-2-1", parent: 2),
    GroupBase(uid: 5, name: "group-3"),
    GroupBase(uid: 6, name: "group-2-1-1", parent: 4),
    GroupBase(uid: 7, name: "group-2-2", parent: 2),
    GroupBase(uid: 8, name: "group-2-3", parent: 2),
  ];
}

GroupedExpansionTile<Category>(
  data: _createList(),
  builder: (parent, depth) => Text(parent.self.name),
}
```
