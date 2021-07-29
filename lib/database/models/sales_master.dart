class SalesMaster {
  int localId;
  int serverId;
  int customerId;
  String saleNo;
  int totalItems;
  double subTotal;
  double paidAmount;
  double dueAmount;
  String disc;
  String discActual;
  String vat;
  double totalPayable;
  int paymentMethodId;
  String closeTime;
  int tableId;
  double totalItemDiscountAmount;
  double subTotalWithDiscount;
  double subTotalDiscountAmount;
  double totalDiscountAmount;
  double deliveryCharge;
  double subTotalDiscountValue;
  double subTotalDiscountType;
  String saleDate;
  String dateTime;
  String orderTime;
  String cookingStartTime;
  String cookingDoneTime;
  String modified;
  int userId;
  int waiterId;
  int outletId;
  String orderStatus;
  String orderType;
  String delStatus;
  String saleVatObjects;
  String deviceKey;
  String companyId;
  bool isDelete;
  bool isUpload;
  String shift;

  static const String DINEIN = '1';
  static const String TAKEAWAY = '2';
  static const String DELIVERY = '3';

  SalesMaster(
      {this.serverId,
      this.customerId,
      this.saleNo,
      this.totalItems,
      this.subTotal,
      this.paidAmount,
      this.dueAmount,
      this.disc,
      this.discActual,
      this.vat,
      this.totalPayable,
      this.paymentMethodId,
      this.closeTime,
      this.tableId,
      this.totalItemDiscountAmount,
      this.subTotalWithDiscount,
      this.subTotalDiscountAmount,
      this.totalDiscountAmount,
      this.deliveryCharge,
      this.subTotalDiscountValue,
      this.subTotalDiscountType,
      this.saleDate,
      this.dateTime,
      this.orderTime,
      this.cookingStartTime,
      this.cookingDoneTime,
      this.modified,
      this.userId,
      this.waiterId,
      this.outletId,
      this.orderStatus,
      this.orderType,
      this.delStatus,
      this.saleVatObjects,
      this.deviceKey,
      this.localId,
      this.companyId,
      this.isDelete,
      this.isUpload});

  SalesMaster.fromMap(Map<String, dynamic> map)
      : localId = map[''],
        customerId = map[''],
        saleNo = map[''],
        totalItems = map[''],
        subTotal = map[''],
        paidAmount = map[''] != null
            ? double.tryParse(map[''].toString())
                .toStringAsFixed(2)
            : map[''],
        dueAmount = map[''],
        disc = map[''],
        discActual = map[''],
        vat = map[''],
        totalPayable = map[''],
        paymentMethodId = map[''],
        closeTime = map[''],
        tableId = map[''],
        totalItemDiscountAmount =
            map[''],
        subTotalWithDiscount =
            map[''] != null
                ? double.tryParse(
                        map[''])
                : map[''],
        subTotalDiscountAmount = map[''],
        totalDiscountAmount = map[''] != null
            ? double.tryParse(
                    map[''].toString())
                .toStringAsFixed(2)
            : map[''],
        deliveryCharge = map[''],
        subTotalDiscountValue = map[''],
        subTotalDiscountType = map[''],
        saleDate = map[''],
        dateTime = map[''],
        orderTime = map[''],
        cookingStartTime = map[''],
        cookingDoneTime = map[''],
        modified = map[''],
        userId = map[''],
        waiterId = map[''],
        outletId = map[''],
        orderStatus = map[''],
        orderType = map[''],
        delStatus = map[''],
        saleVatObjects = map[''],
        deviceKey = map[''],
        serverId = map[''],
        companyId = map[''],
        isDelete = map[''],
        isUpload = map[''],
        shift = map[''];
}
