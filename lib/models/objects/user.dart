class User {
  static const String _IdKey = 'userId';
  static const String _NameKey = 'username';
  static const String _TiltIdKey = 'tiltId';
  final String id;
  final String name;
  final String tiltId;
  User({this.id, this.name, this.tiltId});

  User.fromJson(Map<String, dynamic> map)
      : id = map[_IdKey].toString(),
        name = map[_NameKey],
        tiltId = map[_TiltIdKey].toString();
}
