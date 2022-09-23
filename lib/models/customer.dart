class Customer {
  static const String IdKey = 'Id';
  static const String NameKey = 'Name';
  static const String ContactKey = 'Contact';
  static const String AddressKey = 'Address';

  final String id, name, contact, address;

  const Customer({
    this.id = '',
    this.name = '',
    this.contact = '',
    this.address = '',
  });

  Customer.modify(
    Customer customer, {
    String? id,
    String? name,
    String? contact,
    String? address,
  })  : id = id ?? customer.id,
        name = name ?? customer.name,
        contact = contact ?? customer.contact,
        address = address ?? customer.address;

  Customer.fromMap(Map<String, dynamic> map)
      : id = map[IdKey] ?? '',
        name = map[NameKey] ?? '',
        contact = map[ContactKey] ?? '',
        address = map[AddressKey] ?? '';

  Map<String, dynamic> get map => {
        IdKey: id,
        NameKey: name,
        ContactKey: contact,
        AddressKey: address,
      };
}
