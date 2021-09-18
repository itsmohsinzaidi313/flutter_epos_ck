import 'package:pos_app/database/tables/database_tables.dart';

class Shift {
  int id;
  int shiftId;
  String voucherNo;
  String openDay;
  String closingDay;
  int isOpen;
  int userId;
  int outletId;
  int companyId;

  Shift({
    this.id,
    this.shiftId,
    this.voucherNo,
    this.openDay,
    this.closingDay,
    this.isOpen,
    this.userId,
    this.outletId,
    this.companyId,
  });

  Shift.fromMap(Map<String, dynamic> map)
      : id = map[ShiftTable.LOCAL_ID],
        shiftId = map[ShiftTable.SHIFT_ID],
        voucherNo = map[ShiftTable.VOUCHER_NO],
        openDay = map[ShiftTable.OPEN_DAY],
        closingDay = map[ShiftTable.CLOSING_DAY],
        isOpen = map[ShiftTable.IS_OPEN],
        userId = map[ShiftTable.USER_ID],
        outletId = map[ShiftTable.OUTLET_ID],
        companyId = map[ShiftTable.COMPANY_ID];
}
