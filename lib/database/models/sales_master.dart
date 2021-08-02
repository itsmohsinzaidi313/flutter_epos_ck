import 'package:pos_app/bloc/payment_bloc/payment_bloc.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/shared/app_library.dart';

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
  String subTotalDiscountType;
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
  int companyId;
  int isDelete;
  int isUpload;
  String shift;

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
            ? double.tryParse(map[''].toString()).toStringAsFixed(2)
            : map[''],
        dueAmount = map[''],
        disc = map[''],
        discActual = map[''],
        vat = map[''],
        totalPayable = map[''],
        paymentMethodId = map[''],
        closeTime = map[''],
        tableId = map[''],
        totalItemDiscountAmount = map[''],
        subTotalWithDiscount =
            map[''] != null ? double.tryParse(map['']) : map[''],
        subTotalDiscountAmount = map[''],
        totalDiscountAmount = map[''] != null
            ? double.tryParse(map[''].toString()).toStringAsFixed(2)
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

  Map<String, dynamic> getMap() => {
        SalesMasterTable.CUSTOMER_ID: customerId ?? '0',
        SalesMasterTable.SALE_NO: saleNo,
        SalesMasterTable.TOTAL_ITEMS: totalItems ?? 0,
        SalesMasterTable.SUBTOTAL: subTotal ?? 0.0,
        SalesMasterTable.PAID_AMOUNT: paidAmount ?? 0.0,
        SalesMasterTable.DUE_AMOUNT: dueAmount ?? 0.0,
        SalesMasterTable.VAT: '0.0',
        SalesMasterTable.TOTAL_PAYABLE: subTotal,
        SalesMasterTable.PAYMENT_METHOD_ID: paymentMethodId,
        SalesMasterTable.CLOSE_TIME: closeTime,
        SalesMasterTable.TABLE_ID: tableId,
        SalesMasterTable.TOTAL_ITEM_DISCOUNT_AMOUNT: totalItemDiscountAmount,
        SalesMasterTable.SUBTOTAL_WITH_DISCOUNT: subTotalWithDiscount,
        SalesMasterTable.SUBTOTAL_DISCOUNT_AMOUNT: subTotalDiscountAmount,
        SalesMasterTable.DELIVERY_CHARGE: deliveryCharge,
        SalesMasterTable.SUBTOTAL_DISCOUNT_VALUE: subTotalDiscountValue,
        SalesMasterTable.SUBTOTAL_DISCOUNT_TYPE: subTotalDiscountType,
        SalesMasterTable.SALE_DATE: saleDate,
        SalesMasterTable.DATETIME: dateTime,
        SalesMasterTable.ORDER_TIME: orderTime,
        SalesMasterTable.COOKING_START_TIME: cookingStartTime,
        SalesMasterTable.COOKING_DONE_TIME: cookingDoneTime,
        SalesMasterTable.MODIFIED: modified,
        SalesMasterTable.USER_ID: userId,
        SalesMasterTable.WAITER_ID: waiterId,
        SalesMasterTable.OUTLET_ID: outletId,
        SalesMasterTable.ORDER_TYPE: orderType,
        SalesMasterTable.DEL_STATUS: delStatus,
        SalesMasterTable.DEVICE_KEY: deviceKey,
        SalesMasterTable.COMPANY_ID: companyId,
        SalesMasterTable.IS_DELETED: 0,
        SalesMasterTable.IS_UPLOADED: 0,
        SalesMasterTable.SHIFT: ''
      };

  SalesMaster.fromOrder(Order customerOrder)
      : customerId = int.parse(customerOrder.customer.id ?? '0'),
        saleNo = customerOrder.orderNo,
        totalItems = customerOrder.items.length,
        subTotal = double.parse(customerOrder.subTotal ?? '0.0'),
        paidAmount = double.parse(customerOrder.payment ?? '0.0'),
        dueAmount = double.parse(customerOrder.subTotal ?? '0.0'),
        vat = '0.0',
        totalPayable = double.parse(customerOrder.subTotal ?? '0.0'),
        paymentMethodId = customerOrder.paymentMode == PAYMENTMODE.CASH ? 1 : 2,
        closeTime = Lib.getCurrentTime24Format(),
        tableId = int.parse(customerOrder.tableId ?? '0'),
        totalItemDiscountAmount =
            double.parse(customerOrder.discountedAmount ?? '0.0'),
        subTotalWithDiscount = double.parse(customerOrder.subTotal ?? '0.0') +
            double.parse(customerOrder.discountedAmount ?? '0.0'),
        subTotalDiscountAmount =
            double.parse(customerOrder.discountedAmount ?? '0.0'),
        deliveryCharge = 0.0,
        subTotalDiscountValue = 0.0,
        subTotalDiscountType = 'plain',
        saleDate = customerOrder.register.openingBalanceDateTime,
        dateTime = Lib.getCurrentDateTimeWithFormat(),
        orderTime = Lib.getCurrentTime24Format(),
        cookingStartTime = Lib.getCurrentDateTimeWithFormat(),
        cookingDoneTime = Lib.getCurrentDateTimeWithFormat(),
        modified = 'No',
        userId = int.parse(customerOrder.userId),
        waiterId = int.parse(customerOrder.waiterId),
        outletId = int.parse(customerOrder.outletId),
        orderType = customerOrder.orderType,
        delStatus = 'Live',
        deviceKey = customerOrder.device.deviceKey,
        companyId = customerOrder.register.companyId,
        isDelete = 0,
        isUpload = 0,
        shift = '';
}
