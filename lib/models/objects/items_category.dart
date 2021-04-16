class Category {
  static const IdKey = 'Id';
  static const NameKey = 'Name';
  final String id, name;
  bool selected;
  Category.fromJson(Map<String, dynamic> map)
      : id = map[IdKey],
        name = map[NameKey],
        selected = false;
}
