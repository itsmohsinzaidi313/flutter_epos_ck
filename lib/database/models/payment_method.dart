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
    this.serverId = map['id'];
    this.name = map['name'];
    this.description = map['description'];
    this.userId = map['user_id'];
    this.companyId = map['company_id'];
    this.delStatus = map['del_status'];
  }
}
