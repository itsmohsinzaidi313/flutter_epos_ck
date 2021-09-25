import 'dart:convert';

class Venue {
  static final String locId = 'Id';
  static final String locCode = 'Code';
  static final String locName = 'Name';

  final String venueId;
  final String venueCode, venueName;

  const Venue({this.venueId, this.venueCode, this.venueName});

  factory Venue.fromJson(Map<String, dynamic> map) => Venue(
      venueId: map[locId], venueName: map[locName], venueCode: map[locCode]);

  @override
  String toString() {
    return 'Venue{venueId: $venueId, venueCode: $venueCode, venueName: $venueName}';
  }
}

List<Venue> venueListFromJson(String str) =>
    List<Venue>.from(jsonDecode(str)['Data'].map((x) => Venue.fromJson(x)));
