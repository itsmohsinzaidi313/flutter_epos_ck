class User {
  static const String _IdKey = 'Id';
  static const String _NameKey = 'Name';
  final String? id;
  final String? name;
  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> map)
      : id = map[_IdKey],
        name = map[_NameKey];
}
