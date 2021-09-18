import 'package:pos_app/database/tables/database_tables.dart';

class User {
  final String serverId;
  final String fullName;
  final String phone;
  final String emailAddress;
  final String password;
  final String designation;
  final String willLogin;
  final String role;
  final String outletId;
  final String companyId;
  final String accountCreationDate;
  final String language;
  final String lastLogin;
  final String activeStatus;
  final String delStatus;

  User(
      {this.serverId,
      this.fullName,
      this.phone,
      this.emailAddress,
      this.password,
      this.designation,
      this.willLogin,
      this.role,
      this.outletId,
      this.companyId,
      this.accountCreationDate,
      this.language,
      this.lastLogin,
      this.activeStatus,
      this.delStatus});

  User.fromMap(Map<String, dynamic> map)
      : serverId = map[UserTable.SERVER_ID],
        fullName = map[UserTable.FULL_NAME],
        phone = map[UserTable.PHONE],
        emailAddress = map[UserTable.EMAIL],
        password = map[UserTable.PASSWORD],
        designation = map[UserTable.DESIGNATION],
        willLogin = map[UserTable.WILL_LOGIN],
        role = map[UserTable.ROLE],
        outletId = map[UserTable.OUTLET_ID],
        companyId = map[UserTable.COMPANY_ID],
        accountCreationDate = map[UserTable.ACCOUNT_CREATED_DATE],
        language = map[UserTable.LANGUAGE],
        lastLogin = map[UserTable.LAST_LOGIN],
        activeStatus = map[UserTable.ACTIVE_STATUS],
        delStatus = map[UserTable.DEL_STATUS];
}
