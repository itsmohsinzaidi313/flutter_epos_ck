class Waiter {
  static const IdKey = 'id';
  static const NameKey = 'name';
  String id;
  String name;
  Waiter({this.id, this.name});
  Waiter.fromJson(Map<String, dynamic> map)
      : id = map[IdKey],
        name = map[NameKey];
}
