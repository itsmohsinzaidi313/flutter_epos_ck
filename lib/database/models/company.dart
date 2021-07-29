class Company {
  final int serverId;
  final String currency;
  final String timezone;
  final String dateFormat;
  final int outletId;
  final String name;
  final String email;
  final String phone1;
  final String phone2;
  final String address;
  final String status;
  final String dateAdded;
  final String expiryDate;
  final String token;

  Company(
      {this.serverId,
      this.currency,
      this.timezone,
      this.dateFormat,
      this.outletId,
      this.name,
      this.email,
      this.phone1,
      this.phone2,
      this.address,
      this.status,
      this.dateAdded,
      this.expiryDate,
      this.token});

  Company.fromMap(Map<String, dynamic> map)
      : serverId = map['id'],
        currency = map['currency'],
        timezone = map['timezone'],
        dateFormat = map['date_format'],
        outletId = map['outlet_id'],
        name = map['name'],
        email = map['email'],
        phone1 = map['phone_1'],
        phone2 = map['phone_2'],
        address = map['address'],
        status = map['status'],
        dateAdded = map['date_added'],
        expiryDate = map['expiry_date'],
        token = map['token'];
}
