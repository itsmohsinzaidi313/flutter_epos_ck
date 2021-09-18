import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/customer_order.dart';

class PrintingMaster {
  final int id;
  final String orderNo,
      dateTime,
      orderType,
      printType,
      covers,
      table,
      waiter,
      customerName,
      customerContact,
      customerAddress;
  final double amount, discount;
  PrintingMaster(
      {this.id,
      this.orderNo,
      this.dateTime,
      this.orderType,
      this.printType,
      this.covers,
      this.table,
      this.waiter,
      this.customerName,
      this.customerContact,
      this.customerAddress,
      this.amount,
      this.discount});

  PrintingMaster.fromOrder(
      {this.id = 0,
      this.table = '',
      this.waiter = '',
      this.printType = '',
      this.covers = '',
      Order order})
      : orderNo = order.orderNo,
        dateTime = order.date,
        orderType = order.orderType,
        amount = double.parse(order.totalTaxedAmount ?? '0.0'),
        discount = double.parse(order.discountedAmount ?? '0.0'),
        customerName = order.customer.name,
        customerContact = order.customer.contact,
        customerAddress = order.customer.address;

  PrintingMaster.fromMap({Map<String, dynamic> map})
      : id = map[PrintingMasterTable.ID],
        orderNo = map[PrintingMasterTable.ORDER_NO],
        dateTime = map[PrintingMasterTable.DATE_TIME],
        orderType = map[PrintingMasterTable.ORDER_TYPE],
        printType = map[PrintingMasterTable.PRINT_TYPE],
        covers = map[PrintingMasterTable.COVERS],
        amount = map[PrintingMasterTable.AMOUNT],
        discount = map[PrintingMasterTable.DISCOUNT],
        table = map[PrintingMasterTable.TABLE],
        waiter = map[PrintingMasterTable.WAITER_NAME],
        customerName = map[PrintingMasterTable.CUSTOMER_NAME],
        customerContact = map[PrintingMasterTable.CUSTOMER_CONTACT],
        customerAddress = map[PrintingMasterTable.CUSTOMER_ADDRESS];

  Map<String, dynamic> toMap() => {
        PrintingMasterTable.ORDER_NO: orderNo,
        PrintingMasterTable.DATE_TIME: dateTime,
        PrintingMasterTable.ORDER_TYPE: orderType,
        PrintingMasterTable.PRINT_TYPE: printType,
        PrintingMasterTable.COVERS: covers,
        PrintingMasterTable.AMOUNT: amount,
        PrintingMasterTable.DISCOUNT: discount,
        PrintingMasterTable.TABLE: table,
        PrintingMasterTable.WAITER_NAME: waiter,
        PrintingMasterTable.CUSTOMER_NAME: customerName,
        PrintingMasterTable.CUSTOMER_CONTACT: customerContact,
        PrintingMasterTable.CUSTOMER_ADDRESS: customerAddress,
      };
}
