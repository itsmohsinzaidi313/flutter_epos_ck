class Tables {
  static const String IdKey = 'id';
  static const String TableNameKey = 'tableName';
  static const String ReservedKey = 'reserved';

  String id;
  String name;
  bool reserved;
  bool selected;
  Tables({this.id, this.name, this.reserved, this.selected});
  Tables.fromJson(Map<String, dynamic> map)
      : id = map[IdKey],
        name = map[TableNameKey],
        reserved = map[ReservedKey],
        selected = false;
}
