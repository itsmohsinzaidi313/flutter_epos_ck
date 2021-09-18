import 'package:pos_app/database/tables/database_tables.dart';

class Outlet {
  final int serverId;
  final String outletName;
  final String outletCode;
  final String address;
  final String phone;
  final String invoicePrint;
  final String startingDate;
  final String invoiceFooter;
  final String collectTax;
  final String preOrPostOrder;
  final int userId;
  final int companyId;
  final String delStatus;

  Outlet(
      {this.serverId,
      this.outletName,
      this.outletCode,
      this.address,
      this.phone,
      this.invoicePrint,
      this.startingDate,
      this.invoiceFooter,
      this.collectTax,
      this.preOrPostOrder,
      this.userId,
      this.companyId,
      this.delStatus});

  Outlet.fromMap(Map<String, dynamic> map)
      : serverId = map[OutletTable.SERVER_ID],
        outletName = map[OutletTable.OUTLET_NAME],
        outletCode = map[OutletTable.OUTLET_CODE],
        address = map[OutletTable.ADDRESS],
        phone = map[OutletTable.PHONE],
        invoicePrint = map[OutletTable.INVOICE_PRINT],
        startingDate = map[OutletTable.STARTING_DATE],
        invoiceFooter = map[OutletTable.INVOICE_FOOTER],
        collectTax = map[OutletTable.COLLECT_TAX],
        preOrPostOrder = map[OutletTable.PRE_OR_POST_ORDER],
        userId = map[OutletTable.USER_ID],
        companyId = map[OutletTable.COMPANY_ID],
        delStatus = map[OutletTable.DEL_STATUS];
}
