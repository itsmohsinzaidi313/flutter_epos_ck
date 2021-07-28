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
      : serverId = map['id'],
        fullName = map['full_name'],
        phone = map['phone'],
        emailAddress = map['email_address'],
        password = map['password'],
        designation = map['designation'],
        willLogin = map['will_login'],
        role = map['role'],
        outletId = map['outlet_id'],
        companyId = map['company_id'],
        accountCreationDate = map['account_creation_date'],
        language = map['language'],
        lastLogin = map['last_login'],
        activeStatus = map['active_status'],
        delStatus = map['del_status'];
}
