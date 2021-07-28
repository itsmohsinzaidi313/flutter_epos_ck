class Table {
  String serverId;
  String name;
  String sitCapacity;
  String position;
  String description;
  String userId;
  String outletId;
  String companyId;
  String delStatus;

  Table(
      {this.serverId,
      this.name,
      this.sitCapacity,
      this.position,
      this.description,
      this.userId,
      this.outletId,
      this.companyId,
      this.delStatus});

  Table.fromMap(Map<String, dynamic> map)
      : serverId = map['id'],
        name = map['name'],
        sitCapacity = map['sit_capacity'],
        position = map['position'],
        description = map['description'],
        userId = map['user_id'],
        outletId = map['outlet_id'],
        companyId = map['company_id'],
        delStatus = map['del_status'];
}
