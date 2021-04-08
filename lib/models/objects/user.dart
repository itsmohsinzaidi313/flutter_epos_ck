class User {
  static const String IdKey = 'id';
  static const String NameKey = 'name';
  static const String TiltIdKey = 'tiltid';
  final String id;
  final String name;
  final String tiltId;
  User({this.id, this.name, this.tiltId});

  User.fromJson(Map<String, dynamic> map)
      : id = map[IdKey],
        name = map[NameKey],
        tiltId = map[TiltIdKey];
}
