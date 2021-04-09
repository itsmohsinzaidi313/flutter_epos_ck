class User {
  static const String IdKey = 'Id';
  static const String NameKey = 'Name';
  static const String TiltIdKey = 'TiltId';
  final String id;
  final String name;
  final String tiltId;
  User({this.id, this.name, this.tiltId});

  User.fromJson(Map<String, dynamic> map)
      : id = map[IdKey],
        name = map[NameKey],
        tiltId = map[TiltIdKey];
}
