import 'package:pos_app/database/tables/database_tables.dart';

class Register {
  int localId;
  int serverId;
  double openingBalance;
  double closingBalance;
  String openingBalanceDateTime;
  String closingBalanceDateTime;
  double salePaidAmount;
  double customerDueReceive;
  String paymentMethodsSale;
  int registerStatus;
  int userId;
  int outletId;
  int companyId;
  String registerNo;
  String deviceKey;
  bool isUpload;

  Register(
      {this.localId,
      this.openingBalance,
      this.closingBalance,
      this.openingBalanceDateTime,
      this.closingBalanceDateTime,
      this.salePaidAmount,
      this.customerDueReceive,
      this.paymentMethodsSale,
      this.registerStatus,
      this.userId,
      this.outletId,
      this.companyId,
      this.registerNo,
      this.deviceKey,
      this.serverId,
      this.isUpload});

  Register.fromMap(Map<String, dynamic> map)
      : localId = map[RegisterTable.LOCAL_ID],
        openingBalance = map[RegisterTable.OPENING_BALANCE],
        closingBalance = map[RegisterTable.CLOSING_BALANCE],
        openingBalanceDateTime = map[RegisterTable.OPENING_BALANCE_DATE_TIME],
        closingBalanceDateTime = map[RegisterTable.CLOSING_BALANCE_DATE_TIME],
        salePaidAmount = map[RegisterTable.SALE_PAID_AMOUNT],
        customerDueReceive = map[RegisterTable.CUSTOMER_DUE_RECEIVE],
        paymentMethodsSale = map[RegisterTable.PAYMENT_METHODS_SALE],
        registerStatus = map[RegisterTable.REGISTER_STATUS],
        userId = map[RegisterTable.USER_ID],
        outletId = map[RegisterTable.OUTLET_ID],
        companyId = map[RegisterTable.COMPANY_ID],
        registerNo = map[RegisterTable.REGISTER_NO],
        deviceKey = map[RegisterTable.DEVICE_KEY],
        serverId = map[RegisterTable.SERVER_ID],
        isUpload = map[RegisterTable.IS_UPLOADED];
}
