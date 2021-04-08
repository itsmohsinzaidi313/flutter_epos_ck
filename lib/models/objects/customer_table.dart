class Tables {
  static const String IdKey = 'id';
  static const String TableNameKey = 'tableName';
  static const String ReservedKey = 'reserved';

  String id;
  String tableName;
  bool reserved;
  bool selected;
  Tables({this.id, this.tableName, this.reserved, this.selected});
  Tables.fromJson(Map<String, dynamic> map)
      : id = map[IdKey],
        tableName = map[TableNameKey],
        reserved = map[ReservedKey],
        selected = false;
}
