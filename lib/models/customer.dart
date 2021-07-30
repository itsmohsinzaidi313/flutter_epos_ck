import 'dart:convert';

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

  Customer.fromJson(Map<String, dynamic> map)
      : id = map[IdKey],
        name = map[NameKey],
        contact = map[ContactKey],
        address = map[AddressKey];

  String get toJson => {
        jsonEncode(NameKey): jsonEncode(name),
        jsonEncode(ContactKey): jsonEncode(contact),
        jsonEncode(AddressKey): jsonEncode(address)
      }.toString();
}
