class Device {
  String id;
  String serverId;
  String outletId;
  String companyId;
  String deviceKey;
  String delStatus;
  String isInstalled;
  String dateAdded;
  String dateModified;

  Device.fromMap(Map<String, dynamic> map)
      : serverId = map['id'],
        outletId = map['outlet_id'],
        companyId = map['company_id'],
        deviceKey = map['device_key'],
        delStatus = map['del_status'],
        isInstalled = map['is_installed'],
        dateAdded = map['date_added'],
        dateModified = map['date_modified'];

  Device(
      {this.serverId,
      this.outletId,
      this.companyId,
      this.deviceKey,
      this.delStatus,
      this.isInstalled,
      this.dateAdded,
      this.dateModified});
}
