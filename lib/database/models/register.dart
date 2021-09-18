import 'package:pos_app/database/tables/database_tables.dart';

class Register {
  int localId;
  int serverId;
  int remoteId;
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
  int isUpload;

  Register(
      {this.localId,
      this.serverId,
      this.remoteId,
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
      this.isUpload});

  Register.fromMap(Map<String, dynamic> map)
      : localId = map[RegisterTable.LOCAL_ID],
        serverId = map[RegisterTable.SERVER_ID],
        remoteId = map[RegisterTable.REMOTE_ID],
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
        isUpload = map[RegisterTable.IS_UPLOADED];

  Map<String, dynamic> getMap() => {
        RegisterTable.LOCAL_ID: localId,
        RegisterTable.SERVER_ID: serverId,
        RegisterTable.REMOTE_ID: remoteId,
        RegisterTable.OPENING_BALANCE: openingBalance,
        RegisterTable.CLOSING_BALANCE: closingBalance,
        RegisterTable.OPENING_BALANCE_DATE_TIME: openingBalanceDateTime,
        RegisterTable.CLOSING_BALANCE_DATE_TIME: closingBalanceDateTime,
        RegisterTable.SALE_PAID_AMOUNT: salePaidAmount,
        RegisterTable.CUSTOMER_DUE_RECEIVE: customerDueReceive,
        RegisterTable.PAYMENT_METHODS_SALE: paymentMethodsSale,
        RegisterTable.REGISTER_STATUS: registerStatus,
        RegisterTable.USER_ID: userId,
        RegisterTable.OUTLET_ID: outletId,
        RegisterTable.COMPANY_ID: companyId,
        RegisterTable.REGISTER_NO: registerNo,
        RegisterTable.DEVICE_KEY: deviceKey,
        RegisterTable.IS_UPLOADED: isUpload,
      };
}
