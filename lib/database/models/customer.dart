import 'package:pos_app/database/tables/database_tables.dart';

class Customer {
  String localId;
  final int serverId;
  final int remoteId;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String gstNumber;
  final int areaId;
  final int userId;
  final int companyId;
  final String delStatus;
  final String dateOfBirth;
  final String dateOfAnniversary;
  final int isUpload;

  Customer(
      {this.serverId,
      this.remoteId,
      this.name,
      this.phone,
      this.email,
      this.address,
      this.gstNumber,
      this.areaId,
      this.userId,
      this.companyId,
      this.delStatus,
      this.dateOfBirth,
      this.dateOfAnniversary,
      this.isUpload});

  Customer.fromMap(Map<String, dynamic> map)
      : localId = map[CustomerTable.LOCAL_ID].toString(),
        serverId = map[CustomerTable.SERVER_ID],
        remoteId = map[CustomerTable.REMOTE_ID],
        name = map[CustomerTable.NAME],
        phone = map[CustomerTable.PHONE].toString(),
        email = map[CustomerTable.EMAIL],
        address = map[CustomerTable.ADDRESS],
        gstNumber = map[CustomerTable.GST_NUMBER],
        areaId = map[CustomerTable.AREA_ID],
        userId = map[CustomerTable.USER_ID],
        companyId = map[CustomerTable.COMPANY_ID],
        delStatus = map[CustomerTable.DEL_STATUS],
        dateOfBirth = map[CustomerTable.DATE_OF_BIRTH],
        dateOfAnniversary = map[CustomerTable.DATE_OF_ANNIVERSARY],
        isUpload = map[CustomerTable.IS_UPLOADED];

  Map<String, dynamic> toMap(Customer customer) {
    return {
      CustomerTable.SERVER_ID: customer.serverId,
      CustomerTable.REMOTE_ID: customer.remoteId,
      CustomerTable.NAME: customer.name,
      CustomerTable.PHONE: customer.phone,
      CustomerTable.EMAIL: customer.email,
      CustomerTable.ADDRESS: customer.address,
      CustomerTable.GST_NUMBER: customer.gstNumber,
      CustomerTable.AREA_ID: customer.areaId,
      CustomerTable.USER_ID: customer.userId,
      CustomerTable.COMPANY_ID: customer.companyId,
      CustomerTable.DEL_STATUS: customer.delStatus,
      CustomerTable.DATE_OF_BIRTH: customer.dateOfBirth,
      CustomerTable.DATE_OF_ANNIVERSARY: customer.dateOfAnniversary,
      CustomerTable.IS_UPLOADED: customer.isUpload
    };
  }
}
