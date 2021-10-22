class Customer {
  static const String IdKey = 'Id';
  static const String NameKey = 'Name';
  static const String ContactKey = 'Contact';
  static const String AddressKey = 'Address';

  String id, name, contact, address;
  Customer(
      {this.id = '', this.name = '', this.contact = '', this.address = ''});

  Customer.fromMap(Map<String, dynamic> map)
      : id = map[IdKey],
        name = map[NameKey],
        contact = map[ContactKey],
        address = map[AddressKey];

  Map<String, dynamic> toMap() => {
        IdKey: id ?? '',
        NameKey: name ?? '',
        ContactKey: contact ?? '',
        AddressKey: address ?? ''
      };
}
