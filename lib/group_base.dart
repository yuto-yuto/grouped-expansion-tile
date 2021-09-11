abstract class GroupBase {
  final int uid;
  final String name;
  final int? parent;

  GroupBase({
    required this.uid,
    required this.name,
    this.parent,
  });
}
