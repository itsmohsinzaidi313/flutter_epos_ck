class Register {
  String id;
  String shift;
  String openingBalance;
  String closingBalance;
  String openingBalanceDateTime;
  String closingBalanceDateTime;
  String salePaidAmount;
  String customerDueReceive;
  String paymentMethodsSale;
  String registerStatus;
  String userId;
  String outletId;
  String companyId;
  String registerNo;
  String deviceKey;
  String remoteId; //local id
  String isUpload;

  Register(
      {this.id,
      this.shift,
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
      this.remoteId,
      this.isUpload});

  Register.fromMap(Map<String, dynamic> map)
      : remoteId = map[''].toString(),
        shift = map[''],
        openingBalance = map[''],
        closingBalance = map[''],
        openingBalanceDateTime = map[''],
        closingBalanceDateTime = map[''],
        salePaidAmount = map[''],
        customerDueReceive = map[''],
        paymentMethodsSale = map[''],
        registerStatus = map[''],
        userId = map[''],
        outletId = map[''],
        companyId = map[''],
        registerNo = map[''],
        deviceKey = map[''],
        id = map[''],
        isUpload = map[''];
}
