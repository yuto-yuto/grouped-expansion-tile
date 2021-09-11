## Features

This widget shows grouped data with expansion tile.

![Example](https://user-images.githubusercontent.com/39804422/132948271-21126573-65a2-4d5a-9cec-231cc70c260e.gif)

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

GroupedExpansionTile<Category>(
  data: _createList(),
  builder: (parent, depth) => Text(parent.self.name),
}
```
