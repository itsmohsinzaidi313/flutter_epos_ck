import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:pos_app/models/order_print.dart';
import 'package:pos_app/repositories/general_repository.dart';

Future<void> prePaymentSlip(OrderPrint order, NetworkPrinter printer) async {
  final qtyWidth = 2, itemWidth = 10;

  final orderInfoFontSize = PosTextSize.size1;
  final itemsFontSize = PosTextSize.size1;

  final company = await GeneralRepo.repo.getCurrentCompany();

  printer.text(company.name.toUpperCase(),
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
      linesAfter: 1);
  final infoWidthL = 6, infoWidthR = 6;
  if (company.address != null) {
    printer.text('ADDRESS: ${company.address}',
        styles: const PosStyles(
          align: PosAlign.center,
        ));
  }
  if (company.phone1 != null) {
    printer.text('CONTACT: ${company.phone1} ${company.phone2 ?? ''}',
        styles: const PosStyles(align: PosAlign.center));
  }
  if (company.email != null) {
    printer.text('EMAIL: ${company.email}',
        styles: const PosStyles(align: PosAlign.center));
  }
  printer.text('', linesAfter: 1);
  String orderType = '';
  if (order.master.orderType == '1') {
    orderType = 'DINE-IN';
  } else if (order.master.orderType == '2') {
    orderType = 'TAKE AWAY';
  } else if (order.master.orderType == '3') {
    orderType = 'DELIVERY';
  }

  printer.text('PRE-PAYMENT SLIP',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
      linesAfter: 1);
  printer.hr();
  printer.row([
    PosColumn(
        text: 'ORDER #:',
        width: infoWidthL,
        styles: PosStyles(
            align: PosAlign.left,
            bold: true,
            height: orderInfoFontSize,
            width: orderInfoFontSize)),
    PosColumn(
        text: order.master.orderNo.toUpperCase(),
        width: infoWidthR,
        styles: PosStyles(
            align: PosAlign.right,
            bold: true,
            height: orderInfoFontSize,
            width: orderInfoFontSize))
  ]);
  printer.row([
    PosColumn(
        text: 'DATE/TIME:',
        width: infoWidthL,
        styles: PosStyles(
            align: PosAlign.left,
            bold: true,
            height: orderInfoFontSize,
            width: orderInfoFontSize)),
    PosColumn(
        text: order.master.dateTime,
        width: infoWidthR,
        styles: PosStyles(
            align: PosAlign.right,
            bold: true,
            height: orderInfoFontSize,
            width: orderInfoFontSize))
  ]);
  printer.row([
    PosColumn(
        text: 'ORDER TYPE:',
        width: infoWidthL,
        styles: PosStyles(
            align: PosAlign.left,
            bold: true,
            height: orderInfoFontSize,
            width: orderInfoFontSize)),
    PosColumn(
        text: orderType.toUpperCase(),
        width: infoWidthR,
        styles: PosStyles(
            align: PosAlign.right,
            bold: true,
            height: orderInfoFontSize,
            width: orderInfoFontSize))
  ]);
  if (order.master.orderType == '1') {
    printer.row([
      PosColumn(
          text: 'WAITER:',
          width: infoWidthL,
          styles: PosStyles(
              align: PosAlign.left,
              bold: true,
              height: orderInfoFontSize,
              width: orderInfoFontSize)),
      PosColumn(
          text: order.master.waiter,
          width: infoWidthR,
          styles: PosStyles(
              align: PosAlign.right,
              bold: true,
              height: orderInfoFontSize,
              width: orderInfoFontSize))
    ]);
    printer.row([
      PosColumn(
          text: 'TABLE#:',
          width: infoWidthL,
          styles: PosStyles(
              align: PosAlign.left,
              bold: true,
              height: orderInfoFontSize,
              width: orderInfoFontSize)),
      PosColumn(
          text: order.master.table,
          width: infoWidthR,
          styles: PosStyles(
              align: PosAlign.right,
              bold: true,
              height: orderInfoFontSize,
              width: orderInfoFontSize))
    ]);
    printer.row([
      PosColumn(
          text: 'PERSON:',
          width: infoWidthL,
          styles: PosStyles(
              align: PosAlign.left,
              bold: true,
              height: orderInfoFontSize,
              width: orderInfoFontSize)),
      PosColumn(
          text: order.master.covers,
          width: infoWidthR,
          styles: PosStyles(
              align: PosAlign.right,
              bold: true,
              height: orderInfoFontSize,
              width: orderInfoFontSize))
    ]);
  } else if (order.master.orderType == '2') {
    printer.row([
      PosColumn(
          text: 'CUSTOMER NAME:',
          width: infoWidthL,
          styles: PosStyles(
              align: PosAlign.left,
              bold: true,
              height: orderInfoFontSize,
              width: orderInfoFontSize)),
      PosColumn(
          text: order.master.customerName,
          width: infoWidthR,
          styles: PosStyles(
              align: PosAlign.right,
              height: orderInfoFontSize,
              width: orderInfoFontSize))
    ]);
    printer.row([
      PosColumn(
          text: 'CUSTOMER CONTACT:',
          width: infoWidthL,
          styles: PosStyles(
              align: PosAlign.left,
              bold: true,
              height: orderInfoFontSize,
              width: orderInfoFontSize)),
      PosColumn(
          text: order.master.customerContact,
          width: infoWidthR,
          styles: PosStyles(
              align: PosAlign.right,
              bold: true,
              height: orderInfoFontSize,
              width: orderInfoFontSize))
    ]);
    if (order.master.orderType == '3') {
      printer.row([
        PosColumn(
            text: 'CUSTOMER ADDRESS:',
            width: infoWidthL,
            styles: PosStyles(
                align: PosAlign.left,
                bold: true,
                height: orderInfoFontSize,
                width: orderInfoFontSize)),
        PosColumn(
            text: order.master.customerAddress,
            width: infoWidthR,
            styles: PosStyles(
                align: PosAlign.right,
                bold: true,
                height: orderInfoFontSize,
                width: orderInfoFontSize))
      ]);
    }
  }

  printer.hr();
  printer.row([
    PosColumn(text: 'QTY', width: 1),
    PosColumn(text: 'ITEM', width: 7),
    PosColumn(
        text: 'PRICE', width: 2, styles: PosStyles(align: PosAlign.right)),
    PosColumn(
        text: 'TOTAL', width: 2, styles: PosStyles(align: PosAlign.right)),
  ]);
  printer.hr();
  for (var item in order.details) {
    printer.row([
      PosColumn(text: item.quantity.toString(), width: 1),
      PosColumn(text: item.itemName.toUpperCase(), width: 7),
      PosColumn(
          text: item.unitPrice.toString(),
          width: 2,
          styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: (item.quantity * item.unitPrice).toString(),
          width: 2,
          styles: PosStyles(align: PosAlign.right)),
    ]);
  }

  printer.hr(ch: '=', linesAfter: 1);
  printer.emptyLines(2);
  printer.text('POWERED BY DEVAJ TECHNOLOGY',
      styles: const PosStyles(
          align: PosAlign.center,
          underline: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1));
  printer.emptyLines(1);
}
