## Features

This widget shows grouped data with expansion tile.

<video autoplay="" controls="" loop="" muted="" preload="auto" src="https://user-images.githubusercontent.com/39804422/133917377-4e74d53b-3f17-4cc7-8443-2e7d2f9fdef4.mp4" width="240" height="426" />



## Simple Usage

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

## Advanced usage

<video autoplay="" controls="" loop="" muted="" preload="auto" src="https://user-images.githubusercontent.com/39804422/133917379-fc9e0edc-03d6-4941-b7ad-428f7cf64166.mp4" width="240" height="426" />