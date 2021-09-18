import 'package:pos_app/database/tables/database_tables.dart';

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
      : serverId = map[CompanyTable.SERVER_ID],
        currency = map[CompanyTable.CURRENCY],
        timezone = map[CompanyTable.TIMEZONE],
        dateFormat = map[CompanyTable.DATEFORMAT],
        outletId = map[CompanyTable.OUTLET_ID],
        name = map[CompanyTable.NAME],
        email = map[CompanyTable.EMAIL],
        phone1 = map[CompanyTable.PHONE1],
        phone2 = map[CompanyTable.PHONE2],
        address = map[CompanyTable.ADDRESS],
        status = map[CompanyTable.STATUS],
        dateAdded = map[CompanyTable.DATE_ADDED],
        expiryDate = map[CompanyTable.EXPIRY_DATE],
        token = map[CompanyTable.TOKEN];
}
