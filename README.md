<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

This widget shows grouped data with expansion tile.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
class Category implements GroupBase {
  final int uid;
  final String name;
  final int? parent;
  Category({
    required this.uid,
    required this.name,
    this.parent,
  });
}

class GroupedExtensionTileSample extends StatelessWidget {
  List<Category> _createList() {
    return [
      Category(uid: 1, name: "group-1"),
      Category(uid: 2, name: "group-2"),
      Category(uid: 3, name: "group-1-1", parent: 1),
      Category(uid: 4, name: "group-2-1", parent: 2),
      Category(uid: 5, name: "group-3"),
      Category(uid: 6, name: "group-2-1-1", parent: 4),
      Category(uid: 7, name: "group-2-2", parent: 2),
      Category(uid: 8, name: "group-2-3", parent: 2),
    ];
  }

  @override
  Widget build(BuildContext context) {
  final groupedExpansionTile = GroupedExpansionTile<Category>(
    data: _createList(),
    builder: (parent, depth) => Text(parent.self.name),
  );
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Grouped Extension Sample"),
      ),
      body: groupedExpansionTile,
    ));
  }
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
