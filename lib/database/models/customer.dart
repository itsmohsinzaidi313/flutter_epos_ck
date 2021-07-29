class Customer {
  String localId;
  final int serverId;
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
      : localId = map['local_id'].toString(),
        serverId = map['id'],
        name = map['name'],
        phone = map['phone'],
        email = map['email'],
        address = map['address'],
        gstNumber = map['gst_number'],
        areaId = map['area_id'],
        userId = map['user_id'],
        companyId = map['company_id'],
        delStatus = map['del_status'],
        dateOfBirth = map['date_of_birth'],
        dateOfAnniversary = map['date_of_anniversary'],
        isUpload = map['is_upload'];

  Map<String, dynamic> toMap(Customer customer) {
    return {
      'id': customer.serverId,
      'name': customer.name,
      'phone': customer.phone,
      'email': customer.email,
      'address': customer.address,
      'gst_number': customer.gstNumber,
      'area_id': customer.areaId,
      'user_id': customer.userId,
      'company_id': customer.companyId,
      'del_status': customer.delStatus,
      'date_of_birth': customer.dateOfBirth,
      'date_of_anniversary': customer.dateOfAnniversary,
      'is_upload': customer.isUpload
    };
  }
}
