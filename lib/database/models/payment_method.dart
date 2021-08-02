class PaymentMethod {
  int serverId;
  String name;
  String description;
  int userId;
  int companyId;
  String delStatus;

  PaymentMethod(
      {this.serverId,
      this.name,
      this.description,
      this.userId,
      this.companyId,
      this.delStatus});

  PaymentMethod.fromMap(Map<String, dynamic> map) {
    serverId = map['id'];
    name = map['name'];
    description = map['description'];
    userId = map['user_id'];
    companyId = map['company_id'];
    delStatus = map['del_status'];
  }
}
