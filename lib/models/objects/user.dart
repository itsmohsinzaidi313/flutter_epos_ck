class User {
  static const String _IdKey = 'Id';
  static const String _NameKey = 'Name';
  static const String _TiltIdKey = 'TiltId';
  final String id;
  final String name;
  final String tiltId;
  User({this.id, this.name, this.tiltId});

  User.fromJson(Map<String, dynamic> map)
      : id = map[_IdKey],
        name = map[_NameKey],
        tiltId = map[_TiltIdKey];
}
