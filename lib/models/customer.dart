import 'dart:convert';

import 'package:pos_app/database/tables/database_tables.dart';

class Customer {
  static const String IdKey = 'Id';
  static const String NameKey = 'Name';
  static const String ContactKey = 'Contact';
  static const String AddressKey = 'Address';

  String id, name, contact, address;
  Customer({this.id, this.name, this.contact, this.address});
  
  Customer.empty()
      : id = '',
        name = '',
        contact = '',
        address = '';

  Customer.fromMap(Map<String, dynamic> map)
      : id = map[CustomerTable.SERVER_ID],
        name = map[CustomerTable.NAME],
        contact = map[CustomerTable.PHONE],
        address = map[CustomerTable.ADDRESS];

  String get toJson => {
        jsonEncode(NameKey): jsonEncode(name),
        jsonEncode(ContactKey): jsonEncode(contact),
        jsonEncode(AddressKey): jsonEncode(address)
      }.toString();
}
