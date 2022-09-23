class Tables {
  static const String IdKey = 'Id';
  static const String TableNameKey = 'Name';
  static const String ReservedKey = 'Reserved';

  final String id;
  final String name;
  final bool reserved;
  final bool selected;

  const Tables({
    this.id = '',
    this.name = '',
    this.reserved = false,
    this.selected = false,
  });

  Tables.modify(Tables tables,
      {String? id, String? name, bool? reserved, bool? selected})
      : id = id ?? tables.id,
        name = name ?? tables.name,
        reserved = reserved ?? tables.reserved,
        selected = selected ?? tables.selected;

  Tables.fromMap(Map<String, dynamic> map)
      : id = map[IdKey],
        name = map[TableNameKey],
        reserved = map[ReservedKey],
        selected = false;
}
