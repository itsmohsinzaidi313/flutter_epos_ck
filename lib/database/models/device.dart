import 'package:pos_app/database/tables/database_tables.dart';

class Device {
  int id;
  int serverId;
  int outletId;
  int companyId;
  String deviceKey;
  String delStatus;
  int isInstalled;
  String dateAdded;
  String dateModified;

  Device.fromMap(Map<String, dynamic> map)
      : serverId = map[DeviceTable.SERVER_ID],
        outletId = map[DeviceTable.OUTLET_ID],
        companyId = map[DeviceTable.COMPANY_ID],
        deviceKey = map[DeviceTable.DEVICE_KEY],
        delStatus = map[DeviceTable.DEL_STATUS],
        isInstalled = map[DeviceTable.IS_INSTALLED],
        dateAdded = map[DeviceTable.DATE_ADDED],
        dateModified = map[DeviceTable.DATE_MODIFIED];

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
