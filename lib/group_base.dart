class GroupBase {
  final String uid;
  String? parent;

  GroupBase({
    required this.uid,
    this.parent,
  });

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType && hashCode == other.hashCode;

    // not work
    // return identical(this, other) && hashCode == other.hashCode;
  }

  @override
  int get hashCode => uid.hashCode + parent.hashCode;
}
