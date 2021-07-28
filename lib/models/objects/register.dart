class Register {
  String localId;
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
  String serverId;
  String isUpload;

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
      : this.localId = map[''],
        this.openingBalance = map[''],
        this.closingBalance = map[''],
        this.openingBalanceDateTime =
            map[''],
        this.closingBalanceDateTime =
            map[''],
        this.salePaidAmount = map[''],
        this.customerDueReceive = map[''],
        this.paymentMethodsSale = map[''],
        this.registerStatus = map[''],
        this.userId = map[''],
        this.outletId = map[''],
        this.companyId = map[''],
        this.registerNo = map[''],
        this.deviceKey = map[''],
        this.serverId = map[''],
        this.isUpload = map[''];
}
