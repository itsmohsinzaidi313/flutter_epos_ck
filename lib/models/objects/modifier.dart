class Modifier {
  final String serverId;
  final String name;
  final String price;
  final String description;
  final String userId;
  final String companyId;
  final String delStatus;

  Modifier(
      {this.serverId,
      this.name,
      this.price,
      this.description,
      this.userId,
      this.companyId,
      this.delStatus});

  Modifier.fromMap(Map<String, dynamic> map)
      : serverId = map['id'],
        name = map['name'],
        price = map['price'],
        description = map['description'],
        userId = map['user_id'],
        companyId = map['company_id'],
        delStatus = map['del_status'];
}
